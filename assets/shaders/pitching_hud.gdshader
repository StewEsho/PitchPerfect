shader_type canvas_item;

uniform float progress : hint_range(0, 1);
uniform bool goingLeft;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 tex_col = texture(TEXTURE, UV);
	float progress_alpha = float(goingLeft) * float((1.0 - UV.x) < progress) +
						   float(!goingLeft) * float(UV.x < progress);
	COLOR = vec4(tex_col.xyz, tex_col.a * progress_alpha); // read from texture
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
