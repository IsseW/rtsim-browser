vec4 aa_apply(
    texture2D tex, sampler smplr,
    texture2D depth_tex, sampler depth_smplr,
    vec2 fragCoord,
    vec2 resolution
) {
    return texelFetch(sampler2D(tex, smplr), ivec2(fragCoord * textureSize(sampler2D(tex, smplr), 0).xy / resolution), 0);
}
