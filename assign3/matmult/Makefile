TARGET	= libmatmult.so
LIBSRCS	= matmult_nat.cu matmult_lib.cu matmult_blk.cu matmult_gpu1.cu matmult_gpu2.cu matmult_gpu3.cu matmult_gpu4.cu matmult_gpulib.cu
LIBOBJS	= matmult_nat.o matmult_lib.o matmult_blk.o matmult_gpu1.o matmult_gpu2.o matmult_gpu3.o matmult_gpu4.o matmult_gpulib.o

OPT	  = -g -O3
PIC   = -fpic
OMP   = -fopenmp
XPIC  = -Xcompiler -fpic
XOPT  = -Xptxas=-v -lineinfo #-G # only use -G for debugging / profiler
XARCH = -arch=sm_80

CXX	= nvcc
CXXFLAGS = --compiler-options "$(OPT) $(PIC) $(OMP)" $(XARCH) $(XOPT) $(XPIC)

CUDA_PATH ?= /appl/cuda/11.5.1
INCLUDES = -I$(CUDA_PATH)/include \
	       -I$(CUDA_PATH)/samples/common/inc

SOFLAGS = -shared
XLIBS	= -lcublas -L /usr/lib64/atlas -lsatlas

$(TARGET): $(LIBOBJS)
	$(CXX) -o $@ $(CXXFLAGS) $(SOFLAGS) $(INCLUDES) $^ $(XLIBS)

.SUFFIXES: .cu
.cu.o:
	$(CXX) -o $*.o -c $*.cu $(CXXFLAGS) $(SOFLAGS) $(INCLUDES)

clean:
	/bin/rm -f $(TARGET) $(LIBOBJS) 
