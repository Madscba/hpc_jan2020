# Makefile
#
TARGET_J  = poisson_j		# Jacobi
TARGET_GS = poisson_gs		# Gauss-Seidel

SOURCES	= main.c print.c alloc3d.c frobenius.c matrix_init.c matrix_overwrite.c xtime.c
OBJECTS	= print.o alloc3d.o frobenius.o matrix_init.o matrix_overwrite.o xtime.o
MAIN_J	= main_j.o
MAIN_GS = main_gs.o
OBJS_J	= $(MAIN_J) jacobi.o
OBJS_GS	= $(MAIN_GS) gauss_seidel.o

# options and settings for the GCC compilers
#
CC	= gcc
DEFS	= 
OPT	= -g -O3 -funroll-loops -ffast-math -fopenmp
IPO	= 
ISA	= 
CHIP	= 
ARCH	= 
PARA	= 
CFLAGS	= $(DEFS) $(ARCH) $(OPT) $(ISA) $(CHIP) $(IPO) $(PARA) $(XOPTS)
LDFLAGS = -lm 

all: $(TARGET_J) $(TARGET_GS) 

$(TARGET_J): $(OBJECTS) $(OBJS_J)
	$(CC) -o $@ $(CFLAGS) $(OBJS_J) $(OBJECTS) $(LDFLAGS)

$(TARGET_GS): $(OBJECTS) $(OBJS_GS)
	$(CC) -o $@ $(CFLAGS) $(OBJS_GS) $(OBJECTS) $(LDFLAGS)

$(MAIN_J):
	$(CC) -o $@ -D_JACOBI $(CFLAGS) -c main.c 

$(MAIN_GS):
	$(CC) -o $@ -D_GAUSS_SEIDEL $(CFLAGS) -c main.c 

clean:
	@/bin/rm -f core *.o *~

realclean: clean
	@/bin/rm -f $(TARGET_J)  $(TARGET_GS)

# DO NOT DELETE

main_j.o: main.c print.h jacobi.h frobenius.h matrix_init.h matrix_overwrite.h xtime.h
main_gs.o: main.c print.h gauss_seidel.h frobenius.h matrix_init.h matrix_overwrite.h xtime.h
jacobi.o: jacobi.h
gauss_seidel.o: gauss_seidel.h
frobenious.o: frobenius.h
matrix_init.o: matrix_init.h
print.o: print.h
xtime.o: xtime.h
matrix_overwrite.o: matrix_overwrite.h
