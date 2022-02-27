#include <stdio.h>
#include <xmmintrin.h>
float objetosc_stozka(unsigned int big_r, unsigned int small_r, float h);
__m128 szybki_max(short int t1[], short int t2[]);
int main() {
	//ZAD1
	printf("%f\n", objetosc_stozka(6, 2, 5.3));
	printf("%f\n", objetosc_stozka(7, 3 ,4.2));
	printf("%f\n\n", objetosc_stozka(8, 4, 6.1));

	//ZAD2
	short int val1[8] = { 1, -1, 2, -2, 3, -3, 4, -4 };
	short int val2[8] = { -4, -3, -2, -1, 0, 1, 2, 3 };
	__m128 t1 = szybki_max(val1, val2);
	int i;
	for (i = 0; i < 8; i++) {
		printf("%d\n", t1.m128_i16[i]);
	}
	return 0;
}