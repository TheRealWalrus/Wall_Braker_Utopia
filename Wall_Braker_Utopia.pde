import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

// TODO:
// Kinematic paddle to be implemented
// collision filtering to be added to aviod collision between two balls
// move related code to a "Game" class

Box2DProcessing box2d;
ArrayList<Boundary> boundaries = new ArrayList<Boundary>();
ArrayList<Ball> balls = new ArrayList<Ball>();
boolean debugMode = true;

void setup() {
  size(640, 480, P2D);
  initializeWorld();
  setupGame();
}

void draw() {
  background(0);
  box2d.step();

  for (int i = balls.size() - 1; i >= 0; i--) {
    Ball ball = balls.get(i);
    
    if (ball.isOffscreen()) {
      balls.remove(ball);
      box2d.destroyBody(ball.body);
    } else {
      ball.display();
    }
  }

  for (Boundary boundary : boundaries) {
    boundary.display();
  }

  Vec2 center = new Vec2(width / 2, height / 2);
  Vec2 ballLoc = new Vec2(mouseX, mouseY);
  stroke(255, 0, 0);
  strokeWeight(5);
  line(center.x, center.y, ballLoc.x, ballLoc.y);
  
  if (debugMode) {
    fill(255);
    text("Number of balls: " + balls.size(), 30, 30);
  }
}

void setupGame() {
  final float boundaryWeight = 10;

  boundaries.add(new Boundary(boundaryWeight / 2, height / 2, boundaryWeight, height));
  boundaries.add(new Boundary(width - boundaryWeight / 2, height / 2, boundaryWeight, height));
  boundaries.add(new Boundary(width / 2, boundaryWeight / 2, width, boundaryWeight));
  //boundaries.add(new Boundary(width / 2, height - boundaryWeight / 2, width, boundaryWeight));
}

void initializeWorld() {
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0, 0);
}

void mouseClicked() {
  Vec2 center = new Vec2(width / 2, height / 2);
  Vec2 ballLoc = new Vec2(mouseX, mouseY);
  //Vec2 test = new Vec2(0, 0);

  Vec2 ballVel = ballLoc.sub(center);
  ballVel.normalize();
  ballVel.mulLocal(50);
  ballVel.y *= -1;

  balls.add(new Ball(ballLoc, ballVel));
}
