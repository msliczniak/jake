// by Jake

// initialization

	seed=""
	
// must be Upper case
	nkey="W"
	skey="S"
    
    nkey2="O"
    skey2="L"
	cl="" # clear
	hi=""
	lo=""
	vb=""

	colors=""

	width = 40
	height = 20


// cl clear screen
// hi stand-out
// lo normal

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
