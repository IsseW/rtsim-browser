#version 420 core

#include <constants.glsl>

#define LIGHTING_TYPE LIGHTING_TYPE_REFLECTION

#define LIGHTING_REFLECTION_KIND LIGHTING_REFLECTION_KIND_GLOSSY

#if (FLUID_MODE == FLUID_MODE_LOW)
#define LIGHTING_TRANSPORT_MODE LIGHTING_TRANSPORT_MODE_IMPORTANCE
#elif (FLUID_MODE >= FLUID_MODE_MEDIUM)
#define LIGHTING_TRANSPORT_MODE LIGHTING_TRANSPORT_MODE_RADIANCE
#endif

#define LIGHTING_DISTRIBUTION_SCHEME LIGHTING_DISTRIBUTION_SCHEME_VOXEL

#define LIGHTING_DISTRIBUTION LIGHTING_DISTRIBUTION_BECKMANN

#include <globals.glsl>
#include <srgb.glsl>
#include <lod.glsl>

layout(location = 0) in vec2 v_pos;

layout(location = 0) out vec3 f_pos;
layout(location = 1) out vec3 f_norm;
layout(location = 2) out float pull_down;
// out vec2 v_pos_orig;
// out vec4 f_square;
// out vec4 f_shadow;
// out float f_light;

void main() {
    // Find distances between vertices. Pull down a tiny bit more to reduce z fighting near the ocean.
    f_pos = lod_pos(v_pos, focus_pos.xy) - vec3(0, 0, 0.1);
    #ifndef EXPERIMENTAL_BAREMINIMUM
        vec2 dims = vec2(1.0 / view_distance.y);
        vec4 f_square = focus_pos.xyxy + vec4(splay(v_pos - dims), splay(v_pos + dims));
        f_norm = lod_norm(f_pos.xy, f_square);
    #endif
    // v_pos_orig = v_pos;

    // f_pos = lod_pos(focus_pos.xy + splay(v_pos) * /*1000000.0*/(1 << 20), square);

    // f_norm = lod_norm(f_pos.xy);

    // f_shadow = textureBicubic(t_horizon, pos_to_tex(f_pos.xy));

    // TODO: disabled because it isn't designed to work with reverse depth
    //float dist = distance(focus_pos.xy, f_pos.xy);
    //pull_down = 0.2 / pow(dist / (view_distance.x * 0.9), 20.0);

    pull_down = 1.0 / pow(distance(focus_pos.xy, f_pos.xy) / (view_distance.x * 0.95), 20.0);
    f_pos.z -= pull_down;

    #ifdef EXPERIMENTAL_CURVEDWORLD
        f_pos.z -= pow(distance(f_pos.xy + focus_off.xy, focus_pos.xy + focus_off.xy) * 0.05, 2);
    #endif

    // f_pos.z -= 100.0 * pow(1.0 + 0.01 / view_distance.x, -pow(distance(focus_pos.xy, f_pos.xy), 2.0));
    // f_pos.z = mix(-f_pos.z, f_pos.z, view_distance.x <= distance(focus_pos.xy, f_pos.xy) + 32.0);

    // bool faces_fluid = false;// bool((f_pos_norm >> 28) & 0x1u);
    // // TODO: Measure real water surface altitude here.
    // float surfaceAlt = mix(view_distance.z, /*floor*/(min(f_pos.z, floor(alt_at_real(cam_pos.xy)))), medium.x);
    // // float surfaceAlt = mix(view_distance.z, floor(max(cam_pos.z, alt_at_real(cam_pos.xy))), medium.x);
    // // float surfaceAlt = min(floor(f_pos.z), floor(alt_at_real(cam_pos.xy))); // faces_fluid ? max(ceil(f_pos.z), floor(f_alt)) : floor(f_alt);

    // f_pos.z -= max(sign(view_distance.x - distance(focus_pos.xy, f_pos.xy)), 0.0) * (32.0 * view_distance.z / 255 + 32.0 * max(0.0, f_pos.z - cam_pos.z));
    // f_pos.z -= 0.1 + max(view_distance.x - distance(focus_pos.xy, f_pos.xy), 0.0) * (1.0 + max(1.0, ceil(f_pos.z - focus_pos.z)));

    // vec3 wRayinitial = f_pos; // cam_pos.z < f_pos.z ? f_pos : cam_pos.xyz;
    // vec3 wRayfinal = cam_pos.xyz; // cam_pos.z < f_pos.z ? cam_pos.xyz : f_pos;
    // wRayfinal = dot(wRayfinal - wRayinitial, focus_pos.xyz - cam_pos.xyz) < 0.0 ? wRayfinal : wRayinitial;
    // vec3 wRayNormal = /*surfaceAlt < wRayinitial.z ? vec3(0.0, 0.0, -1.0) : */vec3(0.0, 0.0, 1.0);
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

    // vec3 wRayDir3 = (dot(wRayDir, wRayNormal) < 0.0 && surfaceAlt < wRayinitial.z && wIntersectsSurface/* && medium.x == 1u*/) ? refract(wRayDir, wRayNormal, n2 / n1) : wRayDir;
    // // wPoint -= wRayDir3 * wRayLength * n2 / n1;

    // vec3 newRay = (dot(wRayDir3, focus_pos.xyz - cam_pos.xyz) < 0.0 && /*dot(wRayDir, wRayNormal) > 0.0 && *//*surfaceAlt < wRayinitial.z && */wIntersectsSurface && medium.x == 1u) ? wPoint - wRayDir3 * wRayLength * n2 / n1/*wPoint - wRayDir3 * wRayLength * n2 / n1*/ : f_pos;// - (wRayfinal - wPoint) * n2 / n1; // wPoint + n2 * (wRayfinal - wPoint) - n2 / n1 * wRayLength * wRayDir3;

    // newRay.z -= max(view_distance.x - distance(focus_pos.xy, f_pos.xy), 0.0) * (1.0 + max(0.0, f_pos.z - focus_pos.z));


    // f_light = 1.0;

    gl_Position =
        /* proj_mat *
        view_mat * */
        all_mat *
        vec4(f_pos/*newRay*/, 1);
    // Pull up the depth to avoid drawing over voxels (biased according to VD)
    // TODO: disabled because it isn't designed to work with reverse depth
    //gl_Position.z += 0.1 * clamp((view_distance.x * 1.0 - dist) * 0.01, 0, 1);

    // gl_Position.z = -gl_Position.z / gl_Position.w;
    // gl_Position.z = -gl_Position.z / gl_Position.w;
    // gl_Position.z = -gl_Position.z * gl_Position.w;
    // gl_Position.z = -gl_Position.z / 100.0;
    // gl_Position.z = -1000.0 / (gl_Position.z + 10000.0);
}
