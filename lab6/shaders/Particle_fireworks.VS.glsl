#version 430

// Input
layout(location = 0) in vec3 v_position;
layout(location = 1) in vec3 v_normal;
layout(location = 2) in vec2 v_texture_coord;

// Uniform properties
uniform mat4 Model;
uniform vec3 generator_position;
uniform float deltaTime;


struct Particle
{
    vec4 position;
    vec4 speed;
    vec4 iposition;
    vec4 ispeed;
    float delay;
    float iDelay;
    float lifetime;
    float iLifetime;
};


layout(std430, binding = 0) buffer particles {
    Particle data[];
};


float rand(vec2 co)
{
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

// Spiral Curve 1
vec3 P0_curve1 = vec3(0.0, 0.0, 0.0);
vec3 P1_curve1 = vec3(2.0, 2.0, 2.0);
vec3 P2_curve1 = vec3(4.0, 0.0, -2.0);
vec3 P3_curve1 = vec3(6.0, 0.0, 0.0);

// Spiral Curve 2
vec3 P0_curve2 = vec3(0.0, 0.0, 0.0);
vec3 P1_curve2 = vec3(-2.0, 2.0, 2.0);
vec3 P2_curve2 = vec3(-4.0, 0.0, -2.0);
vec3 P3_curve2 = vec3(-6.0, 0.0, 0.0);

// Spiral Curve 3
vec3 P0_curve3 = vec3(0.0, 0.0, 0.0);
vec3 P1_curve3 = vec3(2.0, -2.0, 2.0);
vec3 P2_curve3 = vec3(4.0, 0.0, -2.0);
vec3 P3_curve3 = vec3(6.0, 0.0, 0.0);

// Spiral Curve 4
vec3 P0_curve4 = vec3(0.0, 0.0, 0.0);
vec3 P1_curve4 = vec3(-2.0, -2.0, 2.0);
vec3 P2_curve4 = vec3(-4.0, 0.0, -2.0);
vec3 P3_curve4 = vec3(-6.0, 0.0, 0.0);

// Spiral Curve 5
vec3 P0_curve5 = vec3(0.0, 0.0, 0.0);
vec3 P1_curve5 = vec3(2.0, 2.0, -2.0);
vec3 P2_curve5 = vec3(4.0, 0.0, 2.0);
vec3 P3_curve5 = vec3(6.0, 0.0, 0.0);



vec3 bezier(float t, int id)
{
    if(id % 5 == 0)
        return  P0_curve1 * pow((1 - t), 3) +
                P1_curve1 * 3 * t * pow((1 - t), 2) +
                P2_curve1 * 3 * pow(t, 2) * (1 - t) +
                P3_curve1 * pow(t, 3);
    if(id % 5 == 1)
        return  P0_curve2 * pow((1 - t), 3) +
                P1_curve2 * 3 * t * pow((1 - t), 2) +
                P2_curve2 * 3 * pow(t, 2) * (1 - t) +
                P3_curve2 * pow(t, 3);
    if(id % 5 == 2)
        return  P0_curve3 * pow((1 - t), 3) +
                P1_curve3 * 3 * t * pow((1 - t), 2) +
                P2_curve3 * 3 * pow(t, 2) * (1 - t) +
                P3_curve3 * pow(t, 3);
    if(id % 5 == 3)
        return  P0_curve4 * pow((1 - t), 3) +
                P1_curve4 * 3 * t * pow((1 - t), 2) +
                P2_curve4 * 3 * pow(t, 2) * (1 - t) +
                P3_curve4 * pow(t, 3);
    if(id % 5 == 4)
        return  P0_curve5 * pow((1 - t), 3) +
                P1_curve5 * 3 * t * pow((1 - t), 2) +
                P2_curve5 * 3 * pow(t, 2) * (1 - t) +
                P3_curve5 * pow(t, 3);

}

void main()
{
    data[gl_VertexID].delay-= deltaTime;

    if (data[gl_VertexID].delay> 0) {
        gl_Position = Model * vec4(generator_position, 1);
        return;
    }

    float t = (data[gl_VertexID].iLifetime - data[gl_VertexID].lifetime) / data[gl_VertexID].iLifetime;
    
    vec3 pos = bezier(t, gl_VertexID);
    

    if(data[gl_VertexID].lifetime < 0)
    {
        data[gl_VertexID].position.xyz = data[gl_VertexID].iposition.xyz;
        data[gl_VertexID].speed.xyz = data[gl_VertexID].ispeed.xyz;
        data[gl_VertexID].lifetime = data[gl_VertexID].iLifetime;
    }

    data[gl_VertexID].lifetime -= deltaTime * length(data[gl_VertexID].speed);
    data[gl_VertexID].position.xyz = pos;
    gl_Position = Model * vec4(pos + generator_position, 1);
}
