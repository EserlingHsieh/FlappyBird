// Bird variables
int birdX = 50; // Starting X position of the bird
int birdY; // The vertical position of the bird
int birdVelocity; // The current vertical velocity of the bird
int gravity = 1; // The force pulling the bird downward
int lift = -15; // The upward force applied when the bird jumps

// Score and game state variables
int score = 0; // The player's score, increases "when passing pipes"
boolean gameOver;

// Pipe variables
int pipeWidth = 80; // The width of each pipe
int pipeMinHeight = 50; // The shortest possible height for the upper pipe
int pipeGap = 300; // The vertical gap between the upper and lower pipes
int pipeSpeed = 3; // The speed at which pipes move leftward
int pipeDistance = 200; // The horizontal distance between each pipe
int pipeTotal = 20; // The total number of pipes generated

// Arrays for pipe positions
int[] pipeX = new int[pipeTotal]; // The horizontal positions of the pipes
int[] pipeY = new int[pipeTotal]; // The heights of the upper pipes

// For testing purposes (turning pipes red instead of gameover)
boolean TESTING = true; // Set to false to play the game normally
boolean[] pipeCollided = new boolean[pipeTotal]; // Tracks whether each pipe has been collided with by the bird


// For endless mode
// int poolSize = 3;
// int[] poolX = new int[poolSize];
// int[] poolY = new int[poolSize];
// boolean[] poolCollided = new boolean[poolSize];

void setup() {
    size(400, 600);
    resetGame();
}

void draw() {
    background(135, 206, 235);
    
    if (!gameOver) {
        // Bird
        /* Practice: Draw bird and add gravity to it */
        birdVelocity += gravity;
        birdY += birdVelocity;
        fill(255, 255, 0);
        ellipse(birdX, birdY, 32, 32);
        /* --------------------------------------------- */
        
        // Pipes
        drawPipes();
        // drawPipesEndless();
        
        /* Practice: Check if bird hits the ground or ceiling */
        if (birdY > height || birdY < 0) {
            gameOver = true;
        }
        /* --------------------------------------------- */
        
        // Display score
        fill(0);
        textSize(32);
        text("Score: " + score, 10, 30);
        
    } else {
        /* Practice: Display score and game over message */
        fill(0);
        textSize(32);
        text("Game Over", width / 2 - 80, height / 2);
        text("Score: " + score, width / 2 - 60, height / 2 + 40);
        text("Press 'r' to restart", width / 2 - 120, height / 2 + 80);
        /* --------------------------------------------- */
    }
}

void drawPipes() {
    /* Practice: Use loop to move pipes and check collision with bird */
    for (int i = 0; i < pipeX.length; i++) {
        pipeX[i] -= pipeSpeed;
        if (pipeX[i] < -pipeWidth) { // Pipe is off screen
            // Check if this is the last pipe, if so, game over
            if (i == pipeX.length - 1) {
                gameOver = true;
            }
            continue; // Skip to next pipe
        }
        else if (pipeX[i] + pipeSpeed > birdX && pipeX[i] <= birdX) {
            // Bird passed the pipe
            score++;
        }
        else if (pipeX[i] > width) { // Pipe is not yet in screen, skip to next pipe
            continue;
        }
        
        // Check collision
        if (birdX + 16 > pipeX[i] && birdX - 16 < pipeX[i] + pipeWidth) {
            if (birdY - 16 < pipeY[i] - pipeGap / 2 || birdY + 16 > pipeY[i] + pipeGap / 2) {
                if (TESTING) {
                    pipeCollided[i] = true;
                } else {
                    gameOver = true;
                }
            }
        }

        drawPipe(pipeX[i], pipeY[i], pipeWidth, pipeGap, pipeCollided[i]);
    }
    /* --------------------------------------------- */
}

void drawPipesEndless() {
    /* Challenge: Pool of pipes */
    for (int i = 0; i < pipeX.length; i++) {
        pipeX[i] -= pipeSpeed;
        if (pipeX[i] < -pipeWidth) { // Pipe is off screen
            // Rearrange pipe to display at the end
            if (i == 0) {
                pipeX[i] = pipeX[pipeX.length - 1] + pipeDistance - pipeSpeed;
            }
            else {
                pipeX[i] = pipeX[i - 1] + pipeDistance;
            }
            pipeY[i] = int(random(pipeMinHeight + pipeGap / 2, height - pipeMinHeight - pipeGap / 2));
            pipeCollided[i] = false;
        }
        else if (pipeX[i] + pipeSpeed > birdX && pipeX[i] <= birdX) {
            // Bird passed the pipe
            score++;
        }
        else if (pipeX[i] > width) { // Pipe is not yet in screen, skip to next pipe
            continue;
        }
        
        // Check collision
        if (birdX + 16 > pipeX[i] && birdX - 16 < pipeX[i] + pipeWidth) {
            if (birdY - 16 < pipeY[i] - pipeGap / 2 || birdY + 16 > pipeY[i] + pipeGap / 2) {
                if (TESTING) {
                    pipeCollided[i] = true;
                } else {
                    gameOver = true;
                }
            }
        }

        drawPipe(pipeX[i], pipeY[i], pipeWidth, pipeGap, pipeCollided[i]);
    }
    // Gradually increase speed
    if (frameCount % 300 == 0) {
        pipeSpeed++;
    }
    /* --------------------------------------------- */
}

void drawPipe(int x, int y, int width, int gap, boolean collided) {
    if (collided) {
        fill(255, 0, 0);
    } else {
        fill(34, 139, 34);
    }
    rect(x, 0, width, y - gap / 2);
    rect(x, y + gap / 2, pipeWidth, height - y - gap / 2);
    // rect(pipeX[i], 0, pipeWidth, pipeY[i] - pipeGap);
    // rect(pipeX[i], pipeY[i], pipeWidth, height - pipeY[i]);
}

void keyPressed() {
    /* Practice: Add lift to bird when space is pressed */
    if (key == ' ') {
        birdVelocity = lift;
    }
    /* --------------------------------------------- */
    /* Practice: Reset game when game over and 'r' is pressed */
    if (gameOver && key == 'r') {
        resetGame();
    }
    /* --------------------------------------------- */
}



void resetGame() {
    birdY = height / 2;
    birdVelocity = 0;
    /* Practice: Setup pipe positions using for loop */
    for (int i = 0; i < pipeX.length; i++) {
        pipeX[i] = width + i * pipeDistance;
        pipeY[i] = int(random(pipeMinHeight + pipeGap / 2, height - pipeMinHeight - pipeGap / 2));
        pipeCollided[i] = false;
    }
    score = 0;
    gameOver = false;
    /* --------------------------------------------- */
}
