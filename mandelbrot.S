.section .data

header:
    .ascii "BM"
dummy_fields:
    .int 0
file_size:                          # change during execution
    .int 54
data_offset:
    .int 54
header_size:
    .int 40
width:
    .int WIDTH
height:
    .int HEIGHT
image_planes:
    .short 1
bpp:
    .short 32
compression:
    .int 0
image_size:                         # dummy 0
    .int 0
h_resolution:
    .int 1000
v_resolution:
    .int 1000
palette:                            # dummy 0
    .int 0
important_colors:                   # dummy 0
    .int 0

.equ header_len, . - header
.equ WIDTH,  1920
.equ HEIGHT, 1080
.equ BUFFER_WIDTH, 4 * WIDTH
.equ HALF_WIDTH, WIDTH / 2
.equ HALF_HEIGHT, HEIGHT / 2
.equ scale, 8

.lcomm buffer 4 * WIDTH

.section .text

.global main

main:
    movl width, %eax
    mull height
    sal  %eax
    sal  %eax                       # each pixel = 4 bytes, so mult by 4
    addl %eax, file_size            # file_size = header_size + pixel data size

    movq $1, %rax
    movq $1, %rdi
    movq $header, %rsi
    movq $header_len, %rdx
    syscall                         # write the header

    movq $0, %r9                    # r9 holds the row index
loop:                               # loop to write each row
    movq $0, %r8                    # r8 holds the col index
row_loop:                           # loop through each pixel in the row
