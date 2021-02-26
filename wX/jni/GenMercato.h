/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

#include <string.h>
#include <math.h>
#include <stdlib.h>

void JNI_GenMercato(
    char * iBuff,
    char * oBuff,
    float center_x, 
    float center_y, 
    float x_image_center_pixels,
    float y_image_center_pixels,  
    float one_degree_scale_factor, 
    int count
);

void JNI_GenMercatoMetal(
    char * iBuff,
    char * oBuff,
    float center_x,
    float center_y,
    float x_image_center_pixels,
    float y_image_center_pixels,
    float one_degree_scale_factor,
    int count,
    float red,
    float green,
    float blue,
    float z
);

float ReverseFloat(const float inFloat);
