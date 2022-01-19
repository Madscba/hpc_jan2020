/* main.c - Poisson problem in 3D
 *
 */
extern "C" {
    #include <stdio.h>
    #include <stdlib.h>
    #include <math.h>
    #include <string.h>
    #include <time.h>
    #include <omp.h>
    #include "alloc3d.h"
    #include "print.h"
    #include "matrix_init.h"
    #include "matrix_overwrite.h"

    #ifdef _JACOBI
    #include "jacobi.h"
    #endif

    #define N_DEFAULT 100

    int
    main(int argc, char *argv[]) {

        int 	N = N_DEFAULT;
        int 	iter_max = 1000;
        double	tolerance;
        double	start_T;
        int		output_type = 0;
        int     analytical = 0;
        char	*output_prefix = "poisson_res";
        char        *output_ext    = "";
        char	output_filename[FILENAME_MAX];
        int     lats;
        double  ts,te, mlups;
        double 	***u = NULL;
        double 	***u_old = NULL;
        double 	***f = NULL;


        /* get the paramters from the command line */
        N         = atoi(argv[1]);	// grid size
        iter_max  = atoi(argv[2]);  // max. no. of iterations
        tolerance = atof(argv[3]);  // tolerance
        start_T   = atof(argv[4]);  // start T for all inner grid points
        if (argc == 6) {
        output_type = atoi(argv[5]);  // ouput type
        }

        // allocate memory
        if ( (u = d_malloc_3d(N+2, N+2, N+2)) == NULL ) {
            perror("array u: allocation failed");
            exit(-1);
        }
        if ( (u_old = d_malloc_3d(N+2, N+2, N+2)) == NULL ) {
            perror("array u_old: allocation failed");
            exit(-1);
        }
        if ( (f = d_malloc_3d(N+2, N+2, N+2)) == NULL ) {
            perror("array f: allocation failed");
            exit(-1);
        }
        
        double delta_sqr = (2/(N+2))*(2/(N+2));
        // Init u and f
        init_mat(N,start_T,f,u);
        init_bounds(N+2,20, 0, u_old);
        int k = 0;
        // Loop until we meet stopping criteria
        ts = omp_get_wtime();
        while(k<iter_max)
        {
            m_overwrite(N,u,u_old);
            #ifdef _JACOBI
            jacobi(u,u_old,f,N,delta_sqr);
            #endif
            if ((k % 100) == 0)
            {   
            printf("%i \n", k);
            }
            k +=1;
        }
        te = omp_get_wtime();

        



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
        case 3:
            output_ext = ".bin";
            sprintf(output_filename, "%s_%d%s", output_prefix, N, output_ext);
            fprintf(stderr, "Write binary dump to %s: ", output_filename);
            print_binary(output_filename, N, u);
            break;
        case 4:
            output_ext = ".vtk";
            sprintf(output_filename, "%s_%d%s", output_prefix, N, output_ext);
            fprintf(stderr, "Write VTK file to %s: ", output_filename);
            print_vtk(output_filename, N+2, u);
            break;
        default:
            fprintf(stderr, "Non-supported output type!\n");
            break;
        }

        // de-allocate memory
        free(u);
        free(u_old);
        free(f);
        if (analytical)
        {
            free(u_ana);
        }
        

        return(0);
    }
}