// --------------------------------------------
import codeanticode.syphon.*;
import oscP5.*;
import netP5.*;

// --------------------------------------------
// Options
boolean bDrawMotifs = false;

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
void settings () 
{
  size(600, 800, P3D);
  PJOGL.profile = 1;
}

// --------------------------------------------
void setup() 
{
  // osc
  oscP5 = new OscP5(this, 8338);

  // Face osc
  faceOSC = new FaceOSC(this, oscP5);
  
  // Scenes
  //sceneManager.add( new SceneEmily() );
}

// --------------------------------------------
public void draw() 
{    
  // Data update
  faceOSC.updateFrameSyphon();
  faceOSC.update();

  // Drawing
  if (faceOSC.isFaceFound())
  {
    background(0);
    
    PImage imageVisage = faceOSC.getImageVisage();
    
    Scene scene = sceneManager.get("SceneEmily");
    
    if (bDrawMotifs)
    {
      tint(255, 100);
      if (imageVisage != null)
        image(imageVisage, 0, 0, width, height);

      if (scene !=null)
      {
        scene.update();
        scene.draw();
      }
  }
    else
    {
/*      tint(255, 255);
      if (imageVisage != null)
        image(imageVisage, 0, 0, width, height);
*/
      faceOSC.drawFrameSyphon();
      faceOSC.drawFaceBounding();
    }
    
    
  } else
  {
    faceOSC.drawFrameSyphon();
    /*    faceOSC.drawFaceFeatures();
     faceOSC.drawFaceBounding();
     faceOSC.draw();
     */
  }
}

// --------------------------------------------
void oscEvent(OscMessage m) 
{
  if (faceOSC != null)
    faceOSC.parseOSC(m);
}


// --------------------------------------------
void keyPressed()
{
  if (key == 'm')
    bDrawMotifs = !bDrawMotifs;
}