# Makefile
#
TARGET_J  = poisson_j		# Jacobi

SOURCES	= main.c print.c alloc3d.c matrix_init.c
OBJECTS	= print.o alloc3d.o matrix_init.o
MAIN_J	= main_j.o
OBJS_J	= $(MAIN_J) jacobi.o

# options and settings for the GCC compilers
#
CC	= gcc
DEFS	= 
OPT	= -O3 -funroll-loops -ffast-math -fopenmp
IPO	= 
ISA	= 
CHIP	= 
ARCH	= 
PARA	= 
CFLAGS	= $(DEFS) $(ARCH) $(OPT) $(ISA) $(CHIP) $(IPO) $(PARA) $(XOPTS)
LDFLAGS = -lm 

all: $(TARGET_J) 

$(TARGET_J): $(OBJECTS) $(OBJS_J)
	$(CC) -o $@ $(CFLAGS) $(OBJS_J) $(OBJECTS) $(LDFLAGS)


$(MAIN_J):
	$(CC) -o $@ -D_JACOBI $(CFLAGS) -c main.c 

clean:
	@/bin/rm -f core *.o *~

realclean: clean
	@/bin/rm -f $(TARGET_J)

# DO NOT DELETE

main_j.o: main.c print.h jacobi.h matrix_init.h matrix_overwrite.h
jacobi.o: jacobi.h
matrix_init.o: matrix_init.h
print.o: print.h
matrix_overwrite.o: matrix_overwrite.h
