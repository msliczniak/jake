// call end() on game-over

function init() {
	t = "";
	for (j = 0; j < h; j++) {
		for (i = 0; i < w; i++)
			t += "."
		t += "\n"
	}
	s.innerHTML = t;
}

function handle(c) {
	t = c + "\n"
	for (j = 1; j < h; j++) {
		for (i = 0; i < w; i++)
			t += "."
		t += "\n"
	}

	s.innerHTML = t;
}
