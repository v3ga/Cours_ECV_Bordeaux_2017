// --------------------------------------------
import codeanticode.syphon.*;
import controlP5.*;
import oscP5.*;
import netP5.*;


// --------------------------------------------
// Variables
PApplet applet;

// --------------------------------------------
// link with FaceOSC software
FaceOSC faceOSC;

// --------------------------------------------
// for OSC
OscP5 oscP5;

// --------------------------------------------
// Scenes
SceneManager sceneManager = new SceneManager();

// --------------------------------------------
// Debug
boolean __DEBUG__ = false;


// --------------------------------------------
void settings () 
{
  size(900, 1200, P3D);
  PJOGL.profile = 1;
}

// --------------------------------------------
void setup() 
{
  // applet
  applet = this;
  
  // osc
  oscP5 = new OscP5(this, 8338);

  // Face osc
  faceOSC = new FaceOSC(this, oscP5);

  // Scenes
  sceneManager.add( new SceneEmily() );
  sceneManager.add( new SceneGrid("Grid") );
  sceneManager.add( new SceneMycelium() );
  sceneManager.add( new SceneTypo() );

  sceneManager.setup();
  sceneManager.select("Typo");
}

// --------------------------------------------
public void draw() 
{    
  // Face update
  faceOSC.updateFrameSyphon();
  faceOSC.update();

  if (__DEBUG__)
  {
    background(0);

    faceOSC.drawFrameSyphonZoom();    
    faceOSC.drawImageGrid();    

    //      faceOSC.drawFaceBounding();
    faceOSC.drawFaceImages();
  } else
  {
    // Scene
    Scene sceneCurrent = sceneManager.getCurrent();
    if (sceneCurrent != null)
    {
      sceneCurrent.update();
      sceneCurrent.draw();
    }
  }

  fill(255);
  text(faceOSC.getStateAsString() + ", zoom="+faceOSC.zoom, 10, 20);
}

// --------------------------------------------
void oscEvent(OscMessage m) 
{
  if (faceOSC != null)
    faceOSC.parseOSC(m);
}

// --------------------------------------------
void mouseMoved()
{
  Scene sceneCurrent = sceneManager.getCurrent();
  if (sceneCurrent !=null)
    sceneCurrent.mouseMoved();
}

// --------------------------------------------
void mousePressed()
{
  Scene sceneCurrent = sceneManager.getCurrent();
  if (sceneCurrent !=null)
    sceneCurrent.mousePressed();
}

// --------------------------------------------
void keyPressed()
{
}