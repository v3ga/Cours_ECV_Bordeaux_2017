class FaceOSC
{
  // OSC
  OscP5 oscP5;

  // Face data retrieved from OSC
  Face face;

  PVector posFaceScreen = new PVector();
  PVector dimFaceScreen = new PVector();

  // Syphon
  SyphonClient client;

  // Image from Syphon
  PImage frameSyphon;
  PVector dimFrameSyphon = new PVector(640, 480);

  // Preview
  float scalePreview = 1.0f;
  PVector dimPreview;

  // --------------------------------------------
  // Image of face relative to the bounding box
  PImage imageVisage;
  PImage imageVisageCompute;

  // --------------------------------------------
  FaceOSC(PApplet applet, OscP5 osc)
  {
    this.oscP5 = osc;
    this.face = new Face();
    this.client = new SyphonClient(applet, "FaceOSC");

    this.dimPreview = new PVector(scalePreview*dimFrameSyphon.x, scalePreview*dimFrameSyphon.y);
    dimFaceScreen.y = height;
    dimFaceScreen.x = dimFaceScreen.y / dimFrameSyphon.y * dimFrameSyphon.x;
    posFaceScreen.x = 0.5*(width-dimFaceScreen.x);
    posFaceScreen.y = 0.5*(height-dimFaceScreen.y);
  }

  // --------------------------------------------
  Face getFace()
  {
    return face;
  }

  // --------------------------------------------
  PImage getImageVisage()
  {
    return imageVisage;
  }

  // --------------------------------------------
  PImage getImageVisageCompute()
  {
    return imageVisageCompute;
  }

  // --------------------------------------------
  boolean isFaceFound()
  {
    return (face.found > 0) ? true : false;
  }

  // --------------------------------------------
  void updateFrameSyphon()
  {
    if (client.newFrame()) 
    {
      frameSyphon = client.getImage(frameSyphon, true);
      if (imageVisage == null)
      {
        imageVisage = new PImage(240, 320, frameSyphon.format);
        imageVisageCompute = new PImage(240/4, 320/4, frameSyphon.format);
      }
    }
  }


  // --------------------------------------------------------------
  void update()
  {
    face.updateBounding();
    if (imageVisage == null) return;
    int xSrc = (int) face.boundingPortrait.position.x;
    int ySrc = (int) face.boundingPortrait.position.y;
    int wSrc = (int) face.boundingPortrait.dimension.x;
    int hSrc = (int) face.boundingPortrait.dimension.y;
    imageVisage.copy(frameSyphon, 
      xSrc, ySrc, wSrc, hSrc, 
      0, 0, imageVisage.width, imageVisage.height);

    imageVisageCompute.copy(frameSyphon, 
      xSrc, ySrc, wSrc, hSrc, 
      0, 0, imageVisageCompute.width, imageVisageCompute.height);
  }

  // --------------------------------------------------------------
  void drawFrameSyphon()
  {
    if (frameSyphon !=null)
    {
      image(frameSyphon, posFaceScreen.x, posFaceScreen.y, dimFaceScreen.x, dimFaceScreen.y);
    }
  }

  // --------------------------------------------------------------
  void drawFaceBounding()
  {
    pushMatrix();
    scale(dimFaceScreen.x/dimFrameSyphon.x, dimFaceScreen.y/dimFrameSyphon.y);
    face.boundingPortrait.draw();
    popMatrix();
  }

  // --------------------------------------------------------------
  void drawFaceFeatures()
  {
    if (face.found>0)
    {
      pushMatrix();
      translate(posFaceScreen.x, posFaceScreen.y);
      scale(dimFaceScreen.x/dimFrameSyphon.x, dimFaceScreen.y/dimFrameSyphon.y);
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

  void draw()
  {
    if (imageVisage !=null)
      image(imageVisage, 0, 0);

    /*  if(face.found > 0) {
     stroke(255, 100, 100);
     strokeWeight(4);
     translate(face.posePosition.x, face.posePosition.y);
     scale(face.poseScale);
     noFill();
     ellipse(-20, face.eyeLeft * -9, 20, 7);
     ellipse(20, face.eyeRight * -9, 20, 7);
     ellipse(0, 20, face.mouthWidth* 3, face.mouthHeight * 3);
     ellipse(-5, face.nostrils * -1, 7, 3);
     ellipse(5, face.nostrils * -1, 7, 3);
     rectMode(CENTER);
     fill(0);
     rect(-20, face.eyebrowLeft * -5, 25, 5);
     rect(20, face.eyebrowRight * -5, 25, 5);
     
     }
     */
  }

  // --------------------------------------------
  PVector getFrameScale()
  {
    return new PVector(dimFaceScreen.x/dimFrameSyphon.x, dimFaceScreen.y/dimFrameSyphon.y);
  }

  // --------------------------------------------
  void parseOSC(OscMessage m)
  {
    face.parseOSC(m);
  }
}