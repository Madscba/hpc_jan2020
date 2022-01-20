/* main.c - Poisson problem in 3D
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <helper_cuda.h>
#include <time.h>
#include <cuda.h>
#include <cuda_runtime.h>
#include <omp.h>
#include "print.h"
#include "alloc3d.h"
#include "alloc3d_gpu.h"
#include "transfer3d_gpu.h"
#include "matrix_init.h"
#include "matrix_overwrite.h"

#ifdef _JACOBI
#include <jacobi.h>
#endif

int
main(int argc, char *argv[]) {

    int N;                  // Dimension N x N x N.

    // Wake up GPU from power save state.
    //printf("Warming up device %i ... \n", device); fflush(stdout);
    cudaSetDevice(0);           // Set the device to 0 or 1.
    cudaDeviceEnablePeerAccess(1, 0); //Give read access to GPU 1
    double *dummy_d;
    cudaMalloc((void**)&dummy_d, 0);

    double 	***u_h = NULL;
    double 	***u_old_h = NULL;
    double 	***f_h = NULL;
    double*** temp;
    int NUM_BLOCKS, THREADS_PER_BLOCK;


    int 	iter_max = 1000;
    double	start_T = 16.0;
    int		output_type = 1;
    char	*output_prefix = "poisson_res";
    char        *output_ext    = "";
    char	output_filename[FILENAME_MAX];
    int     lats;
    double  ts,te, mlups;


    /* get the paramters from the command line */
    N         = atoi(argv[1]);	// grid size
    iter_max  = atoi(argv[2]);  // max. no. of iterations
    NUM_BLOCKS  = atoi(argv[3]);  // no. of blocks
    THREADS_PER_BLOCK  = atoi(argv[4]);  // no. of threads per block
    if (argc == 6) {
    output_type = atoi(argv[5]);  // ouput type
    }

    const long nElms = (N+2) * (N+2) * (N+2); // Number of elements.

    // Allocate 3d array in host memory.
    if ( (u_h = d_malloc_3d(N+2, N+2, N+2)) == NULL ) {
        perror("array u: allocation failed");
        exit(-1);
    }
    if ( (u_old_h = d_malloc_3d(N+2, N+2, N+2)) == NULL ) {
        perror("array u: allocation failed");
        exit(-1);
    }
    if ( (f_h = d_malloc_3d(N+2, N+2, N+2)) == NULL ) {
        perror("array u: allocation failed");
        exit(-1);
    }
    
    double delta_sqr = (2/(N+2))*(2/(N+2));
    // Init u and f
    init_mat(N,start_T,f_h,u_old_h);
    init_bounds(N+2,20, 0, u_old_h);


    // Allocate 3d array on device 0 memory
    if ( (u_d0 = d_malloc_3d_gpu((N+2) / 2, N+2, N+2)) == NULL ) {
        perror("array u_d0: allocation on gpu failed");
        exit(-1);
    }
    if ( (u_old_d0 = d_malloc_3d_gpu((N+2) / 2, N+2, N+2)) == NULL ) {
        perror("array u_d0: allocation on gpu failed");
        exit(-1);
    }
    if ( (f_d0 = d_malloc_3d_gpu((N+2) / 2, N+2, N+2)) == NULL ) {
        perror("array u_d0: allocation on gpu failed");
        exit(-1);
    }

    // Transfer top part to device 0.
    transfer_3d_from_1d(u_d0, u_h[0][0], (N+2) / 2, N+2, N+2, cudaMemcpyHostToDevice);
    transfer_3d_from_1d(u_old_d0, u_old_h[0][0], (N+2) / 2, N+2, N+2, cudaMemcpyHostToDevice);
    transfer_3d_from_1d(f_d0, f_h[0][0], (N+2) / 2, N+2, N+2, cudaMemcpyHostToDevice);


    double 	***u_d1 = NULL;
    double 	***u_old_d1 = NULL;
    double 	***f_d1 = NULL;
    cudaSetDevice(1);
	cudaDeviceEnablePeerAccess(0, 0); //Give read access to GPU 0
    // Allocate 3d array of half size in device 1 memory.
    if ( (u_d1 = d_malloc_3d_gpu((N+2) / 2, N+2, N+2)) == NULL ) {
        perror("array u_d1: allocation on gpu failed");
        exit(-1);
    }
    if ( (u_old_d1 = d_malloc_3d_gpu((N+2) / 2, N+2, N+2)) == NULL ) {
        perror("array u_d1: allocation on gpu failed");
        exit(-1);
    }
    if ( (f_d1 = d_malloc_3d_gpu((N+2) / 2, N+2, N+2)) == NULL ) {
        perror("array u_d1: allocation on gpu failed");
        exit(-1);
    }

    // Transfer bottom part to device 1.
    transfer_3d_from_1d(u_d1, u_h[0][0] + nElms / 2, (N+2) / 2, N+2, N+2, cudaMemcpyHostToDevice);
    transfer_3d_from_1d(u_old_d1, u_old_h[0][0] + nElms / 2, (N+2) / 2, N+2, N+2, cudaMemcpyHostToDevice);
    transfer_3d_from_1d(f_d1, f_h[0][0] + nElms / 2, (N+2) / 2, N+2, N+2, cudaMemcpyHostToDevice);


    dim3 dimGrid(N/2,N/2,1); // 4096 blocks in total 
    dim3 dimBlock(N,N,1);// 256 threads per block

    int k = 0;
    // Loop until we meet stopping criteria
    ts = omp_get_wtime();
    while(k<iter_max)
    {
        #ifdef _JACOBI
        // Execute kernel function
        jacobi<<<dimGrid,dimBlock>>>(u_d0,u_old_d0,f_d0,N,delta_sqr);
        jacobi<<<dimGrid,dimBlock>>>(u_d1,u_old_d1,f_d1,N,delta_sqr);
        checkCudaErrors(cudaDeviceSynchronize());
        #endif
        temp = u_old_d;
        u_old_d = u_d;
        u_d  = temp;
        k+=1;
    }
    te = omp_get_wtime();
    
    // Transfer back top part
    transfer_3d(u_h,u_d0,N+2,N+2,N+2,cudaMemcpyDeviceToHost);
    transfer_3d(u_h,u_d0,N+2,N+2,N+2,cudaMemcpyDeviceToHost);

    // dump  results if wanted 
    switch(output_type) {
    case 0:
        // no output at all
        break;
    case 1:
        lats = N*N*N;
        mlups = (double) lats*k/((te-ts)*1000*1000);
        printf("%d %.5f %.5f %d \n",N,mlups, te-ts, omp_get_max_threads());
        break;
        
    output_ext = ".vtk";
    sprintf(output_filename, "%s_%d%s", output_prefix, N, output_ext);
    fprintf(stderr, "Write VTK file to %s: ", output_filename);
    print_vtk(output_filename, N+2, u_h);
    // de-allocate memory
    free(u_h);
    free(u_old_h);
    free(f_h);
    free_gpu(u_d);
    free_gpu(u_old_d);
    free_gpu(f_d);
    return(0);
    }
}
