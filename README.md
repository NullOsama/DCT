# DCT
Image compressor using Discrete cosine transform DCT


### Encode-Decode Algorithm:

# Encoding part:

1 First we transform the image to YCbCr colour space

2 Shift the pixels by 128 so the pixel range is (-128, 128)

3 Divide the image to set of 8 by 8 blocks so we can apply discrete cosine transform on each block

4 Apply discrete cosine transform on the blocks

5 Quantize each block by dividing it by the Quantization matrix

6 Use Run-Length encoding on each block to trnasfare them into encoded vectors

7 Reduce the size of these vectors by trimming the zeros at the end of each on.


# Decoding Part:

1 Reconstruct the reuduced vectors to set of fixed size (of length 64) vectors

2 Use Run-Length to decode each vector into 2D block of size 8 by 8

3 Dequantize each block by maltiplying with the quantization matrix

4 Apply inverse descrete cosine transform on each block

5 Combine The 8 by 8 Blocks into One image

6 Shift the pixels by 128 so the pixel range is (0, 256)

7 First we transform the image to RGB colour space

## Note:
You can control the compression ratio by setting the quantization factor, where higher values mean higher compression rate but lower quality.

