// Julien Gachadoat (v3ga.net) @ l'École des Beaux-Arts de Versailles (March 2014)
//
// A template for FaceOSC in Processing based on : 
// 
// — Dan Wilcox FaceOSCGraphReceiver sketch
// https://github.com/CreativeInquiry/FaceOSC-Templates/tree/master/processing/FaceOSCReceiverGrapher
//
// — Daniel Shiffman FaceOSCTriangleMesh
// https://github.com/shiffman/Face-It/tree/master/FaceOSC/FaceOSCTriangleMesh
//
// Press ' ' to swicth from face model (lines or mesh)

// Original statement of Dan Wilcox : 
//
// a template for receiving face tracking osc messages from
// Kyle McDonald's FaceOSC https://github.com/kylemcdonald/ofxFaceTracker
//
// This example is similar to FaceOSCReceiverClass and utilizes Syphon to grab
// the camera stream from FaceOSC+Syphon. Syphon is only available for Mac OSX.
//
// You will need Processing 2.0, a Mac, and
// - FaceOSC+Syphon: https://github.com/kylemcdonald/ofxFaceTracker/downloads
// - Syphon for Processing: http://code.google.com/p/syphon-implementations
//
// 2013 Dan Wilcox danomatika.com
// for the IACD Spring 2013 class at the CMU School of Art
//
// adapted from from the Syphon ReceiveFrames example
//

// --------------------------------------------------------------
import codeanticode.syphon.*;
import oscP5.*;


// --------------------------------------------------------------
// for OSC
OscP5 oscP5;

// --------------------------------------------------------------
// FaceOSC
PVector faceOscDim = new PVector(640, 480);
float faceOscPreviewScale = 1.0f;
PVector faceOscPreviewDim;
PVector faceScreenPos = new PVector();
PVector faceScreenDim = new PVector();
Face face;
boolean faceDrawMesh = false;

// --------------------------------------------------------------
// for Syphon
PGraphics canvas;
//PImage imgSyphon;
SyphonClient client;

// --------------------------------------------------------------
ArrayList<Scene> scenes;
Scene sceneCurrent;

// --------------------------------------------------------------
// Debug
ArrayList<Graph> graphs;
int totalGraphs;
boolean __PREVIEW__ = true;
boolean __GRAPHS__ = true;

// --------------------------------------------------------------
void setup() 
{
  size(displayWidth, displayHeight, P2D);

  println("Available Syphon servers:");
  println(SyphonClient.listServers());

  // create syhpon client to receive frames from FaceOSC
  client = new SyphonClient(this, "FaceOSC");

  // stat listening on OSC
  oscP5 = new OscP5(this, 8338);

  // FaceOSC
  face = new Face();
  faceOscPreviewDim = new PVector(faceOscPreviewScale*faceOscDim.x, faceOscPreviewScale*faceOscDim.y);
  faceScreenDim.y = height;
  faceScreenDim.x = faceScreenDim.y / faceOscDim.y * faceOscDim.x;
  faceScreenPos.x = 0.5*(width-faceScreenDim.x);
  faceScreenPos.y = 0.5*(height-faceScreenDim.y);

  // Graphs
  resetGraphs();

  // Scenes
  scenes = new ArrayList<Scene>();
  //  scenes.add( new Scene("default") );
  scenes.add( new SceneParticles() );

  //  setupScenes();
  sceneCurrent = scenes.get(0);
  sceneCurrent.setup();
}

// --------------------------------------------------------------
void draw() 
{    
  updateSyphon();
  updateGraphs();

  if (sceneCurrent!=null)
    sceneCurrent.draw();

  drawPreview();
  drawGraphs();
}

// --------------------------------------------------------------
void drawBackground()
{
  background(0);
}

// --------------------------------------------------------------
void drawFaceImage()
{
//  println(canvas);
  if (canvas !=null)
  {
    image(canvas, faceScreenPos.x, faceScreenPos.y, faceScreenDim.x, faceScreenDim.y);
  }
}

// --------------------------------------------------------------
PVector transformToScreen(float x, float y)
{
  PVector gs = getGlobalScale();
  return new PVector(faceScreenPos.x+gs.x*x, faceScreenPos.y+gs.y*y);
}

// --------------------------------------------------------------
PVector transformToScreen(PVector v_)
{
  return transformToScreen(v_.x, v_.y);
}

// --------------------------------------------------------------
PVector getGlobalScale()
{
  return new PVector(faceScreenDim.x/faceOscDim.x, faceScreenDim.y/faceOscDim.y);
}

// --------------------------------------------------------------
void drawFaceFeatures()
{
  if (face.found>0)
  {
    pushMatrix();
    translate(faceScreenPos.x, faceScreenPos.y);
    scale(faceScreenDim.x/faceOscDim.x, faceScreenDim.y/faceOscDim.y);
    face.drawFeature(face.faceOutline);
    face.drawFeature(face.leftEyebrow);
    face.drawFeature(face.rightEyebrow);
    face.drawFeature(face.nosePart1);   
    face.drawFeature(face.nosePart2);           
    face.drawFeature(face.leftEye);     
    face.drawFeature(face.rightEye);    
    face.drawFeature(face.mouthPart1);  
    face.drawFeature(face.mouthPart2);  
    face.drawFeature(face.mouthPart3);
    popMatrix();
  }
}

// --------------------------------------------------------------
void drawPreview()
{
  if (!__PREVIEW__) return;

  if (canvas !=null)
  {
    image(canvas, 0, 0, faceOscPreviewDim.x, faceOscPreviewDim.y);    
    if (face.found>0)
    {
      if (faceDrawMesh)
      {
        pushMatrix();
        scale(faceOscPreviewDim.x/faceOscDim.x, faceOscPreviewDim.y/faceOscDim.y);
        face.drawMesh();
        popMatrix();
      }
      else
      {
        pushMatrix();
        scale(faceOscPreviewDim.x/faceOscDim.x, faceOscPreviewDim.y/faceOscDim.y);
        face.drawFeature(face.faceOutline);
        face.drawFeature(face.leftEyebrow);
        face.drawFeature(face.rightEyebrow);
        face.drawFeature(face.nosePart1);   
        face.drawFeature(face.nosePart2);           
        face.drawFeature(face.leftEye);     
        face.drawFeature(face.rightEye);    
        face.drawFeature(face.mouthPart1);  
        face.drawFeature(face.mouthPart2);  
        face.drawFeature(face.mouthPart3);

        popMatrix();
      }
    }
  }
}

// --------------------------------------------------------------
void setupScenes()
{
  for (Scene scene : scenes)
    scene.setup();
}

// --------------------------------------------------------------
void drawGraphs()
{
  if (!__GRAPHS__) return;

  pushStyle();
  fill(255);
  stroke(255);
  float h = float(height)-faceOscPreviewDim.y;
  pushMatrix();
  translate(0, faceOscPreviewDim.y);
  for (int i = 0; i < totalGraphs; i++) 
  {
    graphs.get(i).draw((int)faceOscPreviewDim.x, (int)h / totalGraphs);
    translate(0, h / totalGraphs);
  }
  popMatrix();
  popStyle();
}


// --------------------------------------------------------------
void resetGraphs()
{
  graphs = new ArrayList<Graph>();
  graphs.add(new Graph("poseScale"));
  graphs.add(new Graph("mouthWidth"));
  graphs.add(new Graph("mouthHeight"));
  graphs.add(new Graph("eyeLeft/Right"));
  graphs.add(new Graph("eyebrowLeft/Right"));
  graphs.add(new Graph("jaw"));
  graphs.add(new Graph("nostrils"));
  graphs.add(new Graph("posePosition.x"));
  graphs.add(new Graph("posePosition.y"));
  graphs.add(new Graph("poseOrientation.x"));
  graphs.add(new Graph("poseOrientation.y"));
  graphs.add(new Graph("poseOrientation.z"));

  totalGraphs = graphs.size();
}

// --------------------------------------------------------------
void updateGraphs()
{
  if (!__GRAPHS__) return;

  graphs.get(0).add(face.poseScale);
  graphs.get(1).add(face.mouthWidth);
  graphs.get(2).add(face.mouthHeight);
  graphs.get(3).add(face.eyeLeft + face.eyeRight);
  graphs.get(4).add(face.eyebrowLeft + face.eyebrowRight);
  graphs.get(5).add(face.jaw);
  graphs.get(6).add(face.nostrils);
  graphs.get(7).add(face.posePosition.x);
  graphs.get(8).add(face.posePosition.y);
  graphs.get(9).add(face.poseOrientation.x);
  graphs.get(10).add(face.poseOrientation.y);
  graphs.get(11).add(face.poseOrientation.z);
}


// --------------------------------------------------------------
void updateSyphon()
{
  if (client.newFrame()) 
  {
    canvas = client.getGraphics(canvas);
  }
}

// --------------------------------------------------------------
void oscEvent(OscMessage m) {
  face.parseOSC(m);
}

// --------------------------------------------------------------
void keyPressed()
{
  if (key == ' ')
    faceDrawMesh = !faceDrawMesh;
}