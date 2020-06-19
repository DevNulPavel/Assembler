global main

section .text
main: 
    mov eax, 0
again:  
    inc eax
    cmp eax, 5
    jl  again
    