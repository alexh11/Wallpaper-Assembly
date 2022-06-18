.section .data

pixel:
    .int -1

header:
    .ascii "BM"
dummy_fields:
    .int 0
file_size:                      # change during execution
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
image_size:                     # dummy 0
    .int 0
h_resolution:
    .int 1000
v_resolution:
    .int 1000
palette:                        # dummy 0
    .int 0
important_colors:               # dummy 0
    .int 0
testx:
    .short 0
testy:
    .short 0

.equ header_len, . - header
.equ WIDTH,  2*1920
.equ HEIGHT, 2*1080
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
    sal  %eax                   # each pixel = 4 bytes, so mult by 4
    addl %eax, file_size        # file_size = header_size + pixel data size

    movq $1, %rax
    movq $1, %rdi
    movq $header, %rsi
    movq $header_len, %rdx
    syscall                     # write the header

    movq $0, %r9                # r9 holds the row index
loop:                           # loop to write each row
    movq $0, %r8                # r8 holds the col index
row_loop:                       # loop through each pixel in the row
    movq %r9, %rcx
    subq $HALF_HEIGHT, %rcx
    movq %rcx, %rax
    mulq %rcx
    mulq %rcx

    movq %rax, %rbx

    movq $HALF_WIDTH, %rcx
    subq %r8, %rcx
    movq %rcx, %rax
    mulq %rcx
    mulq %rcx

    addq %rbx, %rax
    js   next

    notq %rax
    incq %rax

next:
    call sqrt_scaled
    notq %rax
    incq %rax

    movq  %rax, %r11

    movq  %r8, %rax
    movq  $HALF_WIDTH, %rcx
    movq  $HALF_WIDTH, %r10
    cmp   $HALF_WIDTH, %rax
    cmovl %rax, %rcx
    cmovl %r10, %rax
    subq  %rcx, %rax
    movq  $0xff, %rbx
    mulq  %rbx
    movq  $HALF_WIDTH, %rbx
    divq  %rbx
    movq  %rax, %r12

    movq  %r9, %rax
    movq  $HALF_HEIGHT, %rcx
    movq  $HALF_HEIGHT, %r10
    cmp   $HALF_HEIGHT, %rax
    cmovl %rax, %rcx
    cmovl %r10, %rax
    subq  %rcx, %rax
    movq  $0xff, %rbx
    mulq  %rbx
    movq  $HALF_HEIGHT, %rbx
    divq  %rbx

    cmp %rax, %r12
    cmovg %r12, %rax

    movb $0xff, buffer+0(,%r8,4)
    movb %al,   buffer+1(,%r8,4)
    movb %r11b, buffer+2(,%r8,4)

    incq %r8
    cmp  $WIDTH, %r8            # increment col index and loop
    jle  row_loop

    movq $1, %rax
    movq $1, %rdi
    movq $buffer, %rsi
    movq $BUFFER_WIDTH, %rdx
    syscall                     # write the buffer

    inc  %r9
    cmp  $HEIGHT, %r9           # increment row index and loop
    jle  loop

    movq $60, %rax
    movq $0, %rdi
    syscall                     # exit(0)

sqrt_scaled:
    push %rbx
    push %rdx                   # push changing registers
    push %r8
    push %r9

    cmp $0, %rax
    je return

    movq $scale, %rbx
    movq %rax, %rdi
    mulq %rbx                   # adjust by scale

    movq %rax, %r8
    
    # algorithm

    movq %rax, %r9
    movq $0, %rdx
    movq %r8, %rax
    divq %r9
    addq %r9, %rax
    sarq %rax
    cmp $0, %rax
    je return
    movq %rax, %r9
    movq $0, %rdx
    movq %r8, %rax
    divq %r9
    addq %r9, %rax
    sarq %rax
    cmp $0, %rax
    je return
    movq %rax, %r9
    movq $0, %rdx
    movq %r8, %rax
    divq %r9
    addq %r9, %rax
    sarq %rax
    cmp $0, %rax
    je return
    movq %rax, %r9
    movq $0, %rdx
    movq %r8, %rax
    divq %r9
    addq %r9, %rax
    sarq %rax
    cmp $0, %rax
    je return
    movq %rax, %r9
    movq $0, %rdx
    movq %r8, %rax
    divq %r9
    addq %r9, %rax
    sarq %rax
    cmp $0, %rax
    je return
    movq %rax, %r9
    movq $0, %rdx
    movq %r8, %rax
    divq %r9
    addq %r9, %rax
    sarq %rax
    cmp $0, %rax
    je return
    movq %rax, %r9
    movq $0, %rdx
    movq %r8, %rax
    divq %r9
    addq %r9, %rax
    sarq %rax
    cmp $0, %rax
    je return
    movq %rax, %r9
    movq $0, %rdx
    movq %r8, %rax
    divq %r9
    addq %r9, %rax
    sarq %rax
    cmp $0, %rax
    je return
    movq %rax, %r9
    movq $0, %rdx
    movq %r8, %rax
    divq %r9
    addq %r9, %rax
    sarq %rax
    cmp $0, %rax
    je return
    movq %rax, %r9
    movq $0, %rdx
    movq %r8, %rax
    divq %r9
    addq %r9, %rax
    sarq %rax
    cmp $0, %rax
    je return
    movq %rax, %r9
    movq $0, %rdx
    movq %r8, %rax
    divq %r9
    addq %r9, %rax
    sarq %rax
    cmp $0, %rax
    je return
    movq %rax, %r9
    movq $0, %rdx
    movq %r8, %rax
    divq %r9
    addq %r9, %rax
    sarq %rax
    cmp $0, %rax
    je return
    movq %rax, %r9
    movq $0, %rdx
    movq %r8, %rax
    divq %r9
    addq %r9, %rax
    sarq %rax
    cmp $0, %rax
    je return
    movq %rax, %r9
    movq $0, %rdx
    movq %r8, %rax
    divq %r9
    addq %r9, %rax
    sarq %rax
    cmp $0, %rax
    je return
    movq %rax, %r9
    movq $0, %rdx
    movq %r8, %rax
    divq %r9
    addq %r9, %rax
    sarq %rax
    cmp $0, %rax
    je return
    movq %rax, %r9
    movq $0, %rdx
    movq %r8, %rax
    divq %r9
    addq %r9, %rax
    sarq %rax
    cmp $0, %rax
    je return
    movq %rax, %r9
    movq $0, %rdx
    movq %r8, %rax
    divq %r9
    addq %r9, %rax
    sarq %rax
    cmp $0, %rax
    je return
    movq %rax, %r9
    movq $0, %rdx
    movq %r8, %rax
    divq %r9
    addq %r9, %rax
    sarq %rax
    cmp $0, %rax
    je return
    movq %rax, %r9
    movq $0, %rdx
    movq %r8, %rax
    divq %r9
    addq %r9, %rax
    sarq %rax
    cmp $0, %rax
    je return
    movq %rax, %r9
    movq $0, %rdx
    movq %r8, %rax
    divq %r9
    addq %r9, %rax
    sarq %rax
    cmp $0, %rax
    je return

return:
    pop  %r9
    pop  %r8
    pop  %rdx
    pop  %rbx
    ret
