class FaceOSC
{
  // OSC
  OscP5 oscP5;

  // Face data retrieved from OSC
  Face face;

  // Face data retrieved from OSC
  int state;

  static final int STATE_REST = 0;
  static final int STATE_ZOOMING = 1;
  static final int STATE_ZOOMED = 2;


  // Position + Dimension of syphon image on window / screen space
  PVector posFaceScreen = new PVector();
  PVector dimFaceScreen = new PVector();

  // Position of bounding box portrait on screen
  PVector posBoundingPortraitScreen = new PVector();
  PVector dimBoundingPortraitScreen = new PVector();

  PVector posBoundingPortraitTightScreen = new PVector();
  PVector dimBoundingPortraitTightScreen = new PVector();

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
  PImage imageVisageCompute; // resized image

  // Zoom
  float zoom = 1.0f;
  float zoomTarget = 1.0f;
  float zoomMax = 1.0f;

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

    state = STATE_REST;
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
        imageVisageCompute = new PImage(240/6, 320/6, frameSyphon.format);
      }
    }
  }

  // --------------------------------------------------------------
  float getScaleScreen()
  {
    return dimFaceScreen.x/dimFrameSyphon.x;
  }

  // --------------------------------------------------------------
  float getZoomLevel()
  {
    return (zoom-1) / (zoomTarget-1);
  }

  // --------------------------------------------------------------
  PVector transformPointFromSyphonFrameToScreen( PVector p )
  {
    float scaleScreen = getScaleScreen();

    return new PVector
      (
      posFaceScreen.x + scaleScreen * p.x, 
      posFaceScreen.y + scaleScreen * p.y
      );
  }

  // --------------------------------------------------------------
  PVector scaleFromSyphonToScreen(PVector p)
  {
    float scaleScreen = getScaleScreen();

    return new PVector
      (
      scaleScreen * p.x, 
      scaleScreen * p.y
      );
  }

  // --------------------------------------------------------------
  void update()
  {
    // Update boundings in syphon frame space
    face.updateBounding();

    // Compute boundings portrait in window/screen space
    float scaleScreen = getScaleScreen();

    dimBoundingPortraitScreen = scaleFromSyphonToScreen( face.boundingPortrait.dimension );
    posBoundingPortraitScreen = transformPointFromSyphonFrameToScreen(face.boundingPortrait.position);

    dimBoundingPortraitTightScreen = scaleFromSyphonToScreen( face.boundingPortraitTight.dimension );
    posBoundingPortraitTightScreen = transformPointFromSyphonFrameToScreen(face.boundingPortraitTight.position);

    // Zoom
    zoomTarget = 1.0f;
    if (face.found > 0)
    {
      float wScreen = scaleScreen * face.boundingPortrait.dimension.x;
      zoomTarget = float(width) / wScreen;
      zoomMax = zoomTarget;
    }

    zoom += (zoomTarget-zoom)*0.1;
    if (zoom <= 1.05)
    {
      state = STATE_REST;
    } else if (zoom > zoomTarget-0.05)
    {
      state = STATE_ZOOMED;
    } else
    {
      state = STATE_ZOOMING;
    }


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
  void drawImageGrid()
  {
    if (faceOSC.state == FaceOSC.STATE_ZOOMED)
    {
      if (imageVisageCompute != null)
        drawGrid( width/imageVisageCompute.width, width/imageVisageCompute.height );
    }
  }

  // --------------------------------------------------------------
  void drawFrameSyphonZoom()
  {
    if (frameSyphon !=null)
    {
      float f = map(zoom, 1, zoomMax, 0, 1);
      float x = zoom*posFaceScreen.x - f*zoom*posBoundingPortraitScreen.x;
      float y = zoom*posFaceScreen.y - f*zoom*posBoundingPortraitScreen.y;

      image(frameSyphon, x, y, zoom*dimFaceScreen.x, zoom*dimFaceScreen.y);
    }
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
    //if (state == STATE_REST)
    {
      pushStyle();

      pushMatrix();
      translate(posBoundingPortraitScreen.x, posBoundingPortraitScreen.y);
      noFill();
      stroke(0, 200, 0);
      rect(0, 0, dimBoundingPortraitScreen.x, dimBoundingPortraitScreen.y);
      popMatrix();

      pushMatrix();
      translate(posBoundingPortraitTightScreen.x, posBoundingPortraitTightScreen.y);
      noStroke();
      fill(200, 0, 0);
      ellipse(0, 0, 5, 5);
      noFill();
      stroke(200, 0, 0);
      rect(0, 0, dimBoundingPortraitTightScreen.x, dimBoundingPortraitTightScreen.y);
      popMatrix();

      popStyle();
    }
  }

  // --------------------------------------------------------------
  void drawFaceImages()
  {
    if (imageVisage != null && imageVisageCompute != null)
    {
      image(imageVisage, 0, 0);    
      image(imageVisageCompute, imageVisage.width, 0);
    }
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
  String getStateAsString()
  {
    String s = "???";
    if (state == STATE_REST) s = "STATE_REST";
    if (state == STATE_ZOOMING) s = "STATE_ZOOMING";
    if (state == STATE_ZOOMED) s = "STATE_ZOOMED";
    return s;
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