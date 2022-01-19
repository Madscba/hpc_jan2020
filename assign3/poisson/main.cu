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
    const int device = 0;   // Set the device to 0 or 1.

    // Wake up GPU from power save state.
    printf("Warming up device %i ... \n", device); fflush(stdout);
    cudaSetDevice(device);           // Set the device to 0 or 1.
    double *dummy_d;
    cudaMalloc((void**)&dummy_d, 0);

    double 	***u_h = NULL;
    double 	***u_old_h = NULL;
    double 	***f_h = NULL;
    double 	***u_d = NULL;
    double 	***u_old_d = NULL;
    double 	***f_d = NULL;
    int NUM_BLOCKS, THREADS_PER_BLOCK;


    int 	iter_max = 1000;
    double	start_T = 16.0;
    int		output_type = 0;
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

    printf("N=%i iter_max=%i, NUM_BLOCKS=%i, THREADS_PER_BLOCK=%i, device=%i \n",N,iter_max,NUM_BLOCKS,THREADS_PER_BLOCK,device); fflush(stdout);

    const long nElms = N * N * N; // Number of elements.

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

    printf("Allocated memory to host \n"); fflush(stdout);
    
    double delta_sqr = (2/(N+2))*(2/(N+2));
    // Init u and f
    init_mat(N,start_T,f_h,u_old_h);
    printf("Initialized u and f \n"); fflush(stdout);
    init_bounds(N+2,20, 0, u_old_h);
    printf("Initialized boundaries \n"); fflush(stdout);


    // Allocate 3d array on device 0 memory
    if ( (u_d = d_malloc_3d_gpu(N+2, N+2, N+2)) == NULL ) {
        perror("array u_d0: allocation on gpu failed");
        exit(-1);
    }
    if ( (u_old_d = d_malloc_3d_gpu(N+2, N+2, N+2)) == NULL ) {
        perror("array u_d0: allocation on gpu failed");
        exit(-1);
    }
    if ( (f_d = d_malloc_3d_gpu(N+2, N+2, N+2)) == NULL ) {
        perror("array u_d0: allocation on gpu failed");
        exit(-1);
    }

    printf("Allocated memory to device \n"); fflush(stdout);


    // Transfer to device 0.
    transfer_3d_from_1d(u_d, u_h[0][0], N+2, N+2, N+2, cudaMemcpyHostToDevice);
    transfer_3d_from_1d(u_old_d, u_old_h[0][0], N+2, N+2, N+2, cudaMemcpyHostToDevice);
    transfer_3d_from_1d(f_d, f_h[0][0], N+2, N+2, N+2, cudaMemcpyHostToDevice);


    printf("Transfered data \n"); fflush(stdout);
    int k = 0;
    // Loop until we meet stopping criteria
    ts = omp_get_wtime();
    double** temp;

    while(k<iter_max)
    {
        printf("U[2][2][2]=%d.5 \n",u_d[2][2][2]); fflush(stdout);
        printf("U_old[2][2][2]=%d.5 \n",u_old_d[2][2][2]); fflush(stdout);
        #ifdef _JACOBI
        // Execute kernel function
        jacobi<<<1,1>>>(u_d,u_old_d,f_d,N,delta_sqr);
        checkCudaErrors(cudaDeviceSynchronize());
        #endif
        if ((k % 100) == 0)
        {   
            printf("%i \n", k);
        }
        printf("U[2][2][2]=%f.5 \n",u_d[2][2][2]); fflush(stdout);
        printf("U_old[2][2][2]=%f.5 \n",u_old_d[2][2][2]); fflush(stdout);
        temp = *u_d;
        **u_old_d = *temp;
        k +=1;
        printf("U[2][2][2]=%f.5 \n",u_d[2][2][2]); fflush(stdout);
        printf("U_old[2][2][2]=%f.5 \n",u_old_d[2][2][2]); fflush(stdout);
    }
    te = omp_get_wtime();

    // Transfer back
    transfer_3d(u_h,u_d,N+2,N+2,N+2,cudaMemcpyDeviceToHost);
   
    printf("Transfered data back \n"); fflush(stdout);

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
