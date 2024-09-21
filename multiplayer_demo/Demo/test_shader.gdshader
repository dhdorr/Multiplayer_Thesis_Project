shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	//COLOR.rgb = vec3(0.2, 0.4, 0.2);
	// bg color of sprite = 363d52
	//COLOR = #363d52;
	if(COLOR.b >= 0.322 - 0.003 && COLOR.b <= 0.322 + 0.3){
		COLOR.rgb = vec3(0, 0.793, 0.528);
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
