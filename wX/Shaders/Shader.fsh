/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

varying lowp vec3 v_Color;

void main()
{
    gl_FragColor = vec4(v_Color,1.0);
}





