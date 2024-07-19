#version 440 core

#include <constants.glsl>

#define LIGHTING_TYPE LIGHTING_TYPE_REFLECTION

#define LIGHTING_REFLECTION_KIND LIGHTING_REFLECTION_KIND_GLOSSY

#if (FLUID_MODE == FLUID_MODE_LOW)
#define LIGHTING_TRANSPORT_MODE LIGHTING_TRANSPORT_MODE_IMPORTANCE
#elif (FLUID_MODE >= FLUID_MODE_MEDIUM)
#define LIGHTING_TRANSPORT_MODE LIGHTING_TRANSPORT_MODE_RADIANCE
#endif

#define LIGHTING_DISTRIBUTION_SCHEME LIGHTING_DISTRIBUTION_SCHEME_MICROFACET

#define LIGHTING_DISTRIBUTION LIGHTING_DISTRIBUTION_BECKMANN

// #define HAS_SHADOW_MAPS

#include <globals.glsl>
#include <srgb.glsl>
#include <lod.glsl>
#include <shadows.glsl>


layout(location = 0) in uint v_pos_norm;
// in uint v_col_light;
layout(location = 1) in uint v_atlas_pos;

layout (std140, set = 3, binding = 0)
uniform u_locals {
    mat4 model_mat;
    // TODO: consider whether these need to be signed
    ivec4 atlas_offs;
    float load_time;
};

//struct ShadowLocals {
//    mat4 shadowMatrices;
//    mat4 texture_mat;
//};
//
//layout (std140)
//uniform u_light_shadows {
//    ShadowLocals shadowMats[/*MAX_LAYER_FACES*/192];
//};

layout(location = 0) out vec3 f_pos;
// #ifdef FLUID_MODE_SHINY
layout(location = 1) flat out uint f_pos_norm;

// #if (SHADOW_MODE == SHADOW_MODE_MAP)
// out vec4 sun_pos;
// #endif

// #endif
// out float f_alt;
// out vec4 f_shadow;
// out vec3 f_col;
// out vec3 f_chunk_pos;
// out float f_ao;
/*centroid */layout(location = 3) out vec2 f_uv_pos;
// out vec3 light_pos[2];
// out float f_light;

// uniform sampler2DRect t_col_light;

const float EXTRA_NEG_Z = 32768.0;

void main() {
    // over it (if this vertex to see if it intersects.
    // TODO: Use the following, see [https://gitlab.com/veloren/veloren/-/merge_requests/3091]
    //vec3 f_chunk_pos = vec3(ivec3((uvec3(v_pos_norm) >> uvec3(0, 6, 12)) & uvec3(0x3Fu, 0x3Fu, 0xFFFFu)) - ivec3(0, 0, EXTRA_NEG_Z));
    vec3 f_chunk_pos = vec3(v_pos_norm & 0x3Fu, (v_pos_norm >> 6) & 0x3Fu, float((v_pos_norm >> 12) & 0xFFFFu) - EXTRA_NEG_Z);

    f_pos = (model_mat * vec4(f_chunk_pos, 1.0)).xyz - focus_off.xyz;

    vec3 v_pos = f_pos;

    // Terrain 'pop-in' effect
    #ifndef EXPERIMENTAL_BAREMINIMUM
        #ifdef EXPERIMENTAL_TERRAINPOP
            v_pos.z -= 250.0 * (1.0 - min(1.0001 - 0.02 / pow(time_since(load_time), 10.0), 1.0));
            // f_pos.z -= min(32.0, 25.0 * pow(distance(focus_pos.xy, f_pos.xy) / view_distance.x, 20.0));
        #endif
    #endif

    #ifdef EXPERIMENTAL_CURVEDWORLD
        v_pos.z -= pow(distance(v_pos.xy + focus_off.xy, focus_pos.xy + focus_off.xy) * 0.05, 2);
    #endif

    // vec3 light_col = vec3(
    //          hash(floor(vec4(f_chunk_pos.x, 0, 0, 0))),
    //          hash(floor(vec4(0, f_chunk_pos.y, 0, 1))),
    //          hash(floor(vec4(0, 0, f_chunk_pos.z, 2)))
    //     );

    // f_col = light_col;// f_col = vec3((uvec3(v_col_light) >> uvec3(8, 16, 24)) & uvec3(0xFFu)) / 255.0;
    // f_light = 1.0;//float(v_col_light & 0x3Fu) / 64.0;
    // f_ao = 1.0;//float((v_col_light >> 6u) & 3u) / 4.0;
    // f_col = f_col = vec3((uvec3(v_col_light) >> uvec3(8, 16, 24)) & uvec3(0xFFu)) / 255.0;
    // f_light = float(v_col_light & 0x3Fu) / 64.0;
    // f_ao = float((v_col_light >> 6u) & 3u) / 4.0;

    // for (uint i = 0u; i < 1u/*light_shadow_count.z*/; ++i) {
    //     light_pos[i] = vec3(shadowMats[i].texture_mat * vec4(f_pos, 1.0));
    // }
    // vec2 texSize = textureSize(t_col_light, 0);
    f_uv_pos = vec2((uvec2(v_atlas_pos) >> uvec2(0, 16)) & uvec2(0xFFFFu, 0xFFFFu));

// #if (SHADOW_MODE == SHADOW_MODE_MAP)
//     // for (uint i = 0u; i < light_shadow_count.z; ++i) {
//     //     light_pos[i] = /*vec3(*/shadowMats[i].texture_mat * vec4(f_pos, 1.0)/*)*/;
//     // }
//     sun_pos = /*vec3(*/shadowMats[0].texture_mat * vec4(f_pos, 1.0)/*)*/;
// // #elif (SHADOW_MODE == SHADOW_MODE_CHEAP || SHADOW_MODE == SHADOW_MODE_NONE)
// //    vec4 sun_pos = vec4(0.0);
// #endif

// #ifdef FLUID_MODE_SHINY
    f_pos_norm = v_pos_norm;
// #endif

    // Also precalculate shadow texture and estimated terrain altitude.
    // f_alt = alt_at(f_pos.xy);
    // f_shadow = textureMaybeBicubic(t_horizon, pos_to_tex(f_pos.xy));

    // IDEA: Cast a ray from the vertex to the camera (if this vertex is above the camera) or from the camera to the vertex (if this
    // vertex is below the camera) to see where it intersects the plane of water.  All of this only applies if either the terrain
    // vertex is in water, or the camera is in water.
    //
    // If an intersection is found, refract the ray across the barrier using the correct ratio of indices of refraction (1 / N_WATER
    // if the vertex is above the camera [ray is going from air to water], N_WATER if the camera is above the vertex
    // [ray is going from water to air]).
    //
    // In order to make sure that terrain and other objects below such an interface are properly renered, we then "un-refract" by
    // reversing the refracted vector, and multiplying that by the distance from the object from which we cast the ray to the
    // intersectng point, in order to make the object appear to the viewer where it should after refraction.
    // bool faces_fluid = bool((f_pos_norm >> 28) & 0x1u);
    // // TODO: Measure real water surface altitude here.
    // float surfaceAlt = faces_fluid ? max(ceil(f_pos.z), floor(f_alt)) : /*floor(f_alt);*/mix(view_distance.z, min(f_alt, floor(alt_at_real(cam_pos.xy))), medium.x);

    // vec3 wRayinitial = f_pos; // cam_pos.z < f_pos.z ? f_pos : cam_pos.xyz;
    // vec3 wRayfinal = cam_pos.xyz; // cam_pos.z < f_pos.z ? cam_pos.xyz : f_pos;
    // vec3 wRayNormal = surfaceAlt < wRayinitial.z ? vec3(0.0, 0.0, 1.0) : vec3(0.0, 0.0, -1.0);
    // float n_camera = mix(1.0, 1.3325, medium.x);
    // float n_vertex = faces_fluid ? 1.3325 : 1.0;
    // float n1 = n_vertex; // cam_pos.z < f_pos.z ? n_vertex : n_camera;
    // float n2 = n_camera; // cam_pos.z < f_pos.z ? n_camera : n_vertex;

    // float wRayLength0 = length(wRayfinal - wRayinitial);
    // vec3 wRayDir = (wRayfinal - wRayinitial) / wRayLength0;
    // vec3 wPoint = wRayfinal;
    // bool wIntersectsSurface = IntersectRayPlane(wRayinitial, wRayDir, vec3(0.0, 0.0, surfaceAlt), -wRayNormal, wPoint);
    // float wRayLength = length(wPoint - wRayinitial);
    // wPoint = wRayLength < wRayLength0 ? wPoint : wRayfinal;
    // wRayLength = min(wRayLength, wRayLength0); // min(max_length, dot(wRayfinal - wpos, defaultpos - wpos));

    // // vec3 wRayDir2 = (wRayfinal - wRayinitial) / wRayLength;

    // vec3 wRayDir3 = (dot(wRayDir, wRayNormal) < 0.0 && wIntersectsSurface) ? refract(wRayDir, wRayNormal, n2 / n1) : wRayDir;
    // // wPoint -= wRayDir3 * wRayLength * n2 / n1;
    // vec3 newRay = dot(wRayDir, wRayNormal) < 0.0 && wIntersectsSurface ? wPoint - wRayDir3 * wRayLength * n2 / n1 : f_pos;// - (wRayfinal - wPoint) * n2 / n1; // wPoint + n2 * (wRayfinal - wPoint) - n2 / n1 * wRayLength * wRayDir3;

#ifdef HAS_SHADOW_MAPS
    gl_Position =
        /*all_mat*/shadowMatrices/*texture_mat*/ *
        vec4(v_pos/*newRay*/, 1);
    gl_Position.z = clamp(gl_Position.z, -abs(gl_Position.w), abs(gl_Position.w));
#else
    gl_Position = all_mat * vec4(v_pos/*newRay*/, 1);
#endif
    // gl_Position.y /= gl_Position.w;
    // gl_Position.w = 1.0;
    // gl_Position.z = -gl_Position.z;
    // gl_Position.z = -gl_Position.z / gl_Position.w;
    // gl_Position.z = -gl_Position.z / gl_Position.w;
    // gl_Position.z = -gl_Position.z *gl_Position.w;
    // gl_Position.z = gl_Position.z / 100.0;
    // gl_Position.z = gl_Position.z / 10000.0;
    // gl_Position.z = -gl_Position.z / 100.0;
    // gl_Position.z = -1000.0 / (gl_Position.z + 10000.0);
    // gl_Position.z = -1000.0 / (gl_Position.z + 10000.0);
}
