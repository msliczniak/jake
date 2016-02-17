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
}

// cl clear screen
// hi stand-out
// lo normal

function draw(  i, j) {
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

function init(  i, j) {
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

	player1h = int(height / 2)
	
	for (j = 1; j <= height; j = j + 1) {
		for (i = 1; i <= width; i = i + 1) {
			screen[i,j] = " "
		}
	}
	
	screen[width,player1h] = "X"
	printf("%s", hi)
	draw()
}

function screenleft(  i, j) {
	// move all left
	for (j = 1; j <= height; j = j + 1) {
		for (i = 2; i <= width; i = i + 1) {
			screen[i - 1,j] = screen[i,j]
		}
	}
	
	// fill spaces in right column
	for (j = 1; j <= height; j = j + 1) {
		screen[width,j] = " "
	}
	
	// put enemy randomly in right column
	j = int(rand() * height) + 1
	screen[width,j] = "X"
	
	// put another enemy randomly in right column
	i = int(rand() * (height - 1)) + 1
	i = j + i
	if (i > height) i = i - height
	screen[width,i] = "X"
}



// argument processing
NR == 1 { init(); next }

{ screenleft() }

// moves player up
tolower($0) == nkey {
	if (player1h > 1)   player1h = player1h - 1

	draw()
}

// moves player down
tolower($0) == skey {
	if (player1h < height)   player1h = player1h + 1

	draw()
}
