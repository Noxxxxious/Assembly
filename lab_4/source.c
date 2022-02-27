#include <stdio.h>
int dot_product(int tab[], int tab2[], int n);
int* merge(int tab1[], int tab2[], int n);
int main() {
	//Zadanie 1.
	int n = 3,  result, *result2;
	int tab[3], tab2[3];
	printf("Wprowadz elementy pierwszego wektora:\n");
	for (int i = 0; i < n; i++) {
		scanf_s("%d", &tab[i]);
	}
	printf("Wprowadz elementy drugiego wektora: \n");
	for (int i = 0; i < n; i++) {
		scanf_s("%d", &tab2[i]);
	}
	result = dot_product(tab, tab2, n);
	printf("Iloczyn skalarny wynosi %d", result);

	//--------------------------------------------------
	//Zadanie 2.
	int n1 = 0, tab3[100], tab4[100];
	printf("\n\nWprowadz rozmiar tablic:\n");
	scanf_s("%d", &n1);
	printf("Wprowadz elementy pierwszej tablicy:\n");
	for (int i = 0; i < n1; i++) {
		scanf_s("%d", &tab3[i]);
	}
		
	printf("\nWprowadz elementy drugiej tablicy: \n");
	for (int i = 0; i < n1; i++) {
		scanf_s("%d", &tab4[i]);
	}

	result2 = merge(tab3, tab4, n1);
	if (!result2)
		printf("\nRozmiar tablicy wykracza poza dozwolony rozmiar");
	else {
		printf("\nTablica po operacji merge to: ");
		int i;
		for (i = 0; i < n1 * 2; i++) {
			printf("%d ", result2[i]);
		}
	}
	return 0;
}