shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	if(COLOR.b >= 0.322 - 0.003 && COLOR.b <= 0.322 + 0.3){
		COLOR.rgb = vec3(1, 0.495, 0.494);
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
