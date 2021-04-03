//Character Control Module

//Main config
int sizeX = 750;
int sizeY = 750;
boolean gameOver = false;
int countDown = 5;

//User Info
char currentControl;
int value = 0;
int userPoints = 0;
int defaultMove = 3;
boolean debounce = false;

//Character Config
PShape character;
int charSizeX = 40;
int charSizeY = 40;
int charPosX = sizeX/2;
int charPosY = sizeY/2;

//Asteroid Config
PShape asteroid;
int asteroidSizeX = 20;
int asteroidSizeY = 20;
int asteroidPosX = 0;
int asteroidPosY = -50;
int r = 255;
int g = 255;
int b = 255;


void drawCharacter() {
  //Characterstics
  character = createShape(RECT,-charSizeX/2,-charSizeY/2,charSizeX,charSizeY);
  character.setFill(color(200,200,255));
  shape(character, charPosX,charPosY);
}

void drawAsteroid() {
  asteroid = createShape(ELLIPSE,-asteroidSizeX/2,-asteroidSizeY/2,asteroidSizeX,asteroidSizeY);
  asteroid.setFill(color(r,g,b));
  shape(asteroid, asteroidPosX,asteroidPosY);
}

void moveUp() {
  //Character Movement Up
  while ((currentControl == 'w') && (charPosY >= 0 + charSizeY/2+10)) {
    charPosY = charPosY - defaultMove;
    delay(10);
  }
}

void moveDown() {
  //Character Movement Down
  while ((currentControl == 's') && (charPosY <= sizeY - charSizeY/2-10)) {
    charPosY = charPosY + defaultMove;
    delay(10);
  }
}

void moveLeft() {
  //Character Movement Left
  while ((currentControl == 'a') && (charPosX >= 0 + charSizeX/2+10)) {
    charPosX = charPosX - defaultMove;
    delay(10);
  }
}

void moveRight() {
  //Character Movement Right
  while ((currentControl == 'd') && (charPosX <= sizeX - charSizeX/2-10)) {
    charPosX = charPosX + defaultMove;
    delay(10);
  }
}

void resetPos() {
  r = int(random(10,255));
  g = int(random(10,255));
  b = int(random(10,255));
  asteroidPosY = -50;
  asteroidPosX = int(random(40, sizeX-40));
}

void asteroidThread() {
  while (gameOver == false) {
    asteroidPosY = asteroidPosY + 1;
    delay(4);
    if (asteroidPosY >= sizeY+50) {
      gameRefresh();
    }
  }
}

void gameRefresh() {
  gameOver = true;
  resetPos();
  
  for (int i = 0; i < 5; i += 1) {
    delay(1000);
    countDown = countDown - 1;
  }
  charPosX = sizeX/2;
  charPosY = sizeY/2;
  gameOver = false;
  currentControl = ' ';
  userPoints = 0;
  countDown = 5;
  thread("collisionCheck");
}

void collisionCheck() {
  while (gameOver == false) {
    delay(1);
    if (dist(charPosX, charPosY, asteroidPosX, asteroidPosY) <= 40) {
      resetPos();
      userPoints = userPoints + 1;
    }
  }
}

void setup() {
  //Main setup
  size(750,750); //Defaulted to the SizeX/Y values
  asteroidPosX = int(random(40, sizeX-40));
  thread("asteroidThread");
  thread("collisionCheck");
}

void draw() {
   //Actively drawing
  background(userPoints*9,userPoints*6,userPoints*3); //Clears previous object
  if (gameOver == false) {
    drawAsteroid(); //Draws asteroid
    drawCharacter(); //Draws character
    
    textSize(32);
    text("Points: " + str(userPoints), 25, 50); 
    fill(100, 102, 254);
    
    textSize(32);
    text("Don't let them fall! [W,A,S,D]", 25, sizeY-25); 
    fill(100, 102, 254);
  } else {
    textSize(32);
    text("Game Over, Score: " + str(userPoints), 25, 50); 
    fill(100, 102, 254);
    
    textSize(32);
    text("Restarting: " + str(countDown), 25, 100); 
    fill(100, 102, 254);
  }
  
}

void keyPressed() {
  //Input check
  if ((currentControl != 'w') && ((key == 'w') || (keyCode == 38))) {
    currentControl = 'w';
    thread("moveUp");
  } else if ((currentControl != 'a') && ((key == 'a') || (keyCode == 37))) {
    currentControl = 'a';
    thread("moveLeft");
  } else if ((currentControl != 's') && ((key == 's') || (keyCode == 40))) {
    currentControl = 's';
    thread("moveDown");
  } else if ((currentControl != 'd') && ((key == 'd') || (keyCode == 39))) {
    currentControl = 'd';
    thread("moveRight");
  }
}
