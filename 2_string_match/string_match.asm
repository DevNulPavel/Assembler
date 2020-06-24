; Экспортируем глобальную точку входа
global _start

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Секция кода приложения
section .text

; Функция match имеет следующие параметры
;  [ebp+8] - ячейка в памяти хранит указатель на проверяемую строку string
;  [ebp+12] - указатель на паттерн поиска, где * - любые символы, а ? - любой один символ
;  Возвращает eax==0 for false, eax==1 for true
match:
	; Заносим в стек прошлое значение регистра ebp
	push ebp
	; Записываем в ebp указатель на верхушку текущего стека, адреса растут в стеке
	; от большего к меньшему (вниз).
	; При вызове функции на верхушке стека лежит адрес возврата из функции,
	; затем идут параметры в прямом порядке
	mov ebp, esp
	; Отнимаем из регистра с указателем на стек 4
	sub esp, 4		; Локальная переменная индекса будет [ebp-4]
	; Затем вносим значение esi на стек
	push esi		; we use esi, edi  and eax,
	; И edi на стек, это специальные регистры для работы со строками
	push edi		; but eax is changed anyway
	; Записываем в esi адрес начала строки проверяемой
	mov esi, [ebp+8]	; esi always points to the string
	; Записываем в edi наш паттерн
	mov edi, [ebp+12]	; edi -------------------- pattern
; Метка, которая начинается с точки - это локальная подметка той, что выше (то есть match.again)
.again:
	; Сравниваем один байт памяти из адреса в регистре edi и 0
	cmp byte [edi], 0	; Паттерн закончился?
	; Если мы не дошли до конца, тогда переходим к метке .not_end
	jne .not_end
	; Сравниваем один байт из памяти по адресу в регистре esi
	cmp byte [esi], 0	; Строка закончилась?
	; Если не закончилась - делаем ближний переход на метку .false (ближний, значит в пределах +/- 127 байт по адресам)
	jne near .false		; Вышли за границы - возвращаем false
	; Иначе просто переходим на возврат .true
	jmp .true
.not_end:
	; Сравниваем, не встретился ли у нас символ * в паттерне поиска?
	cmp byte [edi], '*'
	; Если не звездочка - значит переходим к метке без звездочки
	jne .not_star ; now the "star cycle" begins
	; Если звездочка, значит начинаем цикл звездочки
	; Записываем в нашу локальную переменную индекса [ebp-4] значение ноль
	mov dword [ebp-4], 0	; I := 0
; Запускаем наш цикл
.star_loop:
	; Подготавливаемся к рекурсивному вызову
	; Записываем в eax наш символ
	mov eax, edi		; второй аргумент - это указатель на символ паттерн+1 (second arg of match is pattern+1)
	; Увеличиваем значение указателя на 1 байт
	inc eax
	; Заносим в стек наш указатель на байт паттерна
	push eax
	; Заносим в eax указатель на строку
	mov eax, esi		; first arg of match is string+I
	; Добавляем к нашему указателю значение TODO: ????
	add eax, [ebp-4]	; prepare the recursive call
	; Заносим в стек наш второй указатель
	push eax
	; Вызываем нашу функцию, на вершине стека будет адрес возврата, затем ниже будет параметр
	; проверяемой строки, затем будет уже идти параметр паттерна
	call match
	; Удаляем параметры из стека просто смещая указатель на 8 байт вверх, уменьшая стек
	add esp, 8		; remove params from stack
	; Сравниваем результат выполнения нашей функции
	test eax, eax		; what is returned, true or false?
	; Если функция вернула 1 - значи паттерн совпадает со строкой
	jnz .true		; if 1, then match is found, return 1
	; Иначе Проверяем, закончилась строка или нет
	add eax, [ebp-4]   
	cmp byte [esi+eax], 0	; may be string ended?
	; Если строка закончилась - значит благополучно выходим из приложения с обозначением, что параметры не совпадают
	je .false		; if so, no more possibilities to try
	; Если строка не закончилась, тогда увеличиваем индекс следующего проверяемого значения
	inc dword [ebp-4]	; I := I + 1
	; Пробуем снова
	jmp .star_loop		; try the next possibility
.not_star:
	mov al, [edi]		; we already know pattern isn't ended
	cmp al, '?'
	je .quest
	cmp al, [esi]		; if the string's over, this cmp fails
	jne .false		; as well as if the chars differ
	jmp .goon
.quest:
		cmp byte [esi], 0	; we only need to check for string end
		jz .false
.goon:
		inc esi 
		inc edi 
		jmp .again
.true:
	; Результат - true будет в eax
	mov eax, 1
	jmp .quit
.false:
	; Результат - false будет в eax
	xor eax, eax
.quit:
	; Извлекаем старые значения регистров
	pop edi
	pop esi
	; Извлекаем старый указатель на стек
	mov esp, ebp
	; Извлекаем ebp регистр
	pop ebp
	; Выходим из функции с восстановлением из стека адреса возврата
	ret

; MAIN PROGRAM
_start:
	pop eax
	cmp eax, 3
	jne wrong_args
	pop esi  ; ignore argv[0]
	pop esi  ; get argv[1]
	pop edi  ; get argv[2]
	mov [string], esi
	mov [pattern], edi

	push edi
	push esi
	call match
	add esp, 8
	test eax, eax
	jz print_no

	mov edx, 4		; print yes
	mov ecx, m_yes
	mov ebx, 1
	mov eax, 4
	int 80h
	jmp quit
print_no:			; print no
	mov edx, 4
	mov ecx, m_no
	mov ebx, 1
	mov eax, 4
	int 80h
	jmp quit

wrong_args:			; say wrong args
	; Заносим в edx количество выводимых символов
	mov edx, m_wrong_len
	; В ecx заносим указатель на строку
	mov ecx, m_wrong
	; TODO: ???
	mov ebx, 1
	mov eax, 4
	; Вызываем системное прерывание для вывода строки
	int 80h
	; Завершаем приложение
	jmp quit

quit:
	mov ebx, 0
	mov eax, 1
	int 80h	


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .bss

; Резервируем место для двойного слова под указатели размером 4 байта (двойное слово)
string		resd	1
pattern		resd	1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .data

; Резервируем строки с завершающимся нулем для вывода результатов
m_yes		db	"YES", 10
m_no		db	"NO ", 10
m_wrong		db	"Wrong arguments count, must be 2", 10
m_wrong_len	equ	$-m_wrong
