// by Jake

// initialization
BEGIN {
	seed=""
	
// must be lower case
	nkey="w"
	skey="s"
	
	cl="" # clear
	hi=""
	lo=""
	vb=""

	colors=""

	width = 40
	height = 20

	player1h = int(height / 2)
	
	for (j = 1; j <= height; j = j + 1) {
		for (i = 1; i <= width; i = i + 1) {
			screen[i,j] = " "
		}
	}
	printf("%s", hi)
	draw()
}

// cl clear screen
// hi stand-out
// lo normal

function draw() {
	printf("%s", cl)
	for (j = 1; j <= height; j = j + 1) {
		for (i = 1; i <= width; i = i + 1) {
			if (i == 1) {
				if (player1h == j) {
					printf("%s", "<")

					continue
				}
			}
			
			printf("%s", screen[i,j])
		}
		
		print ""
	}
}

function init() {
	errstat=0
	
	// if there was no seed provided, get one from the system time
	if (seed == "") {
		// returns 0, but picks one based on time
		srand()
		
		// what was it
		seed=srand()
	}
	
	srand(seed)
	
	// seems to help the early distribution on some old awks
	for (i=0; i<256; i+=1) rand();
	
		colors=split(colors, carr)
		
		score=0
}



// argument processing
NR == 1 { init(); next }

tolower($0) == nkey {
	if (player1h > 1)   player1h = player1h - 1

	draw()
}
