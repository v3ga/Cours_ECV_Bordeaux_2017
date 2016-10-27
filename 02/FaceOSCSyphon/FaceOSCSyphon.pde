// --------------------------------------------
import codeanticode.syphon.*;
import oscP5.*;
import netP5.*;

// --------------------------------------------
// link with FaceOSC software
FaceOSC faceOSC;

// --------------------------------------------
// for OSC
OscP5 oscP5;

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
    tint(255,100);
//    if (imageVisage != null)
  //    image(imageVisage,0,0,width,height);

    PImage imageVisageCompute = faceOSC.getImageVisageCompute();
    if (imageVisageCompute != null)
    {
  imageVisageCompute.loadPixels();

  float b = 0.0;
  float angle = 0.0;
  float xx = 0.0;
  float yy = 0.0;

  float stepx = width / imageVisageCompute.width;
  float stepy = height / imageVisageCompute.height;
  
  float longueur = 30;

  stroke(255);
  for (int y = 0; y < imageVisageCompute.height; y++) 
  {
    for (int x = 0; x < imageVisageCompute.width; x++) 
    {
      b = 1.0-brightness( imageVisageCompute.get(x,y) ) / 255.0;

      xx = x*stepx;
      yy = y*stepy;
      
      angle = map(b,0.0,1.0,0,TWO_PI);
      // Motif à dessiner
      line( xx+stepx/2,yy+stepy/2,xx+stepx/2+longueur*cos(angle),yy+stepy/2+longueur*sin(angle) );
      
    }  
  }
    
    }

  }
  else
  {
    faceOSC.drawFrameSyphon();
/*    faceOSC.drawFaceFeatures();
    faceOSC.drawFaceBounding();
    faceOSC.draw();
*/  }

}

// --------------------------------------------
void oscEvent(OscMessage m) 
{
  if (faceOSC != null)
    faceOSC.parseOSC(m);
}