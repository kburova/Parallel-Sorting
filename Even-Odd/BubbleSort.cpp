/* Bubble sort 
   Implemented by: Ksenia Burova

   March 30th, 2018 */

#include "../helper.h"
#include <iostream>
#include <chrono>

using namespace std;

void sort(int *h_arr, int size) {
    int i, j;
    bool swapped;
    
    for (i = 0; i < size-1; i ++) {
        swapped = 0;
        for (j = 0; j < size-i-1; j++) {
            if (h_arr[j] > h_arr[j+1])
                swap(h_arr[j], h_arr[j+1]);
            swapped = 1;
        }
        if (!swapped) break;
    }
}

int main(int argc, char **argv) {

    int *h_arr;
    int size, i, step, max;
    double diff;
    chrono::high_resolution_clock::time_point start, stop;

    step = 1000;
    max = 10000000;

    h_arr = (int*)calloc(0, sizeof(int));
    
    for ( size = 1000; size < max; size = 2*step, step *= 1.1) {
        h_arr = (int*)realloc(h_arr, sizeof(int)*size);
        populate_array(h_arr, size);
        
        start = chrono::high_resolution_clock::now();
        sort(h_arr, size);
        stop = chrono::high_resolution_clock::now();
        diff = chrono::duration <double, milli> (stop-start).count();

        printf("%d%c%0.6f\n", size,'\t',diff);
        fflush(stdout);
    }

    free(h_arr);
    return 0;
}
