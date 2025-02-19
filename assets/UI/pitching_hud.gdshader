shader_type canvas_item;

uniform float progress;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 tex_col = texture(TEXTURE, UV);
	COLOR = vec4(tex_col.xyz, tex_col.a * float(UV.x < progress)); // read from texture
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
