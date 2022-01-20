
extern "C" {
__global__
void kernel_gpu1(int m, int n, int k, double *A, double *B, double *C){

	for(int i = 0; i< m; i++)
	{	
		for(int l = 0; l < k; l++)
		{
			for(int j = 0; j < n; j++)
			{
				C[i*n+j] += A[i*k+l] * B[l*n+j];
			}
			
		}
	}
}
void matmult_gpu1(int m, int n, int k, double *A_h, double *B_h, double *C_h) 
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
      cudaMemset(C_d, 0, C_size);

      //Copy to device from host
      cudaMemcpy(A_d, A_h, A_size, cudaMemcpyHostToDevice);
      cudaMemcpy(B_d, B_h, B_size, cudaMemcpyHostToDevice);
      // Launch kernel and synchronize 
      kernel_gpu1<<<1,1>>>(m,n,k,A_d,B_d,C_d);
      cudaDeviceSynchronize();

      cudaMemcpy(C_h, C_d, C_size, cudaMemcpyDeviceToHost);
      
      // Free A_d, B_d, C_d
      cudaFree(A_d);
      cudaFree(B_d);
      cudaFree(C_d);
   } 
}