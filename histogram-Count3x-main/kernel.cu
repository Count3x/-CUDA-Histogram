#include <stdio.h>

__global__ void histo_kernel(unsigned int* input, unsigned int* bins, unsigned int num_elements, unsigned int num_bins)
{
	
    /*************************************************************************/
    // INSERT KERNEL CODE HERE
	unsigned int tid = blockIdx.x * blockDim.x + threadIdx.x;
    // Privatized bins
    extern __shared__ unsigned int bins_s[];
    for (unsigned int binIdx = threadIdx.x; binIdx < num_bins;
         binIdx += blockDim.x) {
        bins_s[binIdx] = 0;
    }
    __syncthreads();
    // Histogram
    for (unsigned int i = tid; i < num_elements; i += blockDim.x * gridDim.x) {
        atomicAdd(&(bins_s[(unsigned int) input[i]]), 1);
    }
    __syncthreads();
    // Commit to global memory
    for (unsigned int binIdx = threadIdx.x; binIdx < num_bins;
         binIdx += blockDim.x) {
        atomicAdd(&(bins[binIdx]), bins_s[binIdx]);
    }
	
	  /*************************************************************************/
}

void histogram(unsigned int* input, unsigned int* bins, unsigned int num_elements, unsigned int num_bins) {

	  /*************************************************************************/
    //INSERT CODE HERE
    dim3 blockDim(512), gridDim(30);
    histo_kernel<<<gridDim, blockDim, num_bins * sizeof(unsigned int)>>>
            (input, bins, num_elements, num_bins);

	  /*************************************************************************/

}


