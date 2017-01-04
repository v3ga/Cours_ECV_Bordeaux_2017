import processing.pdf.*;

// --------------------------------------------
import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

// --------------------------------------------
PImage visage;
PImage visage2;
PImage visageVisited;
PGraphics offscreen;
Agent agent, agent2;
Timer timer;
boolean bExportPDF = false;

// --------------------------------------------
// L'image doit avoir une taille qui rentre dans un carré de 80 x 80px
String picName = "test2.jpg"; 
//String picName = "pic.png"; 


// --------------------------------------------
void settings()
{
  visage = loadImage(picName);
  size(visage.width*10, visage.height*10);
}

// --------------------------------------------
void setup()
{
  Ani.init(this);

  //  visage = loadImage("test2.jpg");
  visage.filter(GRAY);
  visage.filter(INVERT);
  visage.filter(THRESHOLD, 0.5);

  visage2 = visage.copy();
  visageVisited = visage.copy();

  agent = new Agent(visage);
  agent.compute();
  agent.begin(1);

/*
  agent2 = new Agent(visage);
  agent2.compute();
  agent2.begin(5);
*/
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

  if (bExportPDF)
  {
    beginRecord(PDF, "export.pdf");
  }

  stroke(0, 255);
  agent.update(dt);
  agent.draw();

/*
  stroke(255, 0, 0, 100);
  agent2.update(dt);
  agent2.draw();
*/

  if (bExportPDF)
  {
    endRecord();
    bExportPDF = false;
  }

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

// --------------------------------------------
void keyPressed()
{
  if (key == 'e')
    bExportPDF = true;
}