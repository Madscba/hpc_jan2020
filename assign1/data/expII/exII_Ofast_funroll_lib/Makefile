TARGET	= libmatmult.so
LIBSRCS	= matmult_nat.c matmult_lib.c
LIBOBJS	=  matmult_nat.o matmult_lib.o

OPT	= -g -Ofast -funroll-loops
PIC	= -fPIC

CC	= gcc
CFLAGS= $(OPT) $(PIC) $(XOPTS)

SOFLAGS = -shared 
XLIBS	= -L /usr/lib64/atlas -lsatlas

$(TARGET): $(LIBOBJS)
	$(CC) -o $@ $(SOFLAGS) $(CFLAGS) $(LIBOBJS) $(XLIBS)
matmult.o: 

clean:
	@/bin/rm -f core core.* $(LIBOBJS) 
