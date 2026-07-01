#include <ap_int.h>

#define WIDTH  640
#define HEIGHT 480
#define SIZE   (WIDTH * HEIGHT)

void rgb2gray(
    ap_uint<8> r[SIZE],
    ap_uint<8> g[SIZE],
    ap_uint<8> b[SIZE],
    ap_uint<8> gray[SIZE]
) {
#pragma HLS INTERFACE m_axi port=r    offset=slave bundle=gmem
#pragma HLS INTERFACE m_axi port=g    offset=slave bundle=gmem
#pragma HLS INTERFACE m_axi port=b    offset=slave bundle=gmem
#pragma HLS INTERFACE m_axi port=gray offset=slave bundle=gmem

#pragma HLS INTERFACE s_axilite port=r     bundle=control
#pragma HLS INTERFACE s_axilite port=g     bundle=control
#pragma HLS INTERFACE s_axilite port=b     bundle=control
#pragma HLS INTERFACE s_axilite port=gray  bundle=control
#pragma HLS INTERFACE s_axilite port=return bundle=control

    for (int i = 0; i < SIZE; i++) {
#pragma HLS PIPELINE II=1
        gray[i] = (77 * r[i] + 150 * g[i] + 29 * b[i]) >> 8;
    }
}