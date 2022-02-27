.686
.XMM
.model flat
public _objetosc_stozka
public _szybki_max
.data
	three dd 3.0
.code
_objetosc_stozka PROC
	push ebp
	mov ebp, esp

	fild dword ptr [ebp+8]
	fst st(1)
	fmul st(1), st(0)
	fild dword ptr [ebp+12]
	fmul st(1), st(0)
	fmul st(0), st(0)
	fadd
	fadd
	fld dword ptr [ebp+16]
	fldpi
	fmul
	fmul
	fld three
	fdiv

	pop ebp
	ret
_objetosc_stozka ENDP
_szybki_max PROC
	push ebp
	mov ebp, esp
	push ebx
	push esi

	mov ebx, [ebp+8]
	mov esi, [ebp+12]
	movups xmm0, [ebx]
	movups xmm1, [esi]
	pmaxsw xmm0, xmm1

	pop esi
	pop ebx
	pop ebp
	ret
_szybki_max ENDP
END