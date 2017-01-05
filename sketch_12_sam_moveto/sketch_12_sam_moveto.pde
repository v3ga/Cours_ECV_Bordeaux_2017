import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

PVector A,B,M,u;
float t;
Ani aniAB;

void setup()
{
  size(800,800);
  Ani.init(this);
  createPoints();
  background(0);
  drawPoint(A, color(200,0,0));
  drawPoint(B, color(200,0,0));
  movePen(A,B,200);
}

void draw()
{
  drawPoint(M,color(200,200,0));
}

void drawPoint(PVector P, color c)
{
  noStroke();
  fill(c);
  ellipse(P.x,P.y,5,5);
}

// d = v * t
void movePen(PVector A, PVector B, float speed)
{
  t = 0;
  float d = dist(A.x,A.y,B.x,B.y);
  float time = d/speed;
  println("distance = "+d + ", time to go:"+time);
  aniAB = new Ani(this, d/speed, "t", 1.0, Ani.LINEAR, "onStart:onPenStart, onUpdate:onPenUpdate, onEnd:onPenArrived");  
  aniAB.start();
}

void onPenStart()
{
  M.set(A);
}

void onPenUpdate()
{
  M.x = A.x + t*(B.x-A.x);
  M.y = A.y + t*(B.y-A.y);
}


void onPenArrived()
{
  println("arrived ! ");
}

void createPoints()
{
  A = new PVector(random(width), random(height));
  B = new PVector(random(width), random(height));
  M = new PVector();
}