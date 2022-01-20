#include <cublas_v2.h>
extern "C" {


void matmult_gpulib(int m,int n,int k,double *A_h,double *B_h,double *C_h){
	cublasStatus_t stat; 
	cublasHandle_t handle; 
	stat = cublasCreate(&handle);


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
      cudaMemset(C_d, 0, C_size);

      //Copy to device from host
      cudaMemcpy(A_d, A_h, A_size, cudaMemcpyHostToDevice);
      cudaMemcpy(B_d, B_h, B_size, cudaMemcpyHostToDevice);
	  double alf = 1;
	  double bet = 0;
	  const double *alpha = &alf;
	  const double *beta = &bet;

	cublasDgemm(handle, CUBLAS_OP_N, CUBLAS_OP_N, n, m, k, alpha, B_d, n, A_d, k, beta, C_d,n);

	cudaMemcpy(C_h, C_d, C_size, cudaMemcpyDeviceToHost);
      
	// Free A_d, B_d, C_d
	cudaFree(A_d);
	cudaFree(B_d);
	cudaFree(C_d);
	
}
}
