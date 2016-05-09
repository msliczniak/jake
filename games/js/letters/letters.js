// by Jake

// initialization

	screen = {}
	seed=""
	
// must be Upper case
	nkey="W"
	skey="S"
    
    nkey2="O"
    skey2="L"
	cl="" // clear
	hi=""
	lo=""
	vb=""

	colors=""

	width = 0
	height = 0

	//cols = w
	//lines = h


// cl clear screen
// hi stand-out
// lo normal

// call end() on game-over

// draws the screen with players and enemies.
function draw(  i, j, gameover) {

	t=""

	//printf("%s", carr[1] cl)
	for (j = 1; j <= height; j = j + 1) {
		for (i = 1; i <= width; i = i + 1) {
			if (i == 1) {
				if (player1h == j) {
                    //printf("%s", carr[1] "<" carr[1])
                    if (player1h == player2h) {
                        t+="X"
                    } else {
                        t+="&lt;"
                    }

					if (screen[i,j] == "*") gameover = 1
					
					continue
				}
                
				if (player2h == j) {
					//printf("%s", carr[1] ">" carr[1])
					t+="&gt;"

					if (screen[i,j] == "*") gameover = 1
					
					continue
				}
			}
			
			t+= screen[[i,j]]
		}
		
		t+= "\n"
	}

	t+= "\n" + score
	s.innerHTML = t;
	
	if (gameover == 1) end()
}


function init(  i, j) {
	errstat=0
	
	//print carr[1]
	
	// use terminal size if you can
	//print cols, lines > "/dev/stderr"
	if (cols > 0) width = cols - 1
	if (lines > 0) height = lines - 2
	
	// seems to help the early distribution on some old awks
	for (i=0; i<256; i+=1) Math.random();
	
	//colors=split(colors, carr)
	
	//print carr[1]

	score=0

	player1h = Math.floor(height / 3)
    
    player2h = 2 * Math.floor(height / 3)
	
	for (j = 1; j <= height; j = j + 1) {
		for (i = 1; i <= width; i = i + 1) {
			screen[[i,j]] = " "
		}
	}
	
	screen[[width,player1h]] = "*"
	screen[[width,player2h]] = "*"
	//printf("%s", hi)
	draw()
}

function upplayerone()
{
	if (player1h <= 1) return

	player1h = player1h - 1
	draw()
}


function downplayerone()
{
	if (player1h >= height) return
	
	player1h = player1h + 1
	draw()
}


function upplayertwo()
{
	if (player2h <= 1) return

	player2h = player2h - 1
	draw()
}


function downplayertwo()
{
	if (player2h >= height) return
	
	player2h = player2h + 1
	draw()
}

function screenleft(  i, j) {
	score = score + 1

	// move all left
	for (j = 1; j <= height; j = j + 1) {
		for (i = 2; i <= width; i = i + 1) {
			screen[[i - 1,j]] = screen[[i,j]]
		}
	}
	
	// fill spaces in right column
	for (j = 1; j <= height; j = j + 1) {
		screen[[width,j]] = " "
	}
	
	// put enemy randomly in right column
	j = Math.floor(Math.random() * height) + 1
	screen[[width,j]] = "*"
	
	// put another enemy randomly in right column
	i = Math.floor(Math.random() * (height - 1)) + 1
	i = j + i
	if (i > height) i = i - height
	screen[[width,i]] = "*"
}


function handle(c) {
	if (c.toUpperCase()==nkey) {
        upplayerone()
    } else if (c.toUpperCase()==skey) {
        downplayerone()
	} else if (c.toUpperCase()==nkey2) {
        upplayertwo()
    } else if (c.toUpperCase()==skey2) {
        downplayertwo()
    }

    screenleft()
}
