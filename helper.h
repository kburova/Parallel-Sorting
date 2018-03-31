#include <ctime>
#include <cstdlib>
#include <cstdio>
#include <algorithm>

using namespace std;
void print_arr(int *arr, int size) {
    for (int i = 0; i < size; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");
}

void populate_array(int *h_arr, int n){
    srand(time(NULL));

    for (int i = 0; i < n; i++) {
        h_arr[i] = i;
    }
    for (int i = 0; i < n; i++) {
        int r = rand() % n;
        swap(h_arr[i], h_arr[r]);
    }
}
