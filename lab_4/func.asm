.686
.model flat
public _dot_product
public _merge
.data
	arr_out dd 8 dup (?)
.code
_dot_product PROC
	push ebp
	mov ebp,esp
	push ebx
	push esi
	push edi

	mov ebx, [ebp+8] ; adres pierwszej tablicy
	mov edi, [ebp+12] ; adres drugiej tablicy
	mov ecx, [ebp+16] ; liczba elementów
	mov edx, 0	; zerowanie przed mnozeniem
	mov esi, 0	; rejestr wynikowy

	ptl:
		mov eax, [ebx]	;pobranie elementu z pierwszej tablicy
		imul dword PTR [edi]	;przemnozenie przez element z drugiej tablicy
		add esi, eax	;dodawanie kolejnych iloczynów do wyniku
		; przesuniecie adresów do nastepnych elementów tablic
		add ebx, 4	
		add edi, 4
		loop ptl
	mov eax, esi	;przepisanie wyniku do rejestru eax
	pop edi
	pop esi
	pop ebx
	pop ebp
	ret
_dot_product ENDP
_merge PROC
	push ebp
	mov ebp,esp
	push ebx
	push esi
	push edi

	mov ebx, [ebp+8] ; adres pierwszej tablicy
	mov edi, [ebp+12] ; adres drugiej tablicy
	mov ecx, [ebp+16] ; licznik petli rowny liczbie elementow w tablicy
	cmp ecx, 4	
	jg error ; skok jesli n > 4
	mov esi, OFFSET arr_out	; adres tablicy wynikowej
	ptl:
		mov eax, [ebx]
		mov [esi], eax	; wpisanie liczby z pierwszej tablicy
		add esi, 4
		mov eax, [edi]
		mov [esi], eax	; wpisanie liczby z drugiej tablicy
		add esi, 4
		; przejscie do nastepnych elementow
		add ebx, 4
		add edi, 4
		loop ptl
	mov eax, OFFSET arr_out ; przepisanie adresu tablicy wynikowej na wyjœcie
	pop edi
	pop esi
	pop ebx
	pop ebp
	ret

	error:
	mov eax, 0 ; zwracany nullptr(0) w przypadku gdy przekroczono rozmiar
	pop edi
	pop esi
	pop ebx
	pop ebp
	ret
_merge ENDP
END