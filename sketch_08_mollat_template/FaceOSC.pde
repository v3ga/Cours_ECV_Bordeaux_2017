class FaceOSC
{
  // Id of the face (unique id incremented from a file)
  int id;  

  // OSC
  OscP5 oscP5;

  // Face data retrieved from OSC
  Face face;

  // Face data retrieved from OSC
  int state, statePrevious;
  float stateTime = 0.0f;

  static final int STATE_REST = 0;
  static final int STATE_ZOOMING = 1;
  static final int STATE_ZOOMED = 2;

  // Position + Dimension of syphon image on window / screen space
  PVector posFaceScreen = new PVector();
  PVector dimFaceScreen = new PVector();

  // when zoomed
  PVector posFaceScreenZoom = new PVector();
  PVector dimFaceScreenZoom = new PVector();


  // Position of bounding box portrait on screen (no zoom)
  PVector posBoundingPortraitScreen = new PVector();
  PVector dimBoundingPortraitScreen = new PVector();

  PVector posBoundingPortraitTightScreen = new PVector();
  PVector dimBoundingPortraitTightScreen = new PVector();

  PVector posBoundingPortraitScreenZoom = new PVector();
  PVector dimBoundingPortraitScreenZoom = new PVector();

  // Mesh points relative to posBoundingPortraitScreenZoom coordinates 
  PVector[] meshPointsPortraitZoom;
  Triangle[] trianglesPortraitZoom;

  // Syphon
  SyphonClient client;

  // Image from Syphon
  PImage frameSyphon;
  PVector dimFrameSyphon = new PVector(640, 480);

  // Preview
  float scalePreview = 1.0f;
  PVector dimPreview = new PVector();

  // --------------------------------------------
  // Image of face relative to the bounding box
  PImage imageVisage;
  PImage imageVisageCompute; // resized image
  boolean bImageVisageComputeFilter = true;

  int imageVisageWidth = 320;
  int imageVisageHeight = int(320.0 * screenRatio);
  int imageVisageComputeWidth = 320/6;
  int imageVisageComputeHeight = 320/6;
  boolean bNewImageVisage = true;

  // Mask
  FaceImageMask imageVisageMask;

  // Zoom
  float zoom = 1.0f;
  float zoomTarget = 1.0f;
  float zoomMax = 1.0f;
  float zoomSpeed = 0.1f;
  boolean bZoom = false;

  // --------------------------------------------
  FaceOSC(PApplet applet, OscP5 osc)
  {
    this.oscP5 = osc;
    this.face = new Face();
    this.client = new SyphonClient(applet, "FaceOSC");

    meshPointsPortraitZoom = new PVector[this.face.meshPoints.length];
    for (int i=0; i<meshPointsPortraitZoom.length; i++)
      meshPointsPortraitZoom[i] = new PVector();
    trianglesPortraitZoom = face.createMesh(meshPointsPortraitZoom);

    setImageVisageWidth(240);
    setImageVisageComputeWidth(240/4);

    state = STATE_REST;
  }

  // --------------------------------------------
  void setup()
  {
    this.id = 0;
    loadId();
  }

  // --------------------------------------------
  int getId() {
    return id;
  }
  // --------------------------------------------
  void loadId()
  {
    try
    {
      JSONObject json = loadJSONObject("data/faceId.json");
      if (json != null)
      {
        this.id = json.getInt("id");
      }
    } catch (Exception e){}
  }

  // --------------------------------------------
  void saveId()
  {
    JSONObject json = new JSONObject();
    json.setInt("id", this.id);
    saveJSONObject(json, "data/faceId.json");
  }

  // --------------------------------------------
  void incrementId()
  {
    this.id ++;
    saveId();
  }

  // --------------------------------------------
  void setImageVisageComputeFilter(boolean is)
  {
    this.bImageVisageComputeFilter = is;
  }

  // --------------------------------------------
  void setImageVisageWidth(int w)
  {
    if ( (imageVisage == null) || (imageVisage.width != w))
    {
      this.imageVisageWidth = w;
      this.imageVisageHeight = int((float)imageVisageWidth / screenRatio);
      this.bNewImageVisage = true;
    }
  }

  // --------------------------------------------
  void setImageVisageComputeWidth(int w)
  {
    if ( (imageVisageCompute == null) || (imageVisageCompute.width != w))
    {
      this.imageVisageComputeWidth = w;
      this.imageVisageComputeHeight = int((float)imageVisageComputeWidth / screenRatio);
      this.bNewImageVisage = true;
    }
  }


  // --------------------------------------------
  Face getFace()
  {
    return face;
  }

  // --------------------------------------------
  boolean isFound()
  {
    return face.isFound();
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
  boolean updateFrameSyphon()
  {
    boolean hasNewFrame = client.newFrame();
    if (hasNewFrame) 
    {
      frameSyphon = client.getImage(frameSyphon, true);
      if (bNewImageVisage)
      {
        imageVisage = new PImage(imageVisageWidth, imageVisageHeight, frameSyphon.format);
        imageVisageCompute = new PImage(imageVisageComputeWidth, imageVisageComputeHeight, frameSyphon.format);
        imageVisageMask = new FaceImageMask(imageVisageWidth, imageVisageHeight);


        bNewImageVisage = false;
      }
    }
    return hasNewFrame;
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
  boolean hasStateChanged()
  {
    return (state != statePrevious);
  }

  // --------------------------------------------------------------
  void update()
  {
    //    println(face.imageWidth+","+face.imageHeight);
    if (face.imageWidth == 0 || face.imageHeight == 0) return;

    // update dimensions
    dimFrameSyphon.set(face.imageWidth, face.imageHeight);
    dimPreview.set(scalePreview*face.imageWidth, scalePreview*face.imageHeight);
    dimFaceScreen.y = height;
    dimFaceScreen.x = dimFaceScreen.y / dimFrameSyphon.y * dimFrameSyphon.x;
    posFaceScreen.x = 0.5*(width-dimFaceScreen.x);
    posFaceScreen.y = 0.5*(height-dimFaceScreen.y);

    // Update boundings in syphon frame space
    face.update();

    // Update boundings in syphon frame space
    face.updateBounding();

    // Compute boundings portrait in window/screen space
    float scaleScreen = getScaleScreen();

    dimBoundingPortraitScreen = scaleFromSyphonToScreen( face.boundingPortrait.dimension );
    posBoundingPortraitScreen = transformPointFromSyphonFrameToScreen(face.boundingPortrait.position);

    dimBoundingPortraitTightScreen = scaleFromSyphonToScreen( face.boundingPortraitTight.dimension );
    posBoundingPortraitTightScreen = transformPointFromSyphonFrameToScreen(face.boundingPortraitTight.position);

    // Zoom
    float f = 0;
    if (bZoom)
    {
      zoomTarget = 1.0f;
      if (face.isFound())
      {
        float wScreen = scaleScreen * face.boundingPortrait.dimension.x;
        zoomTarget = float(width) / wScreen;
        zoomMax = zoomTarget;
      }
      zoom += (zoomTarget-zoom)*zoomSpeed;
      f = map(zoom, 1, zoomMax, 0, 1);
    } else
    {
      zoom = 1.0;
      zoomMax = 1.0;
    }

    posFaceScreenZoom.x = zoom*posFaceScreen.x - f*zoom*posBoundingPortraitScreen.x;
    posFaceScreenZoom.y = zoom*posFaceScreen.y - f*zoom*posBoundingPortraitScreen.y;
    dimFaceScreenZoom.x = zoom * dimFaceScreen.x; 
    dimFaceScreenZoom.y = zoom * dimFaceScreen.y; 

    posBoundingPortraitScreenZoom.x = posFaceScreenZoom.x+zoom*(posBoundingPortraitScreen.x-posFaceScreen.x);
    posBoundingPortraitScreenZoom.y = posFaceScreenZoom.y+zoom*(posBoundingPortraitScreen.y-posFaceScreen.y);

    dimBoundingPortraitScreenZoom.x = zoom * dimBoundingPortraitScreen.x;
    dimBoundingPortraitScreenZoom.y = zoom * dimBoundingPortraitScreen.y;

    for (int i=0; i<meshPointsPortraitZoom.length; i++)
    {
      meshPointsPortraitZoom[i].x = getScaleScreen()*zoom*face.meshPointsBPTight[i].x;
      meshPointsPortraitZoom[i].y = getScaleScreen()*zoom*face.meshPointsBPTight[i].y;
    }


    statePrevious = state;
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

    if (hasStateChanged()) stateTime = 0;

    stateTime += dt;

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

    if (imageVisageMask != null)
      imageVisageMask.update();
    //imageVisage.mask( imageVisageMask.get() );
    if (bImageVisageComputeFilter)
      imageVisageCompute.filter(GRAY);
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
      image(frameSyphon, posFaceScreenZoom.x, posFaceScreenZoom.y, dimFaceScreenZoom.x, dimFaceScreenZoom.y);
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
    if (face.found>0)
    {
      pushStyle();

      pushMatrix();
      translate(posBoundingPortraitScreenZoom.x, posBoundingPortraitScreenZoom.y);
      noFill();
      stroke(0, 200, 0);
      rect(0, 0, dimBoundingPortraitScreenZoom.x, dimBoundingPortraitScreenZoom.y);
      popMatrix();

      pushMatrix();
      translate(posFaceScreenZoom.x+zoom*(posBoundingPortraitTightScreen.x-posFaceScreen.x), posFaceScreenZoom.y+zoom*(posBoundingPortraitTightScreen.y-posFaceScreen.y));
      noStroke();
      fill(200, 0, 0);
      ellipse(0, 0, 5, 5);
      noFill();
      stroke(200, 0, 0);
      rect(0, 0, zoom*dimBoundingPortraitTightScreen.x, zoom*dimBoundingPortraitTightScreen.y);
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
      image(imageVisageMask.get(), imageVisage.width+imageVisageCompute.width, 0);
    }

    //image(imageVisageCompute, 0, 0,width,height);
  }

  // --------------------------------------------
  void drawFaceFeature(int[] featurePointList) 
  {
    stroke(255);
    fill(255);  
    for (int i = 0; i < featurePointList.length; i++) {
      PVector meshVertex = meshPointsPortraitZoom[featurePointList[i]];
      if (i > 0) {
        PVector prevMeshVertex = meshPointsPortraitZoom[featurePointList[i-1]];
        line(meshVertex.x, meshVertex.y, prevMeshVertex.x, prevMeshVertex.y);
      }
      ellipse(meshVertex.x, meshVertex.y, 3, 3);
    }
  }  

  // --------------------------------------------------------------
  void drawFaceFeatures()
  {
    if (face.found>0)
    {
      pushStyle();
      pushMatrix();
      translate(posBoundingPortraitScreenZoom.x, posBoundingPortraitScreenZoom.y);
      drawFaceFeature(face.faceOutline);
      drawFaceFeature(face.leftEyebrow);
      drawFaceFeature(face.rightEyebrow);
      drawFaceFeature(face.nosePart1);   
      drawFaceFeature(face.nosePart2);           
      drawFaceFeature(face.leftEye);     
      drawFaceFeature(face.rightEye);    
      drawFaceFeature(face.mouthPart1);  
      drawFaceFeature(face.mouthPart2);  
      drawFaceFeature(face.mouthPart3);
      popMatrix();
      popStyle();
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
  void drawMeshTrianglesOffscreen(PGraphics g)
  {
    float sw = float(g.width) / dimBoundingPortraitScreenZoom.x;
    float sh = float(g.height) / dimBoundingPortraitScreenZoom.y;

    g.pushMatrix();
    g.scale(sw, sh);
    for (Triangle t : trianglesPortraitZoom) 
    {
      g.beginShape(TRIANGLES);
      g.vertex(t.a.x, t.a.y);
      g.vertex(t.b.x, t.b.y);
      g.vertex(t.c.x, t.c.y);
      g.endShape();
    }      

    g.popMatrix();
  }

  // --------------------------------------------
  float getStateTime()
  {
    return stateTime;
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