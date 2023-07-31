void main() {
    // Obtém a cor original do pixel da textura
    // Obtém a cor original do pixel da textura
    vec4 originalColor = texture2D(u_texture, v_tex_coord);
    
    // Combina a cor original com a cor branca, apenas alterando a cor da textura
    vec4 finalColor = vec4(1 * SKDefaultShading().a, 0.647 * SKDefaultShading().a, 0 * SKDefaultShading().a, SKDefaultShading().a);
    
    // Define a cor final do pixel combinando a cor branca com a cor original da textura
    gl_FragColor = finalColor;
}
