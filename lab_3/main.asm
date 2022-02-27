.686
.model flat
extern _ExitProcess@4 : PROC
extern __read : PROC
extern __write : PROC
public _main
.data
	znaki_out db 12 dup (?)
	znaki_in db 12 dup (?)
	roz_dziesietne db 3 dup (?)
	dwanascie dd 12
.code
wczytaj_12_do_EAX PROC
	push ebx
	push ecx
	push edx
	push esi
	push edi
	push ebp

	push dword PTR 12
	push dword PTR OFFSET znaki_in
	push dword PTR 0
	call __read
	add esp, 12

	mov eax, 0
	mov ebx, OFFSET znaki_in

	pobieraj:
		mov cl, [ebx]
		inc ebx
		cmp cl,10
		je koniec
		cmp cl,'0'
		jb pobieraj
		cmp cl, '9'
		ja sprawdz_nast
		sub cl, 30H
		dodaj: movzx ecx, cl
		mul dword PTR dwanascie
		add eax, ecx
		jmp pobieraj

	sprawdz_nast:
		cmp cl, 'A'
		jb pobieraj
		cmp cl, 'B'
		ja sprawdz_nast2
		sub cl, 'A' - 10
	jmp dodaj

	sprawdz_nast2:
		cmp cl, 'a'
		jb pobieraj
		cmp cl, 'b'
		ja pobieraj
		sub cl, 'a' - 10
	jmp dodaj

	koniec:
	pop ebp
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	ret
wczytaj_12_do_EAX ENDP

wyswietl_EAX_dec PROC
	pusha
	mov esi, 10
	mov ebx, 10
	konwersja:
		mov edx, 0
		div ebx
		add dl, 30H
		mov znaki_out [esi], dl
		dec esi
		cmp eax, 0
		jne konwersja

	dodaj_spacje:
		or esi, esi
		jz gotowe
		mov byte PTR znaki_out [esi], 20H
		dec esi
		jmp dodaj_spacje

	gotowe:
	mov byte PTR znaki_out [0], 20H
	mov byte PTR znaki_out [11], '.' ; oddzielenie czesci calkowitej od dziesietnej
	push dword PTR 12
	push dword PTR OFFSET znaki_out
	push dword PTR 1
	call __write
	add esp, 12

	popa
	ret
wyswietl_EAX_dec ENDP

wyswietl_po_przecinku PROC
	pusha
	mov esi, 0
	mov ecx, 3
	konwersja:
		add roz_dziesietne[esi], 30H
		inc esi
	loop konwersja

	push dword PTR 3
	push dword PTR OFFSET roz_dziesietne
	push dword PTR 1
	call __write
	add esp, 12

	popa
	ret
wyswietl_po_przecinku ENDP

_main PROC
	;wczytanie dzielnej i dzielnika w kodzie 12
	call wczytaj_12_do_EAX 
	mov ebx, eax
	call wczytaj_12_do_EAX
	XCHG eax, ebx

	;obliczenie czesci calkowitej i zapisanie jej na stosie
	mov edx, 0
	div ebx
	push eax

	;liczenie rozwiniecia dziesietnego
	mov ecx, 3
	mov esi, OFFSET roz_dziesietne
	po_przecinku:
		mov eax, 10
		mul edx
		mov edx, 0
		div ebx
		mov [esi], al
		inc esi
	loop po_przecinku
	
	; pobranie czesci calkowitej ze stosu i wyswietlenie wyniku
	pop eax
	call wyswietl_EAX_dec
	call wyswietl_po_przecinku

	push 0
	call _ExitProcess@4
_main ENDP
END