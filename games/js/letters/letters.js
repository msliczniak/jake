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
					t+="<"

					if (screen[i,j] == "X") gameover = 1
					
					continue
				}
                
				if (player2h == j) {
					//printf("%s", carr[1] ">" carr[1])
					t+=">"

					if (screen[i,j] == "X") gameover = 1
					
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
	
	screen[[width,player1h]] = "X"
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



function handle(c) {
	if (c.toUpperCase()==nkey) upplayerone()
	else if (c.toUpperCase()==skey) downplayerone()
	
	else if (c.toUpperCase()==nkey2) upplayertwo()
	else if (c.toUpperCase()==skey2) downplayertwo()

}
