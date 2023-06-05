#ifndef LOD_GLSL
#define LOD_GLSL

#include <random.glsl>
#include <sky.glsl>
#include <srgb.glsl>

layout(set = 0, binding = 7) uniform texture2D t_horizon;
layout(set = 0, binding = 8) uniform sampler s_horizon;


const float MIN_SHADOW = 0.33;

vec2 pos_to_tex(vec2 pos) {
    // Want: (pixel + 0.5)
    vec2 uv_pos = (focus_off.xy + pos + 16) / 32.0;
    return vec2(uv_pos.x, uv_pos.y);
}

// textureBicubic from https://stackoverflow.com/a/42179924
vec4 cubic(float v) {
    vec4 n = vec4(1.0, 2.0, 3.0, 4.0) - v;
    vec4 s = n * n * n;
    float x = s.x;
    float y = s.y - 4.0 * s.x;
    float z = s.z - 4.0 * s.y + 6.0 * s.x;
    float w = 6.0 - x - y - z;
    return vec4(x, y, z, w) * (1.0/6.0);
}

// Computes atan(y, x), except with more stability when x is near 0.
float atan2(in float y, in float x) {
    bool s = (abs(x) > abs(y));
    return mix(PI/2.0 - atan(x,y), atan(y,x), s);
}

// NOTE: We assume the sampled coordinates are already in "texture pixels".
vec4 textureBicubic(texture2D tex, sampler sampl, vec2 texCoords) {
    // TODO: remove all textureSize calls and replace with constants
   vec2 texSize = textureSize(sampler2D(tex, sampl), 0);
   vec2 invTexSize = 1.0 / texSize;
   /* texCoords.y = texSize.y - texCoords.y; */

   texCoords = texCoords/* * texSize */ - 0.5;


    vec2 fxy = fract(texCoords);
    texCoords -= fxy;

    vec4 xcubic = cubic(fxy.x);
    vec4 ycubic = cubic(fxy.y);

    vec4 c = texCoords.xxyy + vec2 (-0.5, +1.5).xyxy;
    // vec4 c = texCoords.xxyy + vec2 (-1, +1).xyxy;

    vec4 s = vec4(xcubic.xz + xcubic.yw, ycubic.xz + ycubic.yw);
    vec4 offset = c + vec4 (xcubic.yw, ycubic.yw) / s;

    offset *= invTexSize.xxyy;
    /* // Correct for map rotaton.
    offset.zw  = 1.0 - offset.zw; */

    vec4 sample0 = texture(sampler2D(tex, sampl), offset.xz);
    vec4 sample1 = texture(sampler2D(tex, sampl), offset.yz);
    vec4 sample2 = texture(sampler2D(tex, sampl), offset.xw);
    vec4 sample3 = texture(sampler2D(tex, sampl), offset.yw);
    // vec4 sample0 = texelFetch(sampler, offset.xz, 0);
    // vec4 sample1 = texelFetch(sampler, offset.yz, 0);
    // vec4 sample2 = texelFetch(sampler, offset.xw, 0);
    // vec4 sample3 = texelFetch(sampler, offset.yw, 0);

    float sx = s.x / (s.x + s.y);
    float sy = s.z / (s.z + s.w);

    return mix(
       mix(sample3, sample2, sx), mix(sample1, sample0, sx)
    , sy);
}

// 16 bit version (each of the 2 8-bit components are combined after bilinear sampling)
// NOTE: We assume the sampled coordinates are already in "texture pixels".
vec2 textureBicubic16(texture2D tex, sampler sampl, vec2 texCoords) {
   vec2 texSize = textureSize(sampler2D(tex, sampl), 0);
   vec2 invTexSize = 1.0 / texSize;
   /* texCoords.y = texSize.y - texCoords.y; */

   texCoords = texCoords/* * texSize */ - 0.5;


    vec2 fxy = fract(texCoords);
    texCoords -= fxy;

    vec4 xcubic = cubic(fxy.x);
    vec4 ycubic = cubic(fxy.y);

    vec4 c = texCoords.xxyy + vec2 (-0.5, +1.5).xyxy;
    // vec4 c = texCoords.xxyy + vec2 (-1, +1).xyxy;

    vec4 s = vec4(xcubic.xz + xcubic.yw, ycubic.xz + ycubic.yw);
    vec4 offset = c + vec4 (xcubic.yw, ycubic.yw) / s;

    offset *= invTexSize.xxyy;
    /* // Correct for map rotaton.
    offset.zw  = 1.0 - offset.zw; */

    vec4 sample0_v4 = textureLod(sampler2D(tex, sampl), offset.xz, 0);
    vec4 sample1_v4 = textureLod(sampler2D(tex, sampl), offset.yz, 0);
    vec4 sample2_v4 = textureLod(sampler2D(tex, sampl), offset.xw, 0);
    vec4 sample3_v4 = textureLod(sampler2D(tex, sampl), offset.yw, 0);
    vec2 sample0 = sample0_v4.rb / 256.0 + sample0_v4.ga;
    vec2 sample1 = sample1_v4.rb / 256.0 + sample1_v4.ga;
    vec2 sample2 = sample2_v4.rb / 256.0 + sample2_v4.ga;
    vec2 sample3 = sample3_v4.rb / 256.0 + sample3_v4.ga;
    // vec4 sample0 = texelFetch(sampler, offset.xz, 0);
    // vec4 sample1 = texelFetch(sampler, offset.yz, 0);
    // vec4 sample2 = texelFetch(sampler, offset.xw, 0);
    // vec4 sample3 = texelFetch(sampler, offset.yw, 0);

    float sx = s.x / (s.x + s.y);
    float sy = s.z / (s.z + s.w);

    return mix(
       mix(sample3, sample2, sx), mix(sample1, sample0, sx)
    , sy);
}

// Gets the altitude at a position relative to focus_off.
float alt_at(vec2 pos) {
    vec4 alt_sample = textureLod/*textureBicubic16*/(sampler2D(t_alt, s_alt), wpos_to_uv(focus_off.xy + pos), 0);
    return (/*round*/((alt_sample.r / 256.0 + alt_sample.g) * (/*1300.0*//*1278.7266845703125*/view_distance.w)) + /*140.0*/view_distance.z - focus_off.z);
    //+ (texture(t_noise, pos * 0.002).x - 0.5) * 64.0;

    // return 0.0
    //     + pow(texture(t_noise, pos * 0.00005).x * 1.4, 3.0) * 1000.0
    //     + texture(t_noise, pos * 0.001).x * 100.0
    //     + texture(t_noise, pos * 0.003).x * 30.0;
}

float alt_at_real(vec2 pos) {
    // Basic idea: only really need the real altitude for an accurate water height estimation, so if we are in the cheap shader take a shortcut.
// #if (FLUID_MODE == FLUID_MODE_LOW)
//  return alt_at(pos);
// #elif (FLUID_MODE == FLUID_MODE_SHINY)
    return (/*round*/(textureBicubic16(t_alt, s_alt, pos_to_tex(pos)).r * (/*1300.0*//*1278.7266845703125*/view_distance.w)) + /*140.0*/view_distance.z - focus_off.z);
// #endif
        //+ (texture(t_noise, pos * 0.002).x - 0.5) * 64.0;

    // return 0.0
    //     + pow(texture(t_noise, pos * 0.00005).x * 1.4, 3.0) * 1000.0
    //     + texture(t_noise, pos * 0.001).x * 100.0
    //     + texture(t_noise, pos * 0.003).x * 30.0;
}


float horizon_at2(vec4 f_horizons, float alt, vec3 pos, /*float time_of_day*/vec4 light_dir) {
    // vec3 sun_dir = get_sun_dir(time_of_day);
    const float PI_2 = 3.1415926535897932384626433832795 / 2.0;
    const float MIN_LIGHT = 0.0;//0.115/*0.0*/;

    // return 1.0;
/*

                let shade_frac = horizon_map
                    .and_then(|(angles, heights)| {
                        chunk_idx
                            .and_then(|chunk_idx| angles.get(chunk_idx))
                            .map(|&e| (e as f64, heights))
                    })
                    .and_then(|(e, heights)| {
                        chunk_idx
                            .and_then(|chunk_idx| heights.get(chunk_idx))
                            .map(|&f| (e, f as f64))
                    })
                    .map(|(angle, height)| {
                        let w = 0.1;
                        if angle != 0.0 && light_direction.x != 0.0 {
                            let deltax = height / angle;
                            let lighty = (light_direction.y / light_direction.x * deltax).abs();
                            let deltay = lighty - height;
                            let s = (deltay / deltax / w).min(1.0).max(0.0);
                            // Smoothstep
                            s * s * (3.0 - 2.0 * s)
                        } else {
                            1.0
                        }
                    })
                    .unwrap_or(1.0);
*/
    // vec2 f_horizon;
    /* if (light_dir.z >= 0) {
        return 0.0;
    } */
    /* if (light_dir.x >= 0) {
        f_horizon = f_horizons.rg;
        // f_horizon = f_horizons.ba;
    } else {
        f_horizon = f_horizons.ba;
        // f_horizon = f_horizons.rg;
    }
    return 1.0; */
    /* bvec2 f_mode = lessThan(vec2(light_dir.x), vec2(1.0));
    f_horizon = mix(f_horizons.ba, f_horizons.rg, f_mode); */
    // f_horizon = mix(f_horizons.rg, f_horizons.ba, clamp(light_dir.x * 10000.0, 0.0, 1.0));
    vec2 f_horizon = mix(f_horizons.rg, f_horizons.ba, bvec2(light_dir.x < 0.0));
    // vec2 f_horizon = mix(f_horizons.ba, f_horizons.rg, clamp(light_dir.x * 10000.0, 0.0, 1.0));
    // f_horizon = mix(f_horizons.ba, f_horizons.rg, bvec2(lessThan(light_dir.xx, vec2(0.0))));
    /* if (f_horizon.x <= 0) {
        return 1.0;
    } */
    float angle = tan(f_horizon.x * PI_2);
    /* if (angle <= 0.0001) {
        return 1.0;
    } */
    float height = f_horizon.y * /*1300.0*//*1278.7266845703125*/view_distance.w + view_distance.z;
    const float w = 0.1;
    float deltah = height - alt - focus_off.z;
    //if (deltah < 0.0001/* || angle < 0.0001 || abs(light_dir.x) < 0.0001*/) {
    //    return 1.0;
    /*} else */{
        float lighta = /*max*/(-light_dir.z/*, 0.0*/) / max(abs(light_dir.x), 0.0001);
        // NOTE: Ideally, deltah <= 0.0 is a sign we have an oblique horizon angle.
        float deltax = deltah / max(angle, 0.0001)/*angle*/;
        float lighty = lighta * deltax;
        float deltay = lighty - deltah + max(pos.z - alt, 0.0);
        // NOTE: the "real" deltah should always be >= 0, so we know we're only handling the 0 case with max.
        float s = mix(max(min(max(deltay, 0.0) / max(deltax, 0.0001) / w, 1.0), 0.0), 1.0, deltah <= 0);
        return max(/*0.2 + 0.8 * */(s * s * (3.0 - 2.0 * s)), MIN_LIGHT);
        /* if (lighta >= angle) {
            return 1.0;
        } else {
            return MIN_LIGHT;
        } */
        // float deltah = height - alt;
        // float deltah = max(height - alt, 0.0);
        // float lighty = abs(sun_dir.z / sun_dir.x * deltax);
        // float lighty = abs(sun_dir.z / sun_dir.x * deltax);
        // float deltay = lighty - /*pos.z*//*deltah*/(deltah + max(pos.z - alt, 0.0))/*deltah*/;
        // float s = max(min(max(deltay, 0.0) / deltax / w, 1.0), 0.0);
        // Smoothstep
        // return max(/*0.2 + 0.8 * */(s * s * (3.0 - 2.0 * s)), MIN_LIGHT);
    }
}

// float horizon_at(vec3 pos, /*float time_of_day*/vec3 light_dir) {
//     vec4 f_horizons = textureBicubic(t_horizon, pos_to_tex(pos.xy));
//     // f_horizons.xyz = /*linear_to_srgb*/(f_horizons.xyz);
//     float alt = alt_at_real(pos.xy);
//     return horizon_at2(f_horizons, alt, pos, light_dir);
// }

vec2 splay(vec2 pos) {
    // const float SPLAY_MULT = 1048576.0;
    float len_2 = dot(pos, pos);
    float len_pow = len_2 * sqrt(len_2);
    // float len_pow = pow(len/* * SQRT_2*//* * 0.5*/, 3.0);
    // vec2 splayed = pos * pow(len * 0.5, 3.0) * SPLAY_MULT;
    const float SQRT_2 = sqrt(2.0) / 2.0;
    // /const float CBRT_2 = cbrt(2.0) / 2.0;
    // vec2 splayed = pos * (view_distance.x * SQRT_2 + pow(len * 0.5, 3.0) * (SPLAY_MULT - view_distance.x));
    vec2 splayed = pos * (view_distance.x * SQRT_2 + len_pow * (textureSize(sampler2D(t_alt, s_alt), 0) * 32.0/* - view_distance.x*/));
    if (abs(pos.x) > 0.99 || abs(pos.y) > 0.99) {
        splayed *= 10.0;
    }
    return splayed;

    // Radial: pos.x = r - view_distance.x from focus_pos, pos.y = θ from cam_pos to focus_pos on xy plane.
    // const float PI_2 = 3.1415926535897932384626433832795;
    // float squared = pos.x * pos.x;
    // // // vec2 splayed2 = pos * vec2(squared * (SPLAY_MULT - view_distance.x), PI);
    // vec2 splayed2 = pos * vec2(squared * (textureSize(t_alt, 0).x * 32.0 - view_distance.x), PI);
    // float r = splayed2.x + view_distance.x;
    // vec2 theta = vec2(cos(splayed2.y), sin(splayed2.y));
    // return r * theta;
    // // mat2 rot_mat = mat2(vec2(theta.x, -theta.y), theta.yx);
    // // return r * /*normalize(normalize(focus_pos.xy - cam_pos.xy) + theta);*/rot_mat * normalize(focus_pos.xy - cam_pos.xy);
    // return splayed;
}

vec3 lod_norm(vec2 f_pos/*vec3 pos*/, vec4 square) {
    // const float SAMPLE_W = 32;

    // vec2 f_pos = pos.xy;
    // float altx0 = alt_at_real(f_pos + vec2(-1.0, 0) * SAMPLE_W);
    // float altx1 = alt_at_real(f_pos + vec2(1.0, 0) * SAMPLE_W);
    // float alty0 = alt_at_real(f_pos + vec2(0, -1.0) * SAMPLE_W);
    // float alty1 = alt_at_real(f_pos + vec2(0, 1.0) * SAMPLE_W);
    float altx0 = alt_at(vec2(square.x, f_pos.y));
    float altx1 = alt_at(vec2(square.z, f_pos.y));
    float alty0 = alt_at(vec2(f_pos.x, square.y));
    float alty1 = alt_at(vec2(f_pos.x, square.w));
    float slope = abs(altx1 - altx0) + abs(alty0 - alty1);

    // vec3 norm = normalize(cross(
    //     vec3(/*2.0 * SAMPLE_W*/square.z - square.x, 0.0, altx1 - altx0),
    //     vec3(0.0, /*2.0 * SAMPLE_W*/square.w - square.y, alty1 - alty0)
    // ));
    vec3 norm = normalize(vec3(
        (altx0 - altx1) / (square.z - square.x),
        (alty0 - alty1) / (square.w - square.y),
        1.0
        //(abs(square.w - square.y) + abs(square.z - square.x)) / (slope + 0.00001) // Avoid NaN
    ));
    /* vec3 norm = normalize(vec3(
        (altx0 - altx1) / (2.0 * SAMPLE_W),
        (alty0 - alty1) / (2.0 * SAMPLE_W),
        (2.0 * SAMPLE_W) / (slope + 0.00001) // Avoid NaN
    )); */

    return faceforward(norm, vec3(0.0, 0.0, -1.0)/*pos - cam_pos.xyz*/, norm);
}

vec3 lod_norm(vec2 f_pos/*vec3 pos*/) {
    const float SAMPLE_W = 32;

    vec3 norm = lod_norm(f_pos, vec4(f_pos - vec2(SAMPLE_W), f_pos + vec2(SAMPLE_W)));

    #ifdef EXPERIMENTAL_PROCEDURALLODDETAIL
        vec2 wpos = f_pos + focus_off.xy;
        norm.xy += vec2(
            textureLod(sampler2D(t_noise, s_noise), wpos / 250, 0).x - 0.5,
            textureLod(sampler2D(t_noise, s_noise), wpos / 250 + 0.5, 0).x - 0.5
        ) * 0.25 / pow(norm.z + 0.1, 3);
        norm.xy += vec2(
            textureLod(sampler2D(t_noise, s_noise), wpos / 100, 0).x - 0.5,
            textureLod(sampler2D(t_noise, s_noise), wpos / 100 + 0.5, 0).x - 0.5
        ) * 0.25 / pow(norm.z + 0.1, 3);
        norm = normalize(norm);
    #endif

    return norm;
}


vec3 lod_pos(vec2 pos, vec2 focus_pos) {
    // Remove spiking by "pushing" vertices towards local optima
    vec2 delta = splay(pos);
    vec2 hpos = focus_pos + delta;

    #ifndef EXPERIMENTAL_BAREMINIMUM
        vec2 nhpos = hpos;
        // vec2 lod_shift = splay(abs(pos) - 1.0 / view_distance.y);
        float shift = 15.0;// min(lod_shift.x, lod_shift.y) * 0.5;
        for (int i = 0; i < 3; i ++) {
            // vec4 square = focus_pos.xy + vec4(splay(pos - vec2(1.0, 1.0), splay(pos + vec2(1.0, 1.0))));
            nhpos -= lod_norm(hpos).xy * shift;
        }
        hpos = hpos + normalize(nhpos - hpos + 0.001) * min(length(nhpos - hpos), 32);
    #endif

    return vec3(hpos, alt_at_real(hpos));
}

#ifdef HAS_LOD_FULL_INFO
layout(set = 0, binding = 10)
uniform texture2D t_map;
layout(set = 0, binding = 11)
uniform sampler s_map;

vec3 lod_col(vec2 pos) {
    #ifdef EXPERIMENTAL_PROCEDURALLODDETAIL
        vec2 wpos = pos + focus_off.xy;
        vec2 shift = vec2(
            textureLod(sampler2D(t_noise, s_noise), wpos / 200, 0).x - 0.5,
            textureLod(sampler2D(t_noise, s_noise), wpos / 200 + 0.5, 0).x - 0.5
        ) * 64 + vec2(
            textureLod(sampler2D(t_noise, s_noise), wpos / 50, 0).x - 0.5,
            textureLod(sampler2D(t_noise, s_noise), wpos / 50 + 0.5, 0).x - 0.5
        ) * 48;
        pos += shift;
        wpos += shift;
    #endif

    vec3 col = textureBicubic(t_map, s_map, pos_to_tex(pos)).rgb;

    /*
    #ifdef EXPERIMENTAL_PROCEDURALLODDETAIL
        col *= pow(vec3(
            textureLod(sampler2D(t_noise, s_noise), wpos / 40, 0).x - 0.5,
            textureLod(sampler2D(t_noise, s_noise), wpos / 50 + 0.5, 0).x - 0.5,
            textureLod(sampler2D(t_noise, s_noise), wpos / 45 + 0.75, 0).x - 0.5
        ) + 1.0, vec3(0.5));
    #endif
    */

    return col;
}
#endif

vec3 water_diffuse(vec3 color, vec3 dir, float max_dist) {
    if (medium.x == 1) {
        float f_alt = alt_at(cam_pos.xy);
        float fluid_alt = max(cam_pos.z + 1, floor(f_alt + 1));

        float water_dist = clamp((fluid_alt - cam_pos.z) / pow(max(dir.z, 0), 2), 0, max_dist);

        float fade = pow(0.95, water_dist);

        return mix(vec3(0.0, 0.2, 0.5)
            * (get_sun_brightness() * get_sun_color() + get_moon_brightness() * get_moon_color())
            * pow(0.99, max((fluid_alt - cam_pos.z) * 12.0 - dir.z * 200, 0)), color.rgb * exp(-MU_WATER * water_dist * 0.1), fade);
    } else {
        return color;
    }
}

#endif
