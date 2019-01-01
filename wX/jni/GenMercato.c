
/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/


#include "GenMercato.h"

 void JNI_GenMercato (  char* iBuff, char* oBuff,
		float center_x, float center_y, float x_image_center_pixels,
		float y_image_center_pixels,  float one_degree_scale_factor, int count)
{

	double W_180_DIV_PI = 180.0 / M_PI;
	double W_PI_DIV_360 = M_PI / 360.0 ;
	double W_PI_DIV_4 = M_PI / 4.0 ;

	int i_count=0;

    float val1;
	float val2;
    float in_val1;
    float in_val2;
    
    char bytes1[4];
    char bytes2[4];

	for (i_count = 0; i_count < count; i_count = i_count + 2)
	{
        
        //let bytes1:Array<UInt8> = [backingArray[posn+3], backingArray[posn+2], backingArray[posn+1], backingArray[posn]]
        //let bytes2:Array<UInt8> = [backingArray[posn+3], backingArray[posn+2], backingArray[posn+1], backingArray[posn]]
        
        bytes1[3] = iBuff[i_count*4];
        bytes1[2] = iBuff[i_count*4+1];
        bytes1[1] = iBuff[i_count*4+2];
        bytes1[0] = iBuff[i_count*4+3];
        
        bytes2[3] = iBuff[i_count*4+4];
        bytes2[2] = iBuff[i_count*4+5];
        bytes2[1] = iBuff[i_count*4+6];
        bytes2[0] = iBuff[i_count*4+7];


        memcpy(&in_val1,bytes1,4);
        memcpy(&in_val2,bytes2,4);
        
        //memcpy(&in_val1,&iBuff[i_count*4],4 );
        //memcpy(&in_val2,&iBuff[i_count*4+4],4);

        
		val2 = -1.0f *( -(((W_180_DIV_PI * log(tan(W_PI_DIV_4+in_val1*(W_PI_DIV_360))))
									   - (W_180_DIV_PI * log(tan(W_PI_DIV_4+center_x*(W_PI_DIV_360))))) *  one_degree_scale_factor ) + y_image_center_pixels);
		val1 =  -((in_val2- center_y ) * one_degree_scale_factor ) + x_image_center_pixels;
                
        memcpy(&oBuff[i_count*4], &val1, 4);
        memcpy(&oBuff[i_count*4+4], &val2, 4);

	}
}

void JNI_GenMercatoMetal (  char* iBuff, char* oBuff,
                     float center_x, float center_y, float x_image_center_pixels,
                     float y_image_center_pixels,  float one_degree_scale_factor, int count,
                          float red, float green, float blue, float z)
{
    
    double W_180_DIV_PI = 180.0 / M_PI;
    double W_PI_DIV_360 = M_PI / 360.0 ;
    double W_PI_DIV_4 = M_PI / 4.0 ;
    
    int i_count=0;
    
    float val1;
    float val2;
    
    float val1Reversed;
    float val2Reversed;
    
    float in_val1;
    float in_val2;
    
    float one = 1.0;
    
    char bytes1[4];
    char bytes2[4];
    
    // for every two floats ( one vertex )
    // compute mercato and insert additional color, z, and alpha floats
    for (i_count = 0; i_count < count; i_count = i_count + 2)
    {
        
        //let bytes1:Array<UInt8> = [backingArray[posn+3], backingArray[posn+2], backingArray[posn+1], backingArray[posn]]
        //let bytes2:Array<UInt8> = [backingArray[posn+3], backingArray[posn+2], backingArray[posn+1], backingArray[posn]]
        
        bytes1[3] = iBuff[i_count*4];
        bytes1[2] = iBuff[i_count*4+1];
        bytes1[1] = iBuff[i_count*4+2];
        bytes1[0] = iBuff[i_count*4+3];
        
        bytes2[3] = iBuff[i_count*4+4];
        bytes2[2] = iBuff[i_count*4+5];
        bytes2[1] = iBuff[i_count*4+6];
        bytes2[0] = iBuff[i_count*4+7];
        
        
        memcpy(&in_val1,bytes1,4);
        memcpy(&in_val2,bytes2,4);
        
        //memcpy(&in_val1,&iBuff[i_count*4],4 );
        //memcpy(&in_val2,&iBuff[i_count*4+4],4);
        
        
        val2 = -1.0f *( -(((W_180_DIV_PI * log(tan(W_PI_DIV_4+in_val1*(W_PI_DIV_360))))
                           - (W_180_DIV_PI * log(tan(W_PI_DIV_4+center_x*(W_PI_DIV_360))))) *  one_degree_scale_factor ) + y_image_center_pixels);
        val1 =  -((in_val2- center_y ) * one_degree_scale_factor ) + x_image_center_pixels;
        
        //memcpy(&oBuff[i_count*4], &val1, 4);
        //memcpy(&oBuff[i_count*4+4], &val2, 4);
        
        val1Reversed = ReverseFloat(val1);
        val2Reversed = ReverseFloat(val2);
        
        // write the data out
        memcpy(&oBuff[i_count*4], &val1Reversed, 4);
        memcpy(&oBuff[i_count*4+4], &val2Reversed, 4);
        
        memcpy(&oBuff[i_count*4+4], &z, 4);
        
        memcpy(&oBuff[i_count*4], &red, 4);
        memcpy(&oBuff[i_count*4+4], &green, 4);
        memcpy(&oBuff[i_count*4+4], &blue, 4);
        memcpy(&oBuff[i_count*4+4], &one, 4);
        
    }
    
    
}

// https://stackoverflow.com/questions/2782725/converting-float-values-from-big-endian-to-little-endian
float ReverseFloat( const float inFloat )
{
    float retVal;
    char *floatToConvert = ( char* ) & inFloat;
    char *returnFloat = ( char* ) & retVal;
    
    // swap the bytes into a temporary buffer
    returnFloat[0] = floatToConvert[3];
    returnFloat[1] = floatToConvert[2];
    returnFloat[2] = floatToConvert[1];
    returnFloat[3] = floatToConvert[0];
    
    return retVal;
}


