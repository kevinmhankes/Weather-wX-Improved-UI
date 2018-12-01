/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

uniform mat4 mtrxProjectionAndView;
attribute vec4 position;
varying lowp vec4 colorVarying;
attribute lowp vec3 a_Color;
varying lowp vec3 v_Color;

void main()
{
    v_Color = a_Color;
    gl_Position = mtrxProjectionAndView * position;
}






