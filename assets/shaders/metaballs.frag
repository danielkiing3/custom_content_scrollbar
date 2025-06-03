#version 300 es

precision mediump float;

#include <flutter/runtime_effect.glsl>

// Canvas size
uniform vec2 uSize;

// Fixed metabll that below the stadium
uniform vec2 uBlobCenter2;  

// Blob radius
uniform vec2 uBlobRadius;

// Background color for the shader output
uniform vec4 uBackgroundColor;

// Color the blob
uniform vec4 uBlobColor;

// Thresold value
uniform float thresoldValue;

// Animated metaball for progress indicator
uniform vec2 uBlobCenter1; 

// Color send back to flutter use cases
out vec4 fragColor;


/// This function return the influence of the metabll on the current [st] coord
/// Return a float representing the influence 
///
/// Formula for influence: (r * r) / (pow((st.x - center.x), 2.0) + pow((st.y - center.y), 2.0));
///
/// [st] - So this is the value of the current screen coordinate
/// [center] - The offset value of the metaball we are working with it
/// [r] - Radius of the metabll 
float metaballInfluence(vec2 st, vec2 center, vec2 radius) {
    vec2 scaled = (st - center) / radius;
    float dist2 = dot(scaled, scaled); 
    return 1.0 / (dist2 + 1e-4); 
}


void main(){
    // Normalize screen coordinate
    // It makes things easier to reason with [0.0 to 1.0]
    vec2 st = (FlutterFragCoord().xy / uSize);

    float threshold = thresoldValue;
    float blendValue = 0.1;
    float alphaChannel = 1.0;

    // Animating metaball
    vec2 center1 = uBlobCenter1;
    vec2 center2 = uBlobCenter2 ;

    // Field value from influence of center1 and center2
    float fieldValue = metaballInfluence(st, center1, uBlobRadius) + metaballInfluence(st, center2, uBlobRadius);

    // Setting the color output
    float colorMask = smoothstep(threshold - blendValue, threshold, fieldValue);
    vec3 color = mix(uBackgroundColor.rgb, uBlobColor.rgb, colorMask);


    // Outputing color back to flutter side
    fragColor = vec4(color, alphaChannel);
}
