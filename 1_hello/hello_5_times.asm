%include "stud_io.inc"

; Точка входа в приложение, экспортируем ее, аналог extern
global	_start


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Описываем секцию с неинициализированными данными приложения, указывая только их размер,
; размер нашего исполняемого файлика никак не меняется, так как это данные на стеке
section	.bss

; Резервируем 20 байт
string1:
	resb 20

; Резервируем 20*2 байт (слов)
string2:
	resw 20

; Резервируем 20*4 байт (двойных слов)
string3:
	resd 20

; Резервируем 1*4 байт (двойных слов) для использования в коде для счетчика оперативной памяти
count:
	dd 0


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Описываем секцию с фиксированнными данными,
; размер нашего исполняемого файлика увеличивается, так как это область статических данных
section	.data

; Резервируем 8 байт с конкретными значениями
values1:
	db 1,2,3,4,5,6,7,8

; Резервируем 8 слов с конкретными значениями
values2:
	dw 1,2,3,4,5,6,7,8

; Резервируем 8 двойных слов с конкретными значениями
values3:
	dw 0x1,0x2,0x3,0x4,0x5,0x6,0x7,0x8

; Резервируем сразу строку из байт c переносом строки в конце
message:
	db "This is text string",10


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Описываем секцию с кодом приложения, данные в данной секции являются неизменяемыми
; 
section	.text

; Ставим метку
_start:	
	; Записываем в eax 0
	mov	eax, 0
	mov [count], 10

again:
	; С помощью макроса выводим текст
    PRINT "Hello"
	; С помощью макроса выводим перенос строки
	PUTCHAR	10
	; Увеличиваем на 1 наш счетчик
	inc	eax
	; Сравниваем значение счетчика, результат пишется в регистр флагов
	cmp	eax, 5
	; Сравниваем значение в регистре флагов, если выставлен флаг меньше - переходим
	jl again
	; Иначе завершаем наше приложение
	FINISH
