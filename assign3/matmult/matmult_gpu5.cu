extern "C" {
#include <math.h>
#include <stdio.h>
#define BLOCK_SIZE 16
__global__ void kernel_gpu5(int m, int n, int k, double *A, double *B, double *C){
		//Block
		int y = blockIdx.y; //Row
      int x = blockIdx.x; //Col
      //Thread
      int i = threadIdx.y; //Row
    	int j = threadIdx.x; //Col

      double tmp = 0;
      double *C_sub = &C[y*n*BLOCK_SIZE + x*BLOCK_SIZE];


      for (int l=0; l< (k/BLOCK_SIZE); l++){

         double *A_sub = &A[l*BLOCK_SIZE + k*BLOCK_SIZE * y];
         double *B_sub = &B[l*BLOCK_SIZE*n + BLOCK_SIZE * x];
         __shared__ double tmp_A[BLOCK_SIZE][BLOCK_SIZE];
         __shared__ double tmp_B[BLOCK_SIZE][BLOCK_SIZE];
         tmp_A[i][j] = A_sub[i*k + j ];
         tmp_B[i][j] = B_sub[i*n + j];

         // Synchronize to make sure the sub-matrices are loaded
         // before starting the computation
         __syncthreads();

         for (int subM = 0; subM<BLOCK_SIZE; subM++) {
			   tmp += tmp_A[i][subM]*tmp_B[subM][j];
		   }
		   // Sync before moving on to new submatrices
        	__syncthreads();
      }
      C_sub[i*n + j] = tmp;
}
void matmult_gpu5(int m, int n, int k, double *A_h, double *B_h, double *C_h) 
   { 
      // Allocate A_d, B_d, C_d and transfer data 
      //Initialize variables
      double *A_d, *B_d, *C_d;
      int A_size = m*k*sizeof( double );
      int B_size = k*n*sizeof( double );
      int C_size = m*n*sizeof( double );
      // Allocate on device
      cudaMalloc( (void**)&A_d, A_size );
      cudaMalloc( (void**)&B_d, B_size );
      cudaMalloc( (void**)&C_d, C_size );
      //Copy to device from host
      cudaMemcpy(A_d, A_h, A_size, cudaMemcpyHostToDevice);
      cudaMemcpy(B_d, B_h, B_size, cudaMemcpyHostToDevice);

      //Define block grid
      dim3 block(BLOCK_SIZE,BLOCK_SIZE);
      dim3 grid(ceil((double) n/BLOCK_SIZE),  ceil((double) m/BLOCK_SIZE));
      // Launch kernel and synchronize
      kernel_gpu5<<<grid,block>>>(m,n,k,A_d,B_d,C_d);
      cudaDeviceSynchronize();

      cudaMemcpy(C_h, C_d, C_size, cudaMemcpyDeviceToHost);
      
      // Free A_d, B_d, C_d
      cudaFree(A_d);
      cudaFree(B_d);
      cudaFree(C_d);
   } 
}