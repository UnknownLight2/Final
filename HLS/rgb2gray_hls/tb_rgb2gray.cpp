#include <iostream>
#include <ap_int.h>

#define WIDTH  640
#define HEIGHT 480
#define SIZE   (WIDTH * HEIGHT)

void rgb2gray(
    ap_uint<8> r[SIZE],
    ap_uint<8> g[SIZE],
    ap_uint<8> b[SIZE],
    ap_uint<8> gray[SIZE]
);

int main() {
    static ap_uint<8> r[SIZE];
    static ap_uint<8> g[SIZE];
    static ap_uint<8> b[SIZE];
    static ap_uint<8> gray[SIZE];

    for (int i = 0; i < SIZE; i++) {
        r[i] = 100;
        g[i] = 150;
        b[i] = 200;
    }

    rgb2gray(r, g, b, gray);

    int expected = (77 * 100 + 150 * 150 + 29 * 200) >> 8;

    std::cout << "Gray[0] = " << gray[0] << std::endl;
    std::cout << "Expected = " << expected << std::endl;

    if (gray[0] == expected) {
        std::cout << "Test passed!" << std::endl;
        return 0;
    }

    std::cout << "Test failed!" << std::endl;
    return 1;
}