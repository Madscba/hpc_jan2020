#ifndef _MATRIX_INIT_H
#define _MATRIX_INIT_H

void init_mat(int N,double start_T, double ***f, double ***u);
void init_f(int outer_size, double ***f);
void init_bounds(int outer_size,double mw_T, double sw_T, double ***matrix);
void init_inner(int outer_size,double start_T, double ***matrix);

#endif
