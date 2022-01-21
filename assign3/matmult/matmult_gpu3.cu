extern "C" {
#include <math.h>
#include <stdio.h>
__global__ void kernel_gpu3(int m, int n, int k, double *A, double *B, double *C){
		int ti = blockIdx.y * blockDim.y + threadIdx.y;
		int tj = blockIdx.x * blockDim.x + threadIdx.x;
      double tmp1 = 0;
      double tmp2 = 0;
      double tmp_b;
      //printf("i = %d, j = %d \n",ti,tj);
      if (2*ti < m && tj < n){
         for (int l = 0; l < k; l++)
         {
            tmp_b = B[l*n + tj];
            tmp1 += A[2*ti*k + l] * tmp_b;
            tmp2 += A[(2*ti+1)*k + l] * tmp_b;
         }
         C[2*ti*n+tj] = tmp1;
         C[(2*ti+1)*n+tj] = tmp2;
         }
			
}
void matmult_gpu3(int m, int n, int k, double *A_h, double *B_h, double *C_h) 
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

      const int BLOCK_SIZE = 16;
      //Define block grid
      dim3 block(BLOCK_SIZE,BLOCK_SIZE/2);
      dim3 grid(ceil((double) n/BLOCK_SIZE),  ceil((double) m/BLOCK_SIZE));
      // Launch kernel and synchronize
      kernel_gpu3<<<grid,block>>>(m,n,k,A_d,B_d,C_d);
      cudaDeviceSynchronize();

      cudaMemcpy(C_h, C_d, C_size, cudaMemcpyDeviceToHost);
      
      // Free A_d, B_d, C_d
      cudaFree(A_d);
      cudaFree(B_d);
      cudaFree(C_d);
   } 
}