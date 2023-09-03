#version 150

/*
MIT License

Copyright (c) 2020 Bradley Qu

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

#moj_import <matrix.glsl>

uniform sampler2D Sampler0;
uniform sampler2D Sampler1;

uniform float GameTime;
uniform int EndPortalLayers;

in vec3 pos;

const float PI = 3.14159265359;

const vec3[] COLORS = vec3[](
vec3(0.022087, 0.098399, 0.110818),
vec3(0.011892, 0.095924, 0.089485),
vec3(0.027636, 0.101689, 0.100326),
vec3(0.046564, 0.109883, 0.114838),
vec3(0.064901, 0.117696, 0.097189),
vec3(0.063761, 0.086895, 0.123646),
vec3(0.084817, 0.111994, 0.166380),
vec3(0.097489, 0.154120, 0.091064),
vec3(0.106152, 0.131144, 0.195191),
vec3(0.097721, 0.110188, 0.187229),
vec3(0.133516, 0.138278, 0.148582),
vec3(0.070006, 0.243332, 0.235792),
vec3(0.196766, 0.142899, 0.214696),
vec3(0.047281, 0.315338, 0.321970),
vec3(0.204675, 0.390010, 0.302066),
vec3(0.080955, 0.314821, 0.661491)
);

const mat3 SCALE_TRANSLATE = mat3(
0.5, 0.0, 0.25,
0.0, 0.5, 0.25,
0.0, 0.0, 1.0
);

mat3 end_portal_layer(float layer) {
    mat3 translate = mat3(
    1.0, 0.0, 17.0 / layer,
    0.0, 1.0, (2.0 + layer / 1.5) * (GameTime * 1.5),
    0.0, 0.0, 1.0
    );

    mat2 scale = mat2((4.5 - layer / 4.0) * 2.0);

    return mat3(scale) * translate * SCALE_TRANSLATE;
}

vec3 proj_3d_to_2d(vec3 dir) {
    dir.xz = normalize(dir.xz);
    dir.x = (dir.z > 0.0 ? acos(dir.x) : 2 * PI - acos(dir.x)) / PI * 2.0;
    dir.y = (acos(dir.y)) / PI * 2.0;
    dir.z = 1.0;

    return dir;
}

out vec4 fragColor;

void main() {
    vec4 outColor = vec4(1.0);

    vec3 tmppos = normalize(pos);
    tmppos = proj_3d_to_2d(tmppos);

    outColor.rgb = texture(Sampler0, tmppos.xy).rgb * COLORS[0];

    for (int i = 0; i < EndPortalLayers; i++) {
        float layer = float(i) + 1.0;
        tmppos = proj_3d_to_2d(mat3(mat2_rotate_z(radians((layer * layer * 4321.0 + layer * 9.0) * 2.0))) * normalize(pos));
        outColor.rgb += texture(Sampler1, (tmppos * end_portal_layer(float(i + 1))).xy).rgb * COLORS[i];
    }

    fragColor = outColor;
}