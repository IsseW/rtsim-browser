#ifndef SHADOWS_GLSL
#define SHADOWS_GLSL

#ifdef HAS_SHADOW_MAPS

#if (SHADOW_MODE == SHADOW_MODE_MAP)
layout (std140, set = 0, binding = 9)
uniform u_light_shadows {
    mat4 shadowMatrices;
    mat4 texture_mat;
};

// Use with sampler2DShadow
layout(set = 1, binding = 2)
uniform texture2D t_directed_shadow_maps;
layout(set = 1, binding = 3)
uniform samplerShadow s_directed_shadow_maps;
// uniform sampler2DArrayShadow t_directed_shadow_maps;

// uniform samplerCubeArrayShadow t_shadow_maps;
// uniform samplerCubeArray t_shadow_maps;
// Use with samplerCubeShadow
layout(set = 1, binding = 0)
uniform textureCube t_point_shadow_maps;
layout(set = 1, binding = 1)
uniform samplerShadow s_point_shadow_maps;
// uniform samplerCube t_shadow_maps;

// uniform sampler2DArray t_directed_shadow_maps;

float VectorToDepth (vec3 Vec)
{
    // return length(Vec) / screen_res.w;
    vec3 AbsVec = abs(Vec);
    float LocalZcomp = max(AbsVec.x, max(AbsVec.y, AbsVec.z));
    // float LocalZcomp = length(Vec);

    // Replace f and n with the far and near plane values you used when
    //   you drew your cube map.
    // const float f = 2048.0;
    // const float n = 1.0;

    // float NormZComp = (screen_res.w+screen_res.z) / (screen_res.w-screen_res.z) - (2*screen_res.w*screen_res.z)/(screen_res.w-screen_res.z)/LocalZcomp;
    // float NormZComp = 1.0 - shadow_proj_factors.y / shadow_proj_factors.x / LocalZcomp;
    // -(1 + 2n/(f-n)) - 2(1 + n/(f-n)) * n/z
    // -(1 + n/(f-n)) - (1 + n/(f-n)) * n/z
    // f/(f-n) - fn/(f-n)/z
    float NormZComp = shadow_proj_factors.x - shadow_proj_factors.y / LocalZcomp;
    // NormZComp = -1000.0 / (NormZComp + 10000.0);
    // return (NormZComp + 1.0) * 0.5;
    return NormZComp;

    // float NormZComp = length(LocalZcomp);
    // NormZComp = -NormZComp / screen_res.w;
    // // return (NormZComp + 1.0) * 0.5;
    // return NormZComp;
}

const vec3 sampleOffsetDirections[20] = vec3[]
(
   vec3( 1,  1,  1), vec3( 1, -1,  1), vec3(-1, -1,  1), vec3(-1,  1,  1),
   vec3( 1,  1, -1), vec3( 1, -1, -1), vec3(-1, -1, -1), vec3(-1,  1, -1),
   vec3( 1,  1,  0), vec3( 1, -1,  0), vec3(-1, -1,  0), vec3(-1,  1,  0),
   vec3( 1,  0,  1), vec3(-1,  0,  1), vec3( 1,  0, -1), vec3(-1,  0, -1),
   vec3( 0,  1,  1), vec3( 0, -1,  1), vec3( 0, -1, -1), vec3( 0,  1, -1)
   // vec3(0, 0, 0)
);

float ShadowCalculationPoint(uint lightIndex, vec3 fragToLight, vec3 fragNorm, /*float currentDepth*/vec3 fragPos)
{
    if (lightIndex != 0u) {
        return 1.0;
    };

    {
        float currentDepth = VectorToDepth(fragToLight);// + bias;

        // currentDepth = -currentDepth * 0.5 + 0.5;

        float visibility = textureGrad(samplerCubeShadow(t_point_shadow_maps, s_point_shadow_maps), vec4(fragToLight, currentDepth), vec3(0), vec3(0));// / (screen_res.w/* - screen_res.z*/)/*1.0 -bias*//*-(currentDepth - bias) / screen_res.w*//*-screen_res.w*/);
        /* if (visibility == 1.0 || visibility == 0.0) {
            return visibility;
        } */
        /* if (visibility >= 0.75) {
            return 1.0;
        }
        if (visibility <= 0.25) {
            return 0.0;
        } */
        /* if (visibility < 1.0) {
            return 0.0;
        } */
        // return visibility;
        /* if (visibility == 1.0) {
            return visibility;
        } */
        return visibility;
        // return visibility == 1.0 ? 1.0 : 0.0;
    }

    // float shadow = 0.0;
    // float bias   = 0.0;//0.003;//-0.003;//-0.005;//0.001;//-1.0;//-0.001;//0.001;//0.003;//-0.05;//-0.1;//0.0;//0.1
    // float viewDistance = length(cam_pos.xyz - fragPos);
    // vec3 firstDelta = vec3(0.0);///*min(viewDistance, 5.0) * *//**normalize(cam_pos - fragPos)*/fragNorm * 0.5;
    // fragToLight += firstDelta;
    // // viewDistance -= length(firstDelta);
    // fragPos -= firstDelta;

    // int samples  = 20;
    // // float lightDistance = length(fragToLight);
    // // float diskRadius = 0.00001;
    // // float diskRadius = 1.0;
    // // float diskRadius = 0.05;
    // float diskRadius = 5.0 / screen_res.w;// (1.0 + (/*viewDistance*/viewDistance / screen_res.w)) / 25.0;
    // // float diskRadius = lightDistance;
    // for(int i = 0; i < samples; ++i)
    // {
    //     float currentDepth = VectorToDepth(fragToLight + sampleOffsetDirections[i] * diskRadius) + bias;
    //     // float closestDepth = texture(depthMap, fragToLight).r;
    //     // closestDepth *= far_plane;   // Undo mapping [0;1]
    //     /* if(currentDepth - bias > closestDepth)
    //         shadow += 1.0;*/
    //     float visibility = texture(t_point_shadow_maps, vec4(fragToLight, currentDepth)/*, -2.5*/);
    //     shadow += visibility;
    //     // float closestDepth = texture(t_shadow_maps, vec3(fragToLight)/*, -2.5*/).r;
    //     // shadow += closestDepth > currentDepth ? 1.0 : 0.0;
    // }
    // shadow /= float(samples);
    // // shadow = shadow * shadow * (3.0 - 2.0 * shadow);

    // // use the light to fragment vector to sample from the depth map
    // // float bias = 0.0;///*0.05*/0.01;//0.05;// 0.05;
    // // float closestDepth = texture(t_shadow_maps, /*vec4*/vec3(fragToLight/*, (lightIndex + 1)*//* * 6*/)/*, 0.0*//*, 0.0*//*, bias*/).r;
    // // // // float closestDepth = texture(t_shadow_maps, vec4(fragToLight, lightIndex), bias);
    // // // // it is currently in linear range between [0,1]. Re-transform back to original value
    // // closestDepth = (closestDepth + 0.0) * screen_res.w; // far plane
    // // // // now test for shadows
    // // // // float shadow = /*currentDepth*/(screen_res.w - bias) > closestDepth ? 1.0 : 0.0;
    // // float shadow = currentDepth - bias < closestDepth ? 1.0 : 0.0;
    // // float visibility = textureProj(t_shadow_maps, vec4(fragToLight, lightIndex), bias);
    // // float visibility = texture(t_shadow_maps, vec4(fragToLight, lightIndex + 1), -(currentDepth/* + screen_res.z*/) / screen_res.w);// / (screen_res.w/* - screen_res.z*/)/*1.0 -bias*//*-(currentDepth - bias) / screen_res.w*//*-screen_res.w*/);
    // // currentDepth += bias;
    // // currentDepth = -1000.0 / (currentDepth + 10000.0);
    // // currentDepth /= screen_res.w;
    // // float currentDepth = VectorToDepth(fragToLight) + bias;

    // // float visibility = texture(t_shadow_maps, vec4(fragToLight, currentDepth));// / (screen_res.w/* - screen_res.z*/)/*1.0 -bias*//*-(currentDepth - bias) / screen_res.w*//*-screen_res.w*/);
    // // return visibility == 1.0 ? 1.0 : 0.0;
    // return shadow;
}

float ShadowCalculationDirected(in vec3 fragPos)//in vec4 /*light_pos[2]*/sun_pos, vec3 fragPos)
{
    float bias = 0.000;//0.0005;//-0.0001;// 0.05 / (2.0 * view_distance.x);
    float diskRadius = 0.01;
    const vec3 sampleOffsetDirections[20] = vec3[]
    (
       vec3( 1,  1,  1), vec3( 1, -1,  1), vec3(-1, -1,  1), vec3(-1,  1,  1),
       vec3( 1,  1, -1), vec3( 1, -1, -1), vec3(-1, -1, -1), vec3(-1,  1, -1),
       vec3( 1,  1,  0), vec3( 1, -1,  0), vec3(-1, -1,  0), vec3(-1,  1,  0),
       vec3( 1,  0,  1), vec3(-1,  0,  1), vec3( 1,  0, -1), vec3(-1,  0, -1),
       vec3( 0,  1,  1), vec3( 0, -1,  1), vec3( 0, -1, -1), vec3( 0,  1, -1)
       // vec3(0, 0, 0)
    );
    /* if (lightIndex >= light_shadow_count.z) {
        return 1.0;
    } */
    // vec3 fragPos = sun_pos.xyz;// / sun_pos.w;//light_pos[lightIndex].xyz;
    // sun_pos.z += sun_pos.w * bias;
    vec4 sun_pos = texture_mat/*shadowMatrices*/ * vec4(fragPos, 1.0);
    // sun_pos.xy = 0.5 * sun_pos.w + sun_pos.xy * 0.5;
    // sun_pos.xy = sun_pos.ww - sun_pos.xy;
    // sun_pos.xyz /= abs(sun_pos.w);
    // sun_pos.w = sign(sun_pos.w);
    // sun_pos.xy = (sun_pos.xy + 1.0) * 0.5;
    // vec4 orig_pos = warpViewMat * lightViewMat * vec4(fragPos, 1.0);
    //
    // vec4 shadow_pos;
    // shadow_pos.xyz = (warpProjMat * orig_pos).xyz:
    // shadow_pos.w = orig_pos.y;
    //
    // sun_pos.xy = 0.5 * (shadow_pos.xy + shadow_pos.w) = 0.5 * (shadow_pos.xy + orig_pos.yy);
    // sun_pos.z = shadow_pos.z;
    //
    // sun_pos.w = sign(shadow_pos.w) = sign(orig_pos.y);
    // sun_pos.xyz = sun_pos.xyz / shadow_pos.w = vec3(0.5 * shadow_pos.xy / orig_pos.yy + 0.5, shadow_pos.z / orig_pos.y)
    //             = vec3(0.5 * (2.0 * warp_pos.xy / orig_pos.yy - (max_warp_pos + min_warp_pos).xy) / (max_warp_pos - min_warp_pos).xy + 0.5,
    //                    -(warp_pos.z / orig_pos.y - min_warp_pos.z) / (max_warp_pos - min_warp_pos).z )
    //             = vec3((warp_pos.x / orig_pos.y - min_warp_pos.x) / (max_warp_pos - min_warp_pos).x,
    //                    (warp_pos.y / orig_pos.y - min_warp_pos.y) / (max_warp_pos - min_warp_pos).y,
    //                    -(warp_pos.z / orig_pos.y - min_warp_pos.z) / (max_warp_pos - min_warp_pos).z )
    //             = vec3((near * orig_pos.x / orig_pos.y - min_warp_pos.x) / (max_warp_pos - min_warp_pos).x,
    //                    (((far+near) - 2.0 * near * far / orig_pos.y)/(far-near) - min_warp_pos.y) / (max_warp_pos - min_warp_pos).y,
    //                    -(near * orig_pos.z / orig_pos.y - min_warp_pos.z) / (max_warp_pos - min_warp_pos).z )
    //             = vec3((near * orig_pos.x / orig_pos.y - min_warp_pos.x) / (max_warp_pos - min_warp_pos).x,
    //                    (2.0 * (1.0 - far / orig_pos.y)*near/(far-near) + 1.0 - min_warp_pos.y) / (max_warp_pos - min_warp_pos).y,
    //                    -(near * orig_pos.z / orig_pos.y - min_warp_pos.z) / (max_warp_pos - min_warp_pos).z )
    //             = vec3((near * orig_pos.x / orig_pos.y - min_warp_pos.x) / (max_warp_pos - min_warp_pos).x,
    //                    (2.0 * (1.0 - far / orig_pos.y)*near/(far-near) + 1.0 - 0.0) / (1.0 - 0.0),
    //                    -(near * orig_pos.z / orig_pos.y - min_warp_pos.z) / (max_warp_pos - min_warp_pos).z )
    //             = vec3((near * orig_pos.x / orig_pos.y - min_warp_pos.x) / (max_warp_pos - min_warp_pos).x,
    //                    2.0 * (1.0 - far / orig_pos.y)*near/(far-near) + 1.0,
    //                    -(near * orig_pos.z / orig_pos.y - min_warp_pos.z) / (max_warp_pos - min_warp_pos).z )
    //
    // orig_pos.y = n: warp_pos.y = 2*(1-f/n)*n/(f-n) + 1 = 2*(n-f)/(f-n) + 1 = 2 * -1 + 1 = -1, sun_pos.y = (-1 - -1) / 2 = 0
    // orig_pos.y = f: warp_pos.y = 2*(1-f/f)*n/(f-n) + 1 = 2*(1-1)*n/(f-n) + 1 = 2 * 0 * n/(f-n) + 1 = 1, sun_pos.y = (1 - -1) / 2 = 1
    //
    float visibility = textureProj(sampler2DShadow(t_directed_shadow_maps, s_directed_shadow_maps), sun_pos);
    /* float visibilityLeft = textureProj(t_directed_shadow_maps, sun_shadow.texture_mat * vec4(fragPos + vec3(0.0, -diskRadius, 0.0), 1.0));
    float visibilityRight = textureProj(t_directed_shadow_maps, sun_shadow.texture_mat * vec4(fragPos + vec3(0.0, diskRadius, 0.0), 1.0)); */
    // float nearVisibility = textureProj(t_directed_shadow_maps + vec3(0.001, sun_pos));
    // float visibility = textureProj(t_directed_shadow_maps, vec4(fragPos.xy, /*lightIndex, */fragPos.z + bias, sun_pos.w));
    // return visibility;
    // return min(visibility, min(visibilityLeft, visibilityRight));
    // return mix(visibility, 0.0, sun_pos.z < -1.0);
    // return mix(mix(0.0, 1.0, visibility == 1.0), 1.0, sign(sun_pos.w) * sun_pos.z > /*1.0*/abs(sun_pos.w));
    // return (visibility - 0.5) * (visibility - 0.5) * 2.0 * sign(visibility - 0.5) + 0.5;// visibility > 0.75 ? visibility : 0.0;// visibility > 0.9 ?  1.0 : 0.0;
    return visibility;
    // return visibility == 1.0 ? 1.0 : 0.0;
    // return abs(fragPos.y - round(fragPos.y)) <= 0.1 || abs(fragPos.x - round(fragPos.x)) <= 0.1 ? ( visibility == 1.0 ? 1.0 : 0.0) : visibility;
    /* if (visibility == 1.0) {
        return 1.0;
    } */
    // return visibility;
    /* if (fragPos.z > 1.0) {
        return 1.0;
    } */
    // vec3 snapToZ = abs(fragPos - vec3(ivec3(fragPos))); // fract(abs(fragPos));
    // // snapToZ = min(snapToZ, 1.0 - snapToZ);
    // const float EDGE_DIST = 0.01;
    // snapToZ = mix(vec3(0.0), vec3(1.0), lessThanEqual(snapToZ, vec3(EDGE_DIST)));
    // // float snapToZDist = dot(snapToZ, snapToZ);
    // if (visibility <= 0.75 && /*fract(abs(fragPos.xy)), vec2(0.1)))*/ /*snapToZDist <= 0.25*//*all(lessThan(snapToZ, vec3(0.1)))(*/
    //     snapToZ.x + snapToZ.y + snapToZ.z >= 2.0) {
    //     return 0.0;
    // }
    // int samples  = 20;
    // float shadow = 0.0;
    // // float bias   = 0.0001;
    // // float viewDistance = length(cam_pos.xyz - fragPos);
    // // float diskRadius = 0.2 * (1.0 + (viewDistance / screen_res.w)) / 25.0;
    // // float diskRadius = 0.0003;//0.005;// / (2.0 * view_distance.x);//(1.0 + (viewDistance / screen_res.w)) / 25.0;
    // fragPos = sun_pos.xyz / sun_pos.w;
    // for(int i = 0; i < samples; ++i)
    // {
    //     vec3 currentDepth = fragPos + vec3(sampleOffsetDirections[i].xyz) * diskRadius + bias;
    //     visibility = texture(t_directed_shadow_maps, currentDepth);//vec4(currentDepth.xy, lightIndex, currentDepth.z)/*, -2.5*/);
    //     // visibility = texture(t_directed_shadow_maps, vec4(currentDepth.xy, lightIndex, currentDepth.z)/*, -2.5*/);
    //     shadow += visibility;
    //     // mix(visibility, 1.0, visibility >= 0.5);
    // }
    // shadow /= float(samples);
    // return shadow;
}
    #elif (SHADOW_MODE == SHADOW_MODE_NONE || SHADOW_MODE == SHADOW_MODE_CHEAP)
float ShadowCalculationPoint(uint lightIndex, vec3 fragToLight, vec3 fragNorm, /*float currentDepth*/vec3 fragPos)
{
    return 1.0;
}
    #endif
#else
float ShadowCalculationPoint(uint lightIndex, vec3 fragToLight, vec3 fragNorm, /*float currentDepth*/vec3 fragPos)
{
    return 1.0;
}
#endif

#endif
