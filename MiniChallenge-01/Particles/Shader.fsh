

void main() {
    // Calcula o valor de interpolação do gradiente
    float speed = u_time * 0.35;
    float frequency = 14.0;
    float intensity = 0.006;
    
    // Get the coordinate for the target pixel
    vec2 coord = v_tex_coord;
    
    // Modify (offset slightly) using a sine wave
    coord.x += cos((coord.x + speed) * frequency) * intensity;
    coord.y += sin((coord.y + speed) * frequency) * intensity;
    
    // Rather than the original pixel color, using the offset target pixel
    vec4 targetPixelColor = texture2D(u_texture, coord);
    
    // Finish up by setting the actual color on gl_FragColor
    gl_FragColor = targetPixelColor;
}
