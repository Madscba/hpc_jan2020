#include <math.h>
#include <stdio.h>
void init_inner(int outer_size,double start_T, double ***matrix)
{
	
	int loop_size = outer_size-1; //Should only init from 1-N+1
	int i,j,k;
	for(i = 1; i < loop_size; i++)
	{	
		for(j = 1; j < loop_size; j++)
		{
			for(k = 1; k < loop_size; k++)
			{

				matrix[i][j][k] = start_T;
			}
			
		}
	} /* for barrier ends */
}

void init_bounds(int outer_size,double mw_T, double sw_T, double ***matrix)
{
	//sw_T = single wall temperature
	//mw_T = multiple wall temperature
	int loop_size = outer_size-1; 
	int j,k;
	//x-z plane with y=1  (start phys (x,y,z)=(-1,1,-1), start idx (z,y,x)=(i,j,k)=(0->N+2 , 0 , 0->N+2)
	for(j = 1; j < loop_size; j++)
	{
		for(k = 1; k < loop_size; k++)
		{
			//     (z,y,x) (i,j,k)
			matrix[j][0][k] = mw_T;
			matrix[j][loop_size][k] = sw_T;
			matrix[loop_size][j][k] = mw_T;
			matrix[loop_size][j][k] = mw_T;
			matrix[0][j][k] = mw_T;
			matrix[j][k][loop_size] = mw_T;
			matrix[j][k][0] = mw_T;
		}
	}
}

void init_f(int outer_size,  double ***f)
{	
	int x_bound, y_bound, z_bound_start, z_bound_stop, i, j, k;
	int loop_size = outer_size-1; 

	// BE AWARE:
		//bounds have been given +1 or -1 since we use <=
		// Either "<" or ">" is used depending on which way we iterate
	x_bound = loop_size * (5.0/16.0) + 1.0;  	//outer_size/2 * (5/8) + 1
	y_bound = loop_size * (3.0/4.0) - 1.0; 	//outer_size/2 * (3/2) - 1
	z_bound_start = loop_size * (1.0/6.0) - 1.0; 	//outer_size/2 * (1/3)  
	z_bound_stop = loop_size/2.0 + 1.0; 

	for(i = z_bound_start; i < z_bound_stop; i++)
	{
		for(j = loop_size; j > y_bound; j--)
		{
			for(k = 0; k < x_bound; k++)
			{
				f[i][j][k] = 200.0;
			}
		}
		
	}
}

void init_mat(int N,double start_T, double ***f, double ***u){
	int outer_size = N + 2;
	
	/*m, matricen
	en væg 0 grader.
	(x,y,z) (k,j,i)*/

		//initialization of the grid of u and f

	init_inner(outer_size, 0, f);
	init_inner(outer_size,start_T,u);
	
	//initialization of boundaries
		/*arguments: 
			outer_size
			temperature for 5 walls
			temperature for wall in x-z plane with y=-1,
			matrix you would like to define boundaries for */
	init_bounds(outer_size,20, 0, u);
	init_bounds(outer_size,0, 0, f);
	
	//initialization of f radiator
	init_f(outer_size,f);
}
