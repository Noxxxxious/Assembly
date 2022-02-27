.386
rozkazy SEGMENT use16
ASSUME CS:rozkazy
change_dir PROC
	cmp al, 77
	je change
	cmp al, 75
	je change
	cmp al, 72
	je change
	cmp al, 80
	je change
	jmp done
	change:
	mov cs:kierunek, al
	done:
	ret
change_dir ENDP

move_up PROC
mov bx, cs:licznik
mov byte PTR es:[bx], '^'
mov byte PTR es:[bx+1], 00000101B 
sub bx, 160
cmp bx, 0
jg end_up
add bx, 160*25
end_up:
ret
move_up ENDP
move_left PROC
mov bx, cs:licznik
mov byte PTR es:[bx], '<'
mov byte PTR es:[bx+1], 00000101B 
sub bx, 2
cmp bx, 0
ja end_left
add bx, 160
end_left:
ret
move_left ENDP
move_right PROC
mov bx, cs:licznik
mov byte PTR es:[bx], '>'
mov byte PTR es:[bx+1], 00000101B 
add bx, 2
cmp bx, 4000
jb end_right
sub bx, 160
end_right:
ret
move_right ENDP
move_down PROC
mov bx, cs:licznik
mov byte PTR es:[bx], 'v'
mov byte PTR es:[bx+1], 00000101B 
add bx, 160
cmp bx, 4000
jb end_down
sub bx, 160*25
end_down:
ret
move_down ENDP
;============================================================
; procedura obs³ugi przerwania zegarowego
obsluga_zegara PROC
; przechowanie u¿ywanych rejestrów
push ax
push bx
push es
; wpisanie adresu pamiêci ekranu do rejestru ES - pamiêæ
; ekranu dla trybu tekstowego zaczyna siê od adresu B8000H,
; jednak do rejestru ES wpisujemy wartoœæ B800H,
; bo w trakcie obliczenia adresu procesor ka¿dorazowo mno¿y
; zawartoœæ rejestru ES przez 16
mov ax, 0B800h ;adres pamiêci ekranu
mov es, ax

in al, 60h
cmp al, cs:kierunek
je skip
call change_dir
skip:

cmp cs:kierunek, 72
je up
cmp cs:kierunek, 75
je left
cmp cs:kierunek, 77
je right
cmp cs:kierunek, 80
je down
jmp wysw_dalej
up:
call move_up
jmp wysw_dalej
left:
call move_left
jmp wysw_dalej
right:
call move_right
jmp wysw_dalej
down:
call move_down 
;zapisanie adresu bie¿¹cego do zmiennej 'licznik'
wysw_dalej:
mov cs:licznik,bx
; odtworzenie rejestrów
pop es
pop bx
pop ax
; skok do oryginalnej procedury obs³ugi przerwania zegarowego
jmp dword PTR cs:wektor8
; dane programu ze wzglêdu na specyfikê obs³ugi przerwañ
; umieszczone s¹ w segmencie kodu
licznik dw 0 ; wyœwietlanie pocz¹wszy od 2. wiersza
wektor8 dd ?
kierunek db 80
obsluga_zegara ENDP
;============================================================
; program g³ówny - instalacja i deinstalacja procedury
; obs³ugi przerwañ
; ustalenie strony nr 0 dla trybu tekstowego
zacznij:
mov al, 0
mov ah, 5
int 10
mov ax, 0
mov ds,ax ; zerowanie rejestru DS
; odczytanie zawartoœci wektora nr 8 i zapisanie go
; w zmiennej 'wektor8' (wektor nr 8 zajmuje w pamiêci 4 bajty
; pocz¹wszy od adresu fizycznego 8 * 4 = 32)
mov eax,ds:[32] ; adres fizyczny 0*16 + 32 = 32
mov cs:wektor8, eax

; wpisanie do wektora nr 8 adresu procedury 'obsluga_zegara'
mov ax, SEG obsluga_zegara ; czêœæ segmentowa adresu
mov bx, OFFSET obsluga_zegara ; offset adresu
cli ; zablokowanie przerwañ
; zapisanie adresu procedury do wektora nr 8
mov ds:[32], bx ; OFFSET
mov ds:[34], ax ; cz. segmentowa
sti ;odblokowanie przerwañ
; oczekiwanie na naciœniêcie klawisza 'x'
aktywne_oczekiwanie:
mov ah,1
int 16H
; funkcja INT 16H (AH=1) BIOSu ustawia ZF=1 jeœli
; naciœniêto jakiœ klawisz
jz aktywne_oczekiwanie
; odczytanie kodu ASCII naciœniêtego klawisza (INT 16H, AH=0)
; do rejestru AL
mov ah, 0
int 16H
cmp al, 'x' ; porównanie z kodem litery 'x'
jne aktywne_oczekiwanie ; skok, gdy inny znak
; deinstalacja procedury obs³ugi przerwania zegarowego
; odtworzenie oryginalnej zawartoœci wektora nr 8
mov eax, cs:wektor8
cli
mov ds:[32], eax ; przes³anie wartoœci oryginalnej
; do wektora 8 w tablicy wektorów
; przerwañ
sti
; zakoñczenie programu
mov al, 0
mov ah, 4CH
int 21H
rozkazy ENDS
nasz_stos SEGMENT stack
db 128 dup (?)
nasz_stos ENDS
END zacznij
