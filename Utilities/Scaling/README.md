How to make your own file:

1. 4 bit bmp image 64x64 pixels without header. The image starts at position 0x76. You can use "Scalar(Header).py" to cut off the header.
2. Use the program "IrfanView" and "Sonic.pal(or your palette)" to fix the palette of your image. IrfanView can replace an image palette with a JASC-PAL file. Also your image should be flipped vertically.
3. Use "Scalar(4to8).py" to make the right format for the art scaling subroutine.
4. Done.


main.bmp - is an example of a finished image to work with.

Scalar(8to4) - if you need to restore the original file.
