/* Brick Sort - parallel Bubble sort 
   Implemented by: Ksenia Burova

   March 30th, 2018 */

#include <thrust/swap.h>
#include "../helper.h"
#include <cuda.h>
#include <chrono>

using namespace std;

__global__ void SortEven(int *d_arr, int size) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if ( i%2 == 0 && i < size -1) {
        if (d_arr[i] > d_arr[i+1])
            thrust::swap(d_arr[i], d_arr[i+1]);
    }
}

__global__ void SortOdd(int *d_arr, int size) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if ( i%2 == 1 && i < size -1) {
        if (d_arr[i] > d_arr[i+1])
            thrust::swap(d_arr[i], d_arr[i+1]);
    }
}

void sort(int *d_arr, int size, int num_blocks, int num_threads) {
    int i;
    for (i = 0; i <= size/2; i++) {
        SortEven <<< num_blocks, num_threads >>>(d_arr, size);
        SortOdd <<< num_blocks, num_threads >>>(d_arr,size);
    }
}

int main(int argc, char **argv) {

    int *h_arr, *d_arr;
    int size, step, max;
    int num_blocks, num_threads;
    double diff;
    chrono::high_resolution_clock::time_point start, stop;

    step = 1000;
    max = 10000000;

    h_arr = (int*)calloc(0,sizeof(int));
    
    for (size = 1000; size < max; size = 2*step, step = 1.1*step) {
        num_blocks = ceil(size/1024.0);
        num_threads = (num_blocks > 1) ? 1024 : size;
        
        h_arr = (int*)realloc(h_arr, sizeof(int) * size);
        populate_array(h_arr, size);
        
        cudaMalloc(&d_arr, sizeof(int)*size);
        cudaMemcpy(d_arr, h_arr, sizeof(int) * size, cudaMemcpyHostToDevice);
        
        start = chrono::high_resolution_clock::now();
        sort(d_arr, size, num_blocks, num_threads);
        stop = chrono::high_resolution_clock::now();
        diff = chrono::duration <double, milli> (stop-start).count();
        
        cudaMemcpy(h_arr, d_arr, sizeof(int) * size, cudaMemcpyDeviceToHost);
        cudaFree(d_arr);
        
        printf("%d%c%0.6f\n", size,'\t',diff);
        fflush(stdout);
    }

    free(h_arr);

    return 0;
}
