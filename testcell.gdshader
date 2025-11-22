shader_type canvas_item;

uniform float near : hint_range(0.01, 1.0) = 0.1;
uniform float far  : hint_range(1.0, 500.0) = 100.0;
uniform sampler2D DEPTH_TEXTURE: hint_depth_texture;

float linearize_depth(float z)
{
	return (2.0 * near) / (far + near - z * (far - near));
}


void fragment() {
	float raw_depth = texture_depth(SCREEN_UV);
	float depth = linearize_depth(raw_depth);
	
	if (depth <= near+1e-4) {
		COLOR = vec4(0.0, 0.0, 0.0, 1.0)
	} else {
		COLOR = texture(SCREEN_TEXTURE, SCREEN_UV);
	}
	)
}

void vertex() {
	// Called for every vertex the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
