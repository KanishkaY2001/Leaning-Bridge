// Welcome to: Leaning Bridge, by K. Yamani
// Enjoy Haha :)

// Main Part Config
PShape part;
float strokeNum = 1.5;
float partSizeX;
float partSizeY;
float partPosX;
float partPosY;
int partLevelX = 10;
int partLevelY = 8; // The 3rd position being 'Ideal'
int[] partColor = {255, 147, 79};

// Main Ball Config
PShape ball;
float ballSizeX;
float ballSizeY;
float ballPosX;
float ballPosY;

// Overlay
PShape overlay;
int[] winColor = {0, 0, 0};

// Other Internal Variables
int waitTime = 50;
int failTime = 300;
float gap;
boolean gameOver = false;
boolean gameWin = false;
boolean increaseY = false;
boolean enter = false;
boolean space = false;
boolean paused = true;
float textSizer;

// Part Placement Variables
PShape[] placedParts = new PShape[0];
float[][] partPositions = new float[0][0];

// Stylistic Variables
PShape leftUpperWall;
PShape rightUpperWall;
PShape leftLowerWall;
PShape rightLowerWall;

// Main Part Function
void partCreate() {
  // Defining Part Characteristics
  part = createShape(RECT, -partSizeX/2, -partSizeY/2, partSizeX, partSizeY);
  part.setFill(color(partColor[0], partColor[1], partColor[2]));
  strokeWeight(strokeNum);
  if (partLevelY == 1) {
    shape(part, gap+partPosX, partPosY-strokeNum); // Producing Part At (_,X,Y) Position
  } else {
    shape(part, gap+partPosX, partPosY); // Producing Part At (_,X,Y) Position
  }
}

// Main Ball Function
void ballCreate() {
  ball = createShape(ELLIPSE, -ballSizeX/2, -ballSizeY/2, ballSizeX, ballSizeY);
  ball.setFill(color(60,120,180));
  shape(ball, ballPosX, ballPosY); // Producing Part At (_,X,Y) Position
  if ((gameWin) && (ballPosX < width-(0.48*width/10.)+partSizeX/2)) {
    ballPosX = ballPosX+5;
  } else if ((gameWin) && (ballPosX >= width-(0.48*width/10.)+partSizeX/2)) {
    delay(1000);
    resetVariables();
  }
}

// Creating Exterior Stuff Function
void wallCreate() {
  leftUpperWall = createShape(RECT, 0, 0, gap, partSizeY*3);
  leftUpperWall.setFill(color(160, 90, 90));
  shape(leftUpperWall, 0, 0);

  rightUpperWall = createShape(RECT, 0, 0, gap, partSizeY*3);
  rightUpperWall.setFill(color(160, 90, 90));
  shape(rightUpperWall, floor(width-gap-0.5), 0);

  leftLowerWall = createShape(RECT, 0, 0, gap, partSizeY*3);
  leftLowerWall.setFill(color(160, 90, 90));
  shape(leftLowerWall, 0, height-partSizeY*3);

  rightLowerWall = createShape(RECT, 0, 0, gap, partSizeY*3);
  rightLowerWall.setFill(color(160, 90, 90));
  shape(rightLowerWall, floor(width-gap-0.5), height-partSizeY*3);
}

// Displaying All Placed Parts Function
void totalParts() {
  for (int i = 0; i<placedParts.length; i+=1) {
    shape(placedParts[i], gap+partPositions[i][0], partPositions[i][1]);
    if ((placedParts.length == 10) && (gameOver == true)) {
      placedParts[9].setFill(color(partColor[0], partColor[1], partColor[2]));
    }
  }
}

// Main Vertical Movement Function
void partMovementY() {
  while ((gameOver == false) && (gameWin == false)) {
    delay(waitTime*partLevelX); // Amount Of Wait Time Per Part Placement

    // Moves Part Up & Down
    if ((paused == false) && (gameOver == false)) {
      if ((increaseY == true) && (partLevelY < 8)) {
        partLevelY += 1;
      } else if ((increaseY == true) && (partLevelY == 8)) {
        increaseY = false;
        partLevelY -= 1;
      } else if ((increaseY == false) && (partLevelY > 1)) {
        partLevelY -= 1;
      } else if ((increaseY == false) && (partLevelY == 1)) {
        increaseY = true;
        partLevelY += 1;
      }
    }
    partPosY = height-(partLevelY*height/8.)+partSizeY/2+strokeNum/2; // Update Part Y Position
  }
}

// Main Horizontal Movement Function
void partMovementX() {
  if ((paused == false) && (gameOver == false)) {
    if ((increaseY == true) && (partLevelY < 8)) {
      partLevelY += 1;
    } else if ((increaseY == true) && (partLevelY == 8)) {
      increaseY = false;
      partLevelY -= 1;
    } else if ((increaseY == false) && (partLevelY > 1)) {
      partLevelY -= 1;
    } else if ((increaseY == false) && (partLevelY == 1)) {
      increaseY = true;
      partLevelY += 1;
    }
  }
  partLevelX -= 1;
  partPosY = height-(partLevelY*height/8.)+partSizeY/2+strokeNum/2; // Update Part Y Position
  partPosX = width-(partLevelX*width/10.)+partSizeX/2-(partSizeX/3*(10-partLevelX));
}

void resetVariables() {
  partLevelX = 10;
  partLevelY = 8; // The 3rd position being 'Ideal'
  partColor[0] = 255;
  partColor[1] = 147;
  partColor[2] = 79;
  increaseY = false;
  enter = false;
  space = false;
  paused = true;
  placedParts = new PShape[0];
  partPositions = new float[0][0];
  gap = (width-(width-(width/10.)+partSizeX/2-(partSizeX/3*(9))+partSizeX/2))/2; // Centers Part Placement
  partPosX = width-(partLevelX*width/10.)+partSizeX/2-(partSizeX/3*(10-partLevelX)); // Localize Part X Position
  partPosY = height-(partLevelY*height/8.)+partSizeY/2+strokeNum/2; // Localize Part Y Position
  ballPosX = width-(9.3*width/10.)+partSizeX/2; // Localize Ball X Position
  ballPosY = height-(3.51*height/8.)+partSizeY/2+strokeNum/2; // Localize Ball Y Position
  gameWin = false;
  gameOver = false;
  thread("partMovementY"); // Restart Vertical Movement
}

void winColorChanger() {
  print(4+5);
  while (gameWin) {
    winColor[0] = 0;
    winColor[1] = 0;
    winColor[2] = 0;
    delay(failTime);
    winColor[0] = 80;
    winColor[1] = 255;
    winColor[2] = 255;
    delay(failTime);
  }
}

void resetGame() {
  for (int i = 0; i<3; i+=1) {
    partColor[0] = 255;
    partColor[1] = 70;
    partColor[2] = 70;
    delay(failTime);
    partColor[0] = 240;
    partColor[1] = 240;
    partColor[2] = 240;
    delay(failTime);
  }
  resetVariables();
}

// Main Setup Function
void setup() {
  size(1280,720); // Set Window Size
  partSizeX = width*(90./1280.); // Part X Size According to Window X Size
  partSizeY = height*(90./720.);// Part Y Size According to Window Y Size
  ballSizeX = width*(120./1280.); // Ball X Size According to Window X Size
  ballSizeY = height*(120./720.);// Ball Y Size According to Window Y Size

  println("Current Window Size is: [" + str(width) + " x " + str(height) + "]");
  println("Current Part Size is: [" + str(partSizeX) + " x " + str(partSizeY) + "]");

  gap = (width-(width-(width/10.)+partSizeX/2-(partSizeX/3*(9))+partSizeX/2))/2; // Centers Part Placement
  partPosX = width-(partLevelX*width/10.)+partSizeX/2-(partSizeX/3*(10-partLevelX)); // Localize Part X Position
  partPosY = height-(partLevelY*height/8.)+partSizeY/2+strokeNum/2; // Localize Part Y Position
  ballPosX = width-(9.3*width/10.)+partSizeX/2; // Localize Ball X Position
  ballPosY = height-(3.51*height/8.)+partSizeY/2+strokeNum/2; // Localize Ball Y Position

  thread("partMovementY"); // Start Vertical Movement
}

// Main Draw (active) Function
void draw() {
  background(240, 240, 240); // Refreshes The Screen
  if (partLevelX > 0) {
    partCreate(); // Draws Moving Part
  }
  totalParts(); // Displays Placed Parts
  wallCreate(); // Display Borders/Walls
  ballCreate(); // Display Ball
  
  if (50./1280*width <= 0.5) {
    textSizer = 1;
  } else {
    textSizer = 50./1280*width;
  }
  
  if (paused) {
    // Displaying Grey Overlay
     overlay = createShape(RECT, 0, 0, width, height);
     overlay.setFill(color(0,120));
     shape(overlay, 0, 0); // Producing Part At (_,X,Y) Position
     
     // Displaying Pause Text
     fill(5,5,120);
     String pausedText = "Paused";
     textSize(textSizer);
     text("Paused", width/2-textWidth(pausedText)/2, height/2+height/3);
     
     
     // Displaying Unpause Text
     fill(200,200,100);
     String unpauseText = "'Space' = Pause/Unpause";
     textSize(textSizer);
     text("'Space' = Pause/Unpause", width/2-textWidth(unpauseText)/2, height/2-height/4);
     
     
     // Displaying Enter Text
     String enterText = "'Enter' = Place Tile";
     textSize(textSizer);
     text("'Enter' = Place Tile", width/2-textWidth(enterText)/2, height/2-height/3);
     fill(200,200,100);
  }
  
  if (gameWin) {
    // Displaying Grey Overlay
     overlay = createShape(RECT, 0, 0, width, height);
     overlay.setFill(color(0,120));
     shape(overlay, 0, 0); // Producing Part At (_,X,Y) Position
    
    // Displaying Win Text
     String pausedText = "WINNER!";
     textSize(textSizer);
     text("WINNER!", width/2-textWidth(pausedText)/2, height/2);
     fill(winColor[0],winColor[1],winColor[2]);
  }
}

// Main User Input Entered
void keyPressed() {
  if ((gameOver == false) && (gameWin == false)) {
    if ((keyCode == 10) && (enter == false) && (partLevelX > 0) && (paused == false)) { // 10 = 'ENTER' key
      enter = true;
      // Adding Parts To List Upon Placement
      float[] newPos = {partPosX, partPosY};
      partPositions = (float[][]) append(partPositions, newPos);
      placedParts = (PShape[]) append(placedParts, part);
      if (partLevelY != 3) {
        gameOver = true;
        thread("resetGame");
      } else if (partLevelX == 1) {
        gameWin = true;
        thread("winColorChanger");
      }
      println("Placing Part at Position " + str(partLevelY));
      partMovementX();
    } else if ((keyCode == 32) && (space == false) && (paused == false)) { // 32 = 'SPACE' key
      space = true;
      paused = true;
      println("Pause");
    } else if ((keyCode == 32) && (paused == true) && (space == false)) { // 32 = 'SPACE' key
      space = true;
      paused = false;
      println("Resume");
    }
  }
}

// Main User Input Left
void keyReleased() {
  if ((gameOver == false) && (gameWin == false)) {
    if ((keyCode == 10) && (enter == true)) { // 10 = 'ENTER' key
      enter = false;
    } else if ((keyCode == 32) && (space == true)) { // 32 = 'SPACE' key
      space = false;
    }
  }
}
