# Fall 2025
# Team Members:    Jonah Camacho Daniel Rivera Alex Melde
# % Effort    :       34%         33%            33%
#
# ECE369A,  
# 

########################################################################################################################
### data
########################################################################################################################
.data
# test input
# asize : dimensions of the frame [i, j] and window [k, l]
#         i: number of rows,  j: number of cols
#         k: number of rows,  l: number of cols  
# frame : frame data with i*j number of pixel values
# window: search window with k*l number of pixel values
#
# $v0 is for row / $v1 is for column

# test 0 For the 4x4 frame size and 2X2 window size
# small size for validation and debugging purpose
# The result should be 0, 2
asize0:  .word    4,  4,  2, 2    #i, j, k, l
frame0:  .word    0,  0,  1,  2, 
         .word    0,  0,  3,  4
         .word    0,  0,  0,  0
         .word    0,  0,  0,  0, 
window0: .word    1,  2, 
         .word    3,  4, 
# test 1 For the 16X16 frame size and 4X4 window size
# The result should be 12, 12
asize1:  .word    16, 16, 4, 4    #i, j, k, l
frame1:  .word    0, 1, 2, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
         .word    1, 2, 3, 4, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 
         .word    2, 3, 32, 1, 2, 3, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 
         .word    3, 4, 1, 2, 3, 4, 18, 21, 24, 27, 30, 33, 36, 39, 42, 45, 
         .word    0, 4, 2, 3, 4, 5, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 
         .word    0, 5, 3, 4, 5, 6, 30, 35, 40, 45, 50, 55, 60, 65, 70,  75, 
         .word    0, 6, 12, 18, 24, 30, 36, 42, 48, 54, 60, 66, 72, 78, 84, 90, 
         .word    0, 4, 14, 21, 28, 35, 42, 49, 56, 63, 70, 77, 84, 91, 98, 105, 
         .word    0, 8, 16, 24, 32, 40, 48, 56, 64, 72, 80, 88, 96, 104, 112, 120, 
         .word    0, 9, 18, 27, 36, 45, 54, 63, 72, 81, 90, 99, 108, 117, 126, 135, 
         .word    0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 
         .word    0, 11, 22, 33, 44, 55, 66, 77, 88, 99, 110, 121, 132, 143, 154, 165, 
         .word    0, 12, 24, 36, 48, 60, 72, 84, 96, 108, 120, 132, 0, 1, 2, 3, 
         .word    0, 13, 26, 39, 52, 65, 78, 91, 104, 114, 130, 143, 1, 2, 3, 4, 
         .word    0, 14, 28, 42, 56, 70, 84, 98, 112, 126, 140, 154, 2, 3, 4, 5, 
         .word    0, 15, 30, 45, 60, 75, 90, 105, 120, 135, 150, 165, 3, 4, 5, 6 
window1: .word    0, 1, 2, 3, 
         .word    1, 2, 3, 4, 
         .word    2, 3, 4, 5, 
         .word    3, 4, 5, 6 

# test 2 For the 16X16 frame size and a 4X8 window size
# The result should be 0, 4
asize2:  .word    16, 16, 4, 8    #i, j, k, l
frame2:  .word    7, 5, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
         .word    7, 5, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
         .word    7, 5, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
         .word    7, 5, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
         .word    0, 4, 2, 3, 4, 5, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 
         .word    0, 5, 3, 4, 5, 6, 30, 35, 40, 45, 0, 0, 0, 0, 70,  75, 
         .word    0, 6, 12, 18, 24, 30, 36, 42, 48, 54, 0, 0, 0, 0, 84, 90, 
         .word    0, 4, 8, 8, 8, 8, 42, 49, 56, 63, 0, 0, 0, 0, 98, 105, 
         .word    0, 1, 8, 8, 8, 8, 48, 56, 64, 72, 0, 0, 0, 0, 112, 120, 
         .word    0, 1, 8, 8, 8, 8, 54, 63, 72, 81, 90, 99, 108, 117, 126, 135, 
         .word    0, 10, 8, 8, 8, 8, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 
         .word    0, 11, 22, 33, 44, 55, 66, 77, 88, 99, 110, 121, 132, 143, 154, 165, 
         .word    9, 9, 9, 9, 48, 60, 72, 84, 96, 108, 120, 132, 0, 1, 2, 3, 
         .word    9, 9, 9, 9, 52, 65, 78, 91, 104, 114, 130, 143, 1, 2, 3, 4, 
         .word    9, 9, 9, 9, 56, 70, 84, 98, 112, 126, 140, 154, 2, 3, 4, 5, 
         .word    9, 9, 9, 9, 60, 75, 90, 105, 120, 135, 150, 165, 3, 4, 5, 6 
window2: .word    0, 0, 0, 0, 0, 0, 0, 0, 
         .word    0, 0, 0, 0, 0, 0, 0, 0, 
         .word    0, 0, 0, 0, 0, 0, 0, 0, 
         .word    0, 0, 0, 0, 0, 0, 0, 0

# test 3 For the 16X16 frame size and a 8X4 window size
# The result should be 3, 2
asize3:  .word    16, 16, 8, 4    #i, j, k, l
frame3:  .word    7, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
         .word    7, 8, 8, 8, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 
         .word    7, 8, 8, 8, 2, 8, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 
         .word    7, 8, 8, 8, 8, 8, 18, 21, 24, 27, 30, 33, 36, 39, 42, 45, 
         .word    0, 4, 8, 8, 8, 8, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 
         .word    0, 5, 8, 8, 8, 8, 30, 35, 40, 45, 50, 55, 60, 65, 70,  75, 
         .word    0, 6, 8, 8, 8, 8, 36, 42, 48, 54, 60, 66, 72, 78, 84, 90, 
         .word    0, 4, 8, 8, 8, 8, 42, 49, 56, 63, 70, 77, 84, 91, 98, 105, 
         .word    0, 1, 8, 8, 8, 8, 48, 56, 64, 72, 80, 88, 96, 104, 112, 120, 
         .word    0, 1, 8, 8, 8, 8, 54, 63, 72, 81, 90, 99, 108, 117, 126, 135, 
         .word    0, 10, 8, 8, 8, 8, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 
         .word    0, 11, 22, 33, 44, 55, 66, 77, 88, 99, 110, 121, 132, 143, 154, 165, 
         .word    9, 9, 9, 9, 48, 60, 72, 84, 96, 108, 120, 132, 0, 1, 2, 3, 
         .word    9, 9, 9, 9, 52, 65, 78, 91, 104, 114, 130, 143, 1, 2, 3, 4, 
         .word    9, 9, 9, 9, 56, 70, 84, 98, 112, 126, 140, 154, 2, 3, 4, 5, 
         .word    9, 9, 9, 9, 60, 75, 90, 105, 120, 135, 150, 165, 3, 4, 5, 6 
window3: .word    8, 8, 8, 8, 
         .word    8, 8, 8, 8, 
         .word    8, 8, 8, 8, 
         .word    8, 8, 8, 8, 
         .word    8, 8, 8, 8, 
         .word    8, 8, 8, 8, 
         .word    8, 8, 8, 8, 
         .word    8, 8, 8, 8 

# test 4 For the 16X16 frame and a 4X4 window size
# The result should be 1, 1
asize4:  .word    16, 16, 4, 4    #i, j, k, l
frame4:  .word    9, 9, 9, 9, 0, 0, 0, 0, 0, 0, 0, 0, 6, 7, 7, 7, 
         .word    9, 7, 7, 7, 7, 5, 6, 7, 8, 9, 10, 11, 6, 7, 7, 7, 
         .word    9, 7, 7, 7, 7, 3, 12, 14, 16, 18, 20, 6, 6, 7, 7, 7, 
         .word    9, 7, 7, 7, 7, 4, 18, 21, 24, 27, 30, 33, 6, 7, 7, 7, 
         .word    0, 7, 7, 7, 7, 5, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 
         .word    0, 5, 3, 4, 5, 6, 30, 35, 40, 45, 50, 55, 60, 65, 70,  75, 
         .word    0, 6, 12, 18, 24, 30, 36, 42, 48, 54, 60, 66, 72, 78, 84, 90, 
         .word    0, 4, 14, 21, 28, 35, 42, 49, 56, 63, 70, 77, 84, 91, 98, 105, 
         .word    0, 8, 16, 24, 32, 40, 48, 56, 64, 72, 80, 88, 96, 104, 112, 120, 
         .word    0, 9, 18, 27, 36, 45, 54, 63, 72, 81, 90, 99, 108, 117, 126, 135, 
         .word    0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 
         .word    0, 11, 22, 33, 44, 55, 66, 77, 88, 99, 110, 121, 132, 143, 154, 165, 
         .word    9, 9, 9, 9, 48, 60, 72, 84, 96, 108, 120, 132, 0, 1, 2, 3, 
         .word    9, 9, 9, 9, 52, 65, 78, 91, 104, 114, 130, 143, 1, 2, 3, 4, 
         .word    9, 9, 9, 9, 56, 70, 84, 98, 112, 126, 140, 154, 2, 3, 4, 5, 
         .word    9, 9, 9, 9, 60, 75, 90, 105, 120, 135, 150, 165, 3, 4, 5, 6 
window4: .word    7, 7, 7, 7, 
         .word    7, 7, 7, 7, 
         .word    7, 7, 7, 7, 
         .word    7, 7, 7, 7 

# test 5 For the 32X32 frame and a 8X16 window size
# The result should be 16, 0
asize5:  .word    32, 32, 8, 16    #i, j, k, l
frame5:  .word    1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 
         .word    1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 
         .word    1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 
         .word    1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 
         .word    1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 
         .word    1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 
         .word    1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 
         .word    1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 
         .word    1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 
         .word    1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 
         .word    1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 
         .word    1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 
         .word    1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 
         .word    1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 
         .word    1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 
         .word    1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 
         .word    1, 1, 1, 1, 1, 10, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 
         .word    1, 1, 1, 1, 1, 10, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 
         .word    1, 1, 1, 1, 1, 10, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 
         .word    1, 1, 1, 1, 1, 10, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 
         .word    1, 1, 1, 1, 1, 10, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 
         .word    1, 1, 1, 1, 1, 10, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 
         .word    1, 1, 1, 1, 1, 10, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 
         .word    1, 1, 1, 1, 1, 10, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8
         
window5: .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
         
      


########################################################################################################################
### main
########################################################################################################################

.text

.globl main

main: 
    addi    $sp, $sp, -4    # Make space on stack
    sw      $ra, 0($sp)     # Save return address
         
    # Start test 1 
    ############################################################
    addi      $a0, $zero, 0     # 1st parameter: address of asize1[0]
    addi      $a1, $zero, 16     # 2nd parameter: address of frame1[0]
    addi      $a2, $zero, 260    # 3rd parameter: address of window1[0] 
   
    jal     vbsme           # call function
    # jal     print_result    # print results to console
    
    ############################################################
    # End of test 1   

   
    # Start test 2 
    ############################################################
    addi      $a0, $zero, 292     # 1st parameter: address of asize2[0]
    addi      $a1, $zero, 296     # 2nd parameter: address of frame2[0]
    addi      $a2, $zero, 1320    # 3rd parameter: address of window2[0] 
   
    jal     vbsme           # call function
    # jal     print_result    # print results to console
    ############################################################
    # End of test 2   
                    
               
    # Start test 3
    ############################################################
    addi      $a0, $zero, 1448     # 1st parameter: address of asize3[0]
    addi      $a1, $zero, 1452     # 2nd parameter: address of frame3[0]
    addi      $a2, $zero, 1708    # 3rd parameter: address of window3[0] 

    jal     vbsme           # call function
    # jal     print_result    # print results to console 
    ############################################################
    # End of test 3   
      
      
    # Start test 4 
    ############################################################
    addi      $a0, $zero, 1740     # 1st parameter: address of asize4[0]
    addi      $a1, $zero, 1744     # 2nd parameter: address of frame4[0]
    addi      $a2, $zero, 2000    # 3rd parameter: address of window4[0] 

    jal     vbsme           # call function
    # jal     print_result    # print results to console
    ############################################################
    # End of test 4   
   
   
    # Start test 5
    ############################################################
    addi      $a0, $zero, 2064     # 1st parameter: address of asize5[0]
    addi      $a1, $zero, 2068     # 2nd parameter: address of frame5[0]
    addi      $a2, $zero, 3092    # 3rd parameter: address of window5[0] 

    jal     vbsme           # call function
    # jal     print_result    # print results to console
    ############################################################
    # End of test 5
   
    lw      $ra, 0($sp)         # Restore return address
    addi    $sp, $sp, 4         # Restore stack pointer
    j       end_program                # Return



end_program:			#remain in the infinite loop
	j end_program                 

################### Print Result ####################################
#print_result:
    # Printing $v0
 #   add     $a0, $v0, $zero     # Load $v0 for printing
 #   li      $v0, 1              # Load the system call numbers
 #   syscall
   
    # Print newline.
 #   la      $a0, newline          # Load value for printing
 #   li      $v0, 4                # Load the system call numbers
 #   syscall
   
    # Printing $v1
 #   add     $a0, $v1, $zero      # Load $v1 for printing
 #   li      $v0, 1                # Load the system call numbers
 #   syscall

    # Print newline.
 #   la      $a0, newline          # Load value for printing
 #   li      $v0, 4                # Load the system call numbers
 #   syscall
   
    # Print newline.
 #   la      $a0, newline          # Load value for printing
 #   li      $v0, 4                # Load the system call numbers
 #   syscall
   
 #   jr      $ra                   #function return
#####################################################################
### vbsme
#####################################################################


# vbsme.s 
# motion estimation is a routine in h.264 video codec that 
# takes about 80% of the execution time of the whole code
# given a frame(2d array, x and y dimensions can be any integer 
# between 16 and 64) where "frame data" is stored under "frame"  
# and a window (2d array of size 4x4, 4x8, 8x4, 8x8, 8x16, 16x8 
# or 16x16) where "window data" is stored under "window" 
# and size of "window" and "frame" arrays are stored under 
# "asize"

# - initially current sum of difference is set to a very large value
# - move "window" over the "frame" one cell at a time starting with location (0,0)
# - moves are based on the defined search pattern 
# - for each move, function calculates  the sum of absolute difference (SAD) 
#   between the window and the overlapping block on the frame.
# - if the calculated sum of difference is LESS THAN OR EQUAL to the current sum of difference
#   then the current sum of difference is updated and the coordinate of the top left corner 
#   for that matching block in the frame is recorded. 

# for example SAD of two 4x4 arrays "window" and "block" shown below is 3  
# window         block
# -------       --------
# 1 2 2 3       1 4 2 3  
# 0 0 3 2       0 0 3 2
# 0 0 0 0       0 0 0 0 
# 1 0 0 5       1 0 0 4

# program keeps track of the window position that results 
# with the minimum sum of absolute difference. 
# after scannig the whole frame
# program returns the coordinates of the block with the minimum SAD
# in $v0 (row) and $v1 (col) 


# Sample Inputs and Output shown below:
# Frame:
#
#  0   1   2   3   0   0   0   0   0   0   0   0   0   0   0   0 
#  1   2   3   4   4   5   6   7   8   9  10  11  12  13  14  15 
#  2   3  32   1   2   3  12  14  16  18  20  22  24  26  28  30 
#  3   4   1   2   3   4  18  21  24  27  30  33  36  39  42  45 
#  0   4   2   3   4   5  24  28  32  36  40  44  48  52  56  60 
#  0   5   3   4   5   6  30  35  40  45  50  55  60  65  70  75 
#  0   6  12  18  24  30  36  42  48  54  60  66  72  78  84  90 
#  0   7  14  21  28  35  42  49  56  63  70  77  84  91  98 105 
#  0   8  16  24  32  40  48  56  64  72  80  88  96 104 112 120 
#  0   9  18  27  36  45  54  63  72  81  90  99 108 117 126 135 
#  0  10  20  30  40  50  60  70  80  90 100 110 120 130 140 150 
#  0  11  22  33  44  55  66  77  88  99 110 121 132 143 154 165 
#  0  12  24  36  48  60  72  84  96 108 120 132   0   1   2   3 
#  0  13  26  39  52  65  78  91 104 117 130 143   1   2   3   4 
#  0  14  28  42  56  70  84  98 112 126 140 154   2   3   4   5 
#  0  15  30  45  60  75  90 105 120 135 150 165   3   4   5   6 

# Window:
#  0   1   2   3 
#  1   2   3   4 
#  2   3   4   5 
#  3   4   5   6 

# cord x = 12, cord y = 12 returned in $v0 and $v1 registers

.text
.globl  vbsme

# Your program must follow the required search pattern.  

# Preconditions:
#   1st parameter (a0) address of the first element of the dimension info (address of asize[0])
#   2nd parameter (a1) address of the first element of the frame array (address of frame[0][0])
#   3rd parameter (a2) address of the first element of the window array (address of window[0][0])
# Postconditions:	
#   result (v0) x coordinate of the block in the frame with the minimum SAD
#          (v1) y coordinate of the block in the frame with the minimum SAD


# Begin subroutine
vbsme:  
    # save registers to stack.
    addi $sp, $sp, -48 # moves stack pointer down -48 to make room for 48 bytes (12 words)
    sw    $ra, 44($sp) # storing current
    sw    $s0,  0($sp)
    sw    $s1,  4($sp)
    sw    $s2,  8($sp)
    sw    $s3, 12($sp)
    sw    $s4, 16($sp)
    sw    $s5, 20($sp)
    sw    $s6, 24($sp)
    sw    $s7, 28($sp)
    sw    $a0, 32($sp)
    sw    $a1, 36($sp)
    sw    $a2, 40($sp)


    lw    $s0,  0($a0) # i, frame rows
    lw    $s1,  4($a0) # j, frame columns
    lw    $s2,  8($a0) # k, window rows
    lw    $s3, 12($a0) # l, window cols

    sub  $s4, $s0, $s2 # imax = i - k
    sub  $s5, $s1, $s3 # jmax = j - l

 
    
    addi   $t5, $zero, 0 # move  $t5, $zero  r = 0 (current row)
    addi   $t6, $zero, 0 # move  $t6, $zero  c = 0 (current col)
    addi  $t7, $zero, 0 # direction = 0 (0=right, 1=down-left, 2=up-right)
    
    addi  $s6, $zero, 0x7FFF # min_sad = max int this might cause problems
    addi  $s7, $zero, 0 # move  $s7, $zero  best_r = 0
    addi  $t8, $zero, 0 # move  $t8, $zero  best_c = 0

main_loop:

    # bgt   $t5, $s4, check_both_overflow  if r > imax, check column too
    slt     $at, $s4, $t5
    beq     $at, $zero, after_r_gt
    j    check_both_overflow

    after_r_gt:
    #bgt   $t6, $s5, col_overflow  if only c > jmax, handle separately
    slt    $at, $s5, $t6
    beq    $at, $zero, after_c_gt
    j col_overflow

    after_c_gt:
    ############## DEBUG (had issues with negatives) (solved) ###################
    # bltz  $t5, end_vbsme  if r < 0, done  
    slt  $at, $t5, $zero
    beq  $at, $zero, after_r_neg
    j    end_vbsme

    after_r_neg:
    # bltz  $t6, end_vbsme # if c < 0, done
    slt     $at, $t6, $zero
    beq     $at, $zero, after_c_neg
    j       end_vbsme 
    after_c_neg:
    ########################################################################

    j     continue_sad # position valid, do SAD

check_both_overflow:

   # bgt $t6, $s5, end_vbsme  if BOTH r>imax AND c>jmax, done
    slt  $at, $s5, $t6 
    beq  $at, $zero, no_end
    j end_vbsme

    no_end:
    add $t5, $s4, $zero  #move  $t5, $s4  clamp r to imax

    j     continue_sad

col_overflow:

    add $t6, $s5, $zero  # move  $t6, $s5  clamp c to jmax
    addi  $t5, $t5, 1 # move down one row
   # bgt   $t5, $s4, end_vbsme # if now r > imax, done
    slt $at, $s4, $t5
    beq $at, $zero, not_over
    j end_vbsme

    not_over:
    addi  $t7, $zero, 1 # set direction to down-left
    j     main_loop # recheck this new position

continue_sad:

    addi $t0, $zero, 0 # move  $t0, $zero   sad = 0
    addi $t1, $zero, 0 # move  $t1, $zero  row counter for window
    
sad_row_loop:
    # bge   $t1, $s2, sad_done  if row >= k, done
    slt $at, $t1, $s2 
    beq $at, $zero, sad_done
    addi $t2, $zero, 0   # move  $t2, $zero  col counter for window
    
sad_col_loop:
    # bge   $t2, $s3, sad_row_next  if col >= l, next row
    slt $at, $t2, $s3
    beq $at, $zero, sad_row_next
    

    add   $t3, $t5, $t1 # r + row
    mul   $t3, $t3, $s1 # (r+row) * j
    add   $t4, $t6, $t2 # c + col
    add   $t3, $t3, $t4 # (r+row)*j + (c+col)
    sll   $t3, $t3, 2 # multiply by 4 for word offset
    lw    $a1, 36($sp) # reload frame base address
    add   $t3, $a1, $t3 # frame address
    lw    $t3, 0($t3) # load frame[r+row][c+col]
    

    mul   $t4, $t1, $s3 # row * l
    add   $t4, $t4, $t2 # row*l + col
    sll   $t4, $t4, 2 # multiply by 4 for word offset
    lw    $a2, 40($sp) # reload window base address
    add   $t4, $a2, $t4 # window address
    lw    $t4, 0($t4) # load window[row][col]
    

    sub   $t3, $t3, $t4 # frame - window
    # bgez  $t3, sad_positive
    slt  $at, $t3, $zero
    beq $at, $zero, sad_positive
    sub   $t3, $zero, $t3 # make positive
sad_positive:
    add   $t0, $t0, $t3 # sad += abs(diff)
    
    addi $t2, $t2, 1 # col++
    j     sad_col_loop
    
sad_row_next:
    addi $t1, $t1, 1 # row++
    j     sad_row_loop
    
sad_done:
    # bgt   $t0, $s6, skip_update
    slt $at, $s6, $t0
    beq $at, $zero, no_skip
    j skip_update
    no_skip:
    add $s6, $t0, $zero # move  $s6, $t0  min_sad = sad
    add $s7, $t5, $zero # move  $s7, $t5  best_r = r
    add $t8, $t6, $zero # move  $t8, $t6  best_c = c
    
skip_update:
    beq   $t7, $zero, move_right
    beq   $t7, 1, move_down_left
    beq   $t7, 2, move_up_right
    j     end_vbsme

move_right:
    addi $t6, $t6, 1 # c++

    beq  $t5, $zero, switch_to_dl # if at top, go down-left
    beq   $t5, $s4, switch_to_ur # if at bottom, go up-right
    j     main_loop

switch_to_dl:
    addi  $t7, $zero, 1 # direction = down-left
    j     main_loop

switch_to_ur:
    addi    $t7, $zero, 2 # direction = up-right
    j     main_loop

move_down_left:
    addi $t5, $t5, 1 # r++
    addi $t6, $t6, -1 # c--

    # bltz  $t6, hit_left_dl  if c < 0 look down
    slt   $at, $t6, $zero
    beq   $at, $zero , continue
    j hit_left_dl
    continue:
    # bgt   $t5, $s4, hit_bottom_dl  if r > imax
    slt   $at, $s4, $t5
    beq  $at, $zero, no_branch
    j  hit_bottom_dl

hit_left_dl:
    addi $t6, $zero, 0 # move  $t6, $zero  c = 0
    addi    $t7, $zero, 2 # switch to up-right
    j     main_loop

hit_bottom_dl:
    add $t5, $s4, $zero # move  $t5, $s4 # r = imax
    addi $t6, $t6, 1 # undo c--
    addi    $t7, $zero,0 # switch to right
    j     main_loop

move_up_right:
    addi $t5, $t5, -1 # r--
    addi $t6, $t6, 1 # c++

    # bltz  $t5, hit_top_ur  if r < 0
    slt   $at,$t5, $zero
    beq   $at, $zero, no_branch
    j hit_top_ur

    #bgt   $t6, $s5, hit_right_ur  if c > jmax
    slt    $at, $s5, $t6
    beq    $at,$zero, no_branch
    j      hit_right_ur

hit_top_ur:
    addi $t5, $zero, 0  # move  $t5, $zero  r = 0
    addi    $t7,$zero, 1 # switch to down-left
    j     main_loop

hit_right_ur:
    add $t6, $s5, $zero # move  $t6, $s5 # c = jmax
    addi $t5, $t5, 1 # undo r--
    addi    $t7, $zero, 0 # switch to right
    j     main_loop
	
no_branch:
    j     main_loop

end_vbsme:

    add $v0, $s7, $zero  # move  $v0, $s7  return best_r
    add $v1, $t8, $zero  # move  $v1, $t8  return best_c
    

    lw    $ra, 44($sp)
    lw    $s0,  0($sp)
    lw    $s1,  4($sp)
    lw    $s2,  8($sp)
    lw    $s3, 12($sp)
    lw    $s4, 16($sp)
    lw    $s5, 20($sp)
    lw    $s6, 24($sp)
    lw    $s7, 28($sp)
    addi $sp, $sp, 48
    jr    $ra
    nop
# NOTE: THE DATA IS WRONG FOR THIS SET, USE LAB7_VBSME FOR THE CORRECT DATA/DATA MEMORY
