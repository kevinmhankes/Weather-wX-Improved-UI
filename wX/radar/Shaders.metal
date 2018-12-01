//
//  Shaders.metal
//  HelloMetal
//
//  Created by Andriy K. on 11/12/16.
//  Copyright © 2016 razeware. All rights reserved.
//

// Nov 2018 , remove the need for z, alpha value which should always be 0 and 1 respectively

#include <metal_stdlib>
using namespace metal;

struct VertexIn{
    packed_float2 position;
    packed_float3 color;
    //packed_uchar3 color;
};

struct VertexOut{
    float4 position [[position]];  //1
    float4 color;
    //uchar4 color;
};

struct Uniforms{
    float4x4 modelMatrix;
    float4x4 projectionMatrix;
};

vertex VertexOut basic_vertex(
                              const device VertexIn* vertex_array [[ buffer(0) ]],
                              const device Uniforms&  uniforms    [[ buffer(1) ]],           //1
                              unsigned int vid [[ vertex_id ]]) {
    
    float4x4 mv_Matrix = uniforms.modelMatrix;                     //2
    float4x4 proj_Matrix = uniforms.projectionMatrix;
    
    VertexIn VertexIn = vertex_array[vid];
    
    VertexOut VertexOut;
    VertexOut.position = proj_Matrix * mv_Matrix * float4(VertexIn.position,0,1);
    VertexOut.color = float4(VertexIn.color,1);
    //VertexOut.color = uchar4(VertexIn.color,1);
    return VertexOut;
}

fragment half4 basic_fragment(VertexOut interpolated [[stage_in]]) {  //1
    return half4(interpolated.color[0], interpolated.color[1], interpolated.color[2], interpolated.color[3]); //2
}
