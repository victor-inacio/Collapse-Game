void main() {
    // Defina a cor do fundo (background) da cena
    vec4 backgroundColor = vec4(0.0, 0.0, 0.0, 1.0); // Cor preta
    
    // Aplique uma função de distorção ao componente Y (vertical) da coordenada de tela
    float offset = sin(u_time * 10.0 + v_tex_coord.y * 30.0) * 0.02;
    float distortedY = v_tex_coord.y + offset;
    
    // Verifique se a coordenada de tela está dentro dos limites da cena (0.0 a 1.0)
    if (distortedY < 0.0 || distortedY > 1.0) {
        // Se a coordenada estiver fora dos limites, use a cor de fundo original
        gl_FragColor = backgroundColor;
    } else {
        // Caso contrário, obtenha a cor original do fundo da cena na coordenada de tela distorcida
        vec2 distortedTexCoord = vec2(v_tex_coord.x, distortedY);
        vec4 textureColor = texture2D(u_texture, distortedTexCoord);
        // Defina a cor final do pixel
        gl_FragColor = textureColor;
    }
}
