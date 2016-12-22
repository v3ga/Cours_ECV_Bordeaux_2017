// --------------------------------------------
import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;
import blobDetection.*;

// --------------------------------------------
PImage visage;
PImage visage2;
PImage visageVisited;
PGraphics offscreen;
Agent agent, agent2;
Timer timer;

// --------------------------------------------
void setup()
{
  size(670,970,P3D);
//  size(900, 1260,P3D);
  Ani.init(this);

  visage = loadImage("pic.png");
//    visage = loadImage("test2.jpg");
  visage.filter(GRAY);
  visage.filter(INVERT);
  visage.filter(THRESHOLD, 0.5);

  visage2 = visage.copy();

  visageVisited = visage.copy();

  agent = new Agent(visage);
  agent.compute();
  agent.begin(10);


  agent2 = new Agent(visage);
  agent2.compute();
  agent2.begin(5);
  
  timer = new Timer();
}

// --------------------------------------------
void draw()
{
  stroke(200, 0, 0);
  background(255);
  float dt = timer.dt();
/*  tint(255, 150);
  //image(visage,0,0,width,height);
*/

  stroke(0, 0, 0, 100);
  agent.update(dt);
  agent.draw();


  stroke(255, 0, 0, 100);
  agent2.update(dt);
  agent2.draw();

//  translate(0,0,-100);
/*
stroke(0,30);
  agentTraveller2.update(dt);
  agentTraveller2.draw();
*/

  /*  float scale = 2.5;
   float w = scale * float(agent.imgVisited.width);
   float h = scale * float(agent.imgVisited.height);
   image(agent.imgVisited,0,height-h,w,h);
   image(agent.img,w,height-h,w,h);
   */
}