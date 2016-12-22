// --------------------------------------------
import codeanticode.syphon.*;
import controlP5.*;
import oscP5.*;
import netP5.*;
import punktiert.math.*;
import punktiert.physics.*;
import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;
import org.processing.wiki.triangulate.*;

// --------------------------------------------
// Variables globales
PApplet applet;
/*int screenWidth = 900;
int screenHeight = 1600;
*/
int screenWidth = 600;
int screenHeight = 800;

float screenRatio = float(screenWidth) / float(screenHeight);

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
// Tools
ToolManager toolManager;
ControlP5 cp5;

// --------------------------------------------
// Timing
Timer timer;
float dt = 0.0;


// --------------------------------------------
// Debug
boolean __DEBUG__ = false;
boolean __DEBUG_IMAGES__ = true;
boolean __DEBUG_BOUNDINGS__ = true;
boolean __DEBUG_FEATURES__ = true;
boolean __DEBUG_INFOS__ = true;

String strDebugInfos = "";

// --------------------------------------------
void settings () 
{
  println("-- settings()");
  println("- screenRatio = "+screenRatio);

  size(screenWidth, screenHeight, P3D);
  PJOGL.profile = 1;
}

// --------------------------------------------
void setup() 
{
  // applet
  applet = this;
  
  // Libs
  Ani.init(this);

  // osc
  oscP5 = new OscP5(this, 8338);

  // Face osc
  faceOSC = new FaceOSC(this, oscP5);
  faceOSC.setup();

  // Scenes
  sceneManager.add( new SceneThibaut("Thibaut_Maxime") );
  sceneManager.add( new SceneLea("Lea_Lea") );
  sceneManager.add( new SceneBenedicte("Benedicte_Alice") );
  sceneManager.add( new SceneEmily("Emily_Anna") );
  sceneManager.add( new SceneAlexis("Alexis_Max") );

  sceneManager.setup();
  sceneManager.select("Alexis_Max");

  // Init controls
  initControls();
  
  // Timing
  timer = new Timer();
}

// --------------------------------------------
public void draw() 
{    
  dt = timer.dt();
  
  // Update stuff
  boolean hasNewFrame = faceOSC.updateFrameSyphon();
  faceOSC.update();
  toolManager.update();

  // Draw
  background(0,0,0);

  // Scene
  Scene sceneCurrent = sceneManager.getCurrent();
  if (sceneCurrent != null)
  {
    if (hasNewFrame)
      sceneCurrent.onNewFrame();
    sceneCurrent.update();
    sceneCurrent.draw();
  }

  // Debug
  if (__DEBUG__)
  {
    if (__DEBUG_IMAGES__)    faceOSC.drawFaceImages();
    if (__DEBUG_BOUNDINGS__) faceOSC.drawFaceBounding();
    if (__DEBUG_FEATURES__)  faceOSC.drawFaceFeatures();
    if (__DEBUG_INFOS__)     drawDebugInfos();
  }

//  hint(DISABLE_DEPTH_TEST);

  // Tools
//  toolManager.draw();

//  faceOSC.drawFrameSyphon();
}

// --------------------------------------------
void drawDebugInfos()
{
   pushStyle();
   pushMatrix();
   translate(4,height-40);
   fill(255,200);
   strDebugInfos = "faceOSC.state="+faceOSC.getStateAsString()+ " / " + "faceOsc.foundFactor = " + nf(faceOSC.face.getFoundFactor(),1,5) + "faceOsc.stateTime="+faceOSC.getStateTime();
   text(strDebugInfos,0,0);
   popMatrix();
   popStyle();
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
  if (key == '1')   sceneManager.select("Thibaut_Maxime");
  else if (key == '2')   sceneManager.select("Lea_Lea");
  else if (key == '3')   sceneManager.select("Benedicte_Alice");
  else if (key == '4')   sceneManager.select("Emily_Anna");
  else
  {
    Scene sceneCurrent = sceneManager.getCurrent();
    if (sceneCurrent !=null)
      sceneCurrent.keyPressed();
  }
}