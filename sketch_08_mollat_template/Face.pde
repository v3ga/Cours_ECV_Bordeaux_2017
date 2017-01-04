// a single tracked face from FaceOSC
class Face 
{
  // --------------------------------------------
  // num faces found
  int found;
  float foundFactor, foundFactorTarget;
  float foundFactorRelax = 0.9;

  // --------------------------------------------
  // image from syphon
  int imageWidth = 0; 
  int imageHeight = 0; 

  // --------------------------------------------
  // pose
  // relative to syphon frame (640,480)
  float poseScale;
  PVector posePosition = new PVector();
  PVector poseOrientation = new PVector();

  // --------------------------------------------
  // gesture
  float mouthHeight, mouthWidth;
  float eyeLeft, eyeRight;
  float eyebrowLeft, eyebrowRight;
  float jaw;
  float nostrils;

  PVector eyeLeftPosition = new PVector();
  PVector eyeRightPosition = new PVector();
  PVector mouthPosition = new PVector();
  PVector nosePosition = new PVector();


  // --------------------------------------------
  // mesh
  PVector[] meshPoints;
  Triangle[] triangles;
  PVector[] meshPoints2;
  Triangle[] triangles2;
  //  NetAddress remote;

  PVector[] meshPointsBPTight; // points in bounding portrait tight

  // --------------------------------------------
  // Bounding 
  // relative to syphon frame (640,480)
  // Bounding of mesh points
  BoundingBox bounding = new BoundingBox();
  // bounding with extra borders
  BoundingBox boundingPortrait = new BoundingBox(); 
  BoundingBox boundingPortraitTight = new BoundingBox();  // with no borders

  BoundingBox boundingPose = new BoundingBox();
  float boundingPortraitBorders = 70.0;

  // width of bounding box to frame
  // can be helpful for filtering
  float ratioToFrameSyphon = 0; 
  float ratioToFrameSyphonThreshold = 0.4f;

  // --------------------------------------------
  int[] faceOutline = { 
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16
  };
  int[] leftEyebrow = {
    17, 18, 19, 20, 21
  }; 
  int[] rightEyebrow = {
    22, 23, 24, 25, 26
  };
  int[] nosePart1 = {
    27, 28, 29, 30
  };
  int[] nosePart2 = {
    31, 32, 33, 34, 35
  };
  int[] leftEye = {
    36, 37, 38, 39, 40, 41, 36
  };
  int[] rightEye = {
    42, 43, 44, 45, 46, 47, 42
  };
  int[] mouthPart1 = { 
    48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 48
  };
  int[] mouthPart2 = {
    60, 65
  };
  int[] mouthPart3 = {
    60, 61, 62, 63, 64, 65
  };


  // --------------------------------------------
  Face()
  {
    initMesh();
    initMesh2();
    oscP5.plug(this, "loadMesh", "/raw");
    oscP5.plug(this, "loadMeshImg", "/raw_img");
  }

  // --------------------------------------------
  float getFoundFactor()
  {
    return foundFactor;
  }

  // --------------------------------------------
  boolean isFound()
  {
    return (foundFactor>=0.2f);
  }

  // --------------------------------------------
  void setRatioToFrameSyphonThreshold(float value)
  {
    this.ratioToFrameSyphonThreshold = value;
  }
  // --------------------------------------------
  void setBoundingPortraitBorders(float b)
  {
    boundingPortraitBorders = b;
  }

  // --------------------------------------------
  void initMesh() 
  {
    // initialize meshPoints array with PVectors
    meshPoints = new PVector[66];
    meshPointsBPTight = new PVector[66];
    for (int i = 0; i < meshPoints.length; i++)
    {
      meshPoints[i] = new PVector();
      meshPointsBPTight[i] = new PVector();
    }

    triangles = new Triangle[108];
    for (int i = 0; i < triangles.length; i++) {
      triangles[i] = new Triangle();
    }

    Table table = loadTable("matches.csv", "header");
    for (TableRow row : table.rows()) 
    {
      int pi = row.getInt("p");
      int ti = row.getInt("t");
      String s = row.getString("abc");

      Triangle t = triangles[ti];
      PVector p = meshPoints[pi];
      if (s.equals("a")) t.a = p;
      if (s.equals("b")) t.b = p;
      if (s.equals("c")) t.c = p;
    }
  }

  // --------------------------------------------
  void initMesh2()
  {
    meshPoints2 = new PVector[66];
    for (int i = 0; i < meshPoints.length; i++) {
      meshPoints2[i] = new PVector();
    }

    triangles2 = new Triangle[108];
    for (int i = 0; i < triangles2.length; i++) {
      triangles2[i] = new Triangle();
    }

    Table table = loadTable("matches.csv", "header");
    for (TableRow row : table.rows()) {
      int pi = row.getInt("p");
      int ti = row.getInt("t");
      String s = row.getString("abc");

      Triangle t = triangles2[ti];
      PVector p = meshPointsBPTight[pi];

      if (s.equals("a")) t.a = p;
      if (s.equals("b")) t.b = p;
      if (s.equals("c")) t.c = p;
    }
  } 

  // --------------------------------------------
  Triangle[] createMesh(PVector[] points)
  {
    Triangle[] triangles = new Triangle[108]; 
    for (int i = 0; i < triangles.length; i++)
      triangles[i] = new Triangle();

    Table table = loadTable("matches.csv", "header");
    for (TableRow row : table.rows()) 
    {
      int pi = row.getInt("p");
      int ti = row.getInt("t");
      String s = row.getString("abc");

      Triangle t = triangles[ti];
      PVector p = points[pi];

      if (s.equals("a")) t.a = p;
      if (s.equals("b")) t.b = p;
      if (s.equals("c")) t.c = p;
    }


    return triangles;
  }

  // --------------------------------------------
  void updateBounding()
  {
    // Bounding if syphon screen
    bounding.compute(meshPoints);
    
    if (imageWidth > 0)
      ratioToFrameSyphon = bounding.dimension.x / float(imageWidth);

    // Bounding in window space
    boundingPortrait = bounding.copy();
    boundingPortraitTight = bounding.copy();

    float wBounding = bounding.dimension.x;
    float hBoundingPortrait = wBounding * (1.0/screenRatio);
    float hDelta = hBoundingPortrait - bounding.dimension.y;

    boundingPortraitTight.dimension.y = hBoundingPortrait;

    boundingPortraitTight.position.y -= hDelta;
    boundingPortraitTight.center.set(boundingPortrait.position.x+0.5*boundingPortrait.dimension.x, boundingPortrait.position.y+0.5*boundingPortrait.dimension.y);

    float borders = boundingPortraitBorders;

    boundingPortrait.dimension.x += borders;
    boundingPortrait.dimension.y = hBoundingPortrait + borders/screenRatio;

    boundingPortrait.position.x -= 0.5*borders;
    boundingPortrait.position.y += -hDelta - 0.5*borders/screenRatio;
    boundingPortrait.center.set(boundingPortrait.position.x+0.5*boundingPortrait.dimension.x, boundingPortrait.position.y+0.5*boundingPortrait.dimension.y);

    boundingPose.dimension.set( boundingPortrait.dimension );
    boundingPose.position.set( posePosition.x - 0.5*boundingPortrait.dimension.x, posePosition.y - 0.5*boundingPortrait.dimension.y);

    //    PVector 
    for (int i=0; i<meshPointsBPTight.length; i++)
    {
      meshPointsBPTight[i].x = meshPoints[i].x - boundingPortrait.position.x;
      meshPointsBPTight[i].y = meshPoints[i].y - boundingPortrait.position.y;
    }
  }

  // --------------------------------------------
  void update()
  {
    if (found>0 && ratioToFrameSyphon >= ratioToFrameSyphonThreshold)
    {
      foundFactor = 1.0f;

/*      float s = poseScale/2.45;

      eyeLeftPosition.set(posePosition.x - s*20, posePosition.y + (s*eyeLeft * -9) );
      eyeRightPosition.set(posePosition.x + s*20, posePosition.y + (s*eyeRight * -9) );
      mouthPosition.set(posePosition.x, posePosition.y + (s*25));
      nosePosition.set(posePosition.x, posePosition.y);
*/
  } else {
      foundFactorTarget = 0.0f;
      // foundFactor += (foundFactorTarget-foundFactor)*0.025f;
      foundFactor = float_relax(foundFactor, 0.0f, dt, foundFactorRelax);
    }
  }


  // --------------------------------------------
  void drawFeature(int[] featurePointList) 
  {
    stroke(255);
    fill(255);  
    for (int i = 0; i < featurePointList.length; i++) {
      PVector meshVertex = meshPoints[featurePointList[i]];
      if (i > 0) {
        PVector prevMeshVertex = meshPoints[featurePointList[i-1]];
        line(meshVertex.x, meshVertex.y, prevMeshVertex.x, prevMeshVertex.y);
      }
      ellipse(meshVertex.x, meshVertex.y, 3, 3);
    }
  }  

  // --------------------------------------------
  // parse an OSC message from FaceOSC
  // returns true if a message was handled
  //
  // https://github.com/kylemcdonald/ofxFaceTracker/wiki/Osc-message-specification
  boolean parseOSC(OscMessage m) 
  {

    // image
    if (m.checkAddrPattern("/image/width")) {
      imageWidth = m.get(0).intValue();
      return true;
    } else if (m.checkAddrPattern("/image/height")) {
      imageHeight = m.get(0).intValue();
      return true;
    }

    if (m.checkAddrPattern("/found")) {
      found = m.get(0).intValue();
      return true;
    } else if (m.checkAddrPattern("/pose/scale")) {
      poseScale = m.get(0).floatValue();
      return true;
    } else if (m.checkAddrPattern("/pose/position")) {
      posePosition.x = m.get(0).floatValue();
      posePosition.y = m.get(1).floatValue();
      return true;
    } else if (m.checkAddrPattern("/pose/orientation")) {
      poseOrientation.x = m.get(0).floatValue();
      poseOrientation.y = m.get(1).floatValue();
      poseOrientation.z = m.get(2).floatValue();
      return true;
    }

    // gesture
    else if (m.checkAddrPattern("/gesture/mouth/width")) {
      mouthWidth = m.get(0).floatValue();
      return true;
    } else if (m.checkAddrPattern("/gesture/mouth/height")) {
      mouthHeight = m.get(0).floatValue();
      return true;
    } else if (m.checkAddrPattern("/gesture/eye/left")) {
      eyeLeft = m.get(0).floatValue();
      return true;
    } else if (m.checkAddrPattern("/gesture/eye/right")) {
      eyeRight = m.get(0).floatValue();
      return true;
    } else if (m.checkAddrPattern("/gesture/eyebrow/left")) {
      eyebrowLeft = m.get(0).floatValue();
      return true;
    } else if (m.checkAddrPattern("/gesture/eyebrow/right")) {
      eyebrowRight = m.get(0).floatValue();
      return true;
    } else if (m.checkAddrPattern("/gesture/jaw")) {
      jaw = m.get(0).floatValue();
      return true;
    } else if (m.checkAddrPattern("/gesture/nostrils")) {
      nostrils = m.get(0).floatValue();
      return true;
    }

    return false;
  }

  // --------------------------------------------
  // get the current face values as a string (includes end lines)
  String toString() 
  {
    return "found: " + found + "\n"
      + "pose" + "\n"
      + " scale: " + poseScale + "\n"
      + " position: " + posePosition.toString() + "\n"
      + " orientation: " + poseOrientation.toString() + "\n"
      + "gesture" + "\n"
      + " mouth: " + mouthWidth + " " + mouthHeight + "\n"
      + " eye: " + eyeLeft + " " + eyeRight + "\n"
      + " eyebrow: " + eyebrowLeft + " " + eyebrowRight + "\n"
      + " jaw: " + jaw + "\n"
      + " nostrils: " + nostrils + "\n";
  }


  // --------------------------------------------
  // called by osc
  public void loadMesh(float x0, float y0, float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4, float x5, float y5, float x6, float y6, float x7, float y7, float x8, float y8, float x9, float y9, float x10, float y10, float x11, float y11, float x12, float y12, float x13, float y13, float x14, float y14, float x15, float y15, float x16, float y16, float x17, float y17, float x18, float y18, float x19, float y19, float x20, float y20, float x21, float y21, float x22, float y22, float x23, float y23, float x24, float y24, float x25, float y25, float x26, float y26, float x27, float y27, float x28, float y28, float x29, float y29, float x30, float y30, float x31, float y31, float x32, float y32, float x33, float y33, float x34, float y34, float x35, float y35, float x36, float y36, float x37, float y37, float x38, float y38, float x39, float y39, float x40, float y40, float x41, float y41, float x42, float y42, float x43, float y43, float x44, float y44, float x45, float y45, float x46, float y46, float x47, float y47, float x48, float y48, float x49, float y49, float x50, float y50, float x51, float y51, float x52, float y52, float x53, float y53, float x54, float y54, float x55, float y55, float x56, float y56, float x57, float y57, float x58, float y58, float x59, float y59, float x60, float y60, float x61, float y61, float x62, float y62, float x63, float y63, float x64, float y64, float x65, float y65) 
  {
    //println("loading mesh...");  

    meshPoints[0].x = x0; 
    meshPoints[0].y = y0; 
    meshPoints[1].x = x1; 
    meshPoints[1].y = y1;
    meshPoints[2].x = x2; 
    meshPoints[2].y = y2;
    meshPoints[3].x = x3; 
    meshPoints[3].y = y3;
    meshPoints[4].x = x4; 
    meshPoints[4].y = y4;
    meshPoints[5].x = x5; 
    meshPoints[5].y = y5;
    meshPoints[6].x = x6; 
    meshPoints[6].y = y6;
    meshPoints[7].x = x7; 
    meshPoints[7].y = y7;
    meshPoints[8].x = x8; 
    meshPoints[8].y = y8;
    meshPoints[9].x = x9; 
    meshPoints[9].y = y9;
    meshPoints[10].x = x10; 
    meshPoints[10].y = y10;
    meshPoints[11].x = x11; 
    meshPoints[11].y = y11;
    meshPoints[12].x = x12; 
    meshPoints[12].y = y12;
    meshPoints[13].x = x13; 
    meshPoints[13].y = y13;
    meshPoints[14].x = x14; 
    meshPoints[14].y = y14;
    meshPoints[15].x = x15; 
    meshPoints[15].y = y15;
    meshPoints[16].x = x16; 
    meshPoints[16].y = y16;
    meshPoints[17].x = x17; 
    meshPoints[17].y = y17;
    meshPoints[18].x = x18; 
    meshPoints[18].y = y18;
    meshPoints[19].x = x19; 
    meshPoints[19].y = y19;
    meshPoints[20].x = x20; 
    meshPoints[20].y = y20;
    meshPoints[21].x = x21; 
    meshPoints[21].y = y21;
    meshPoints[22].x = x22; 
    meshPoints[22].y = y22;
    meshPoints[23].x = x23; 
    meshPoints[23].y = y23;
    meshPoints[24].x = x24; 
    meshPoints[24].y = y24;
    meshPoints[25].x = x25; 
    meshPoints[25].y = y25;
    meshPoints[26].x = x26; 
    meshPoints[26].y = y26;
    meshPoints[27].x = x27; 
    meshPoints[27].y = y27;
    meshPoints[28].x = x28; 
    meshPoints[28].y = y28;
    meshPoints[29].x = x29; 
    meshPoints[29].y = y29;
    meshPoints[30].x = x30; 
    meshPoints[30].y = y30;
    meshPoints[31].x = x31; 
    meshPoints[31].y = y31;
    meshPoints[32].x = x32; 
    meshPoints[32].y = y32;
    meshPoints[33].x = x33; 
    meshPoints[33].y = y33;
    meshPoints[34].x = x34; 
    meshPoints[34].y = y34;
    meshPoints[35].x = x35; 
    meshPoints[35].y = y35;
    meshPoints[36].x = x36; 
    meshPoints[36].y = y36;
    meshPoints[37].x = x37; 
    meshPoints[37].y = y37;
    meshPoints[38].x = x38; 
    meshPoints[38].y = y38;
    meshPoints[39].x = x39; 
    meshPoints[39].y = y39;
    meshPoints[40].x = x40; 
    meshPoints[40].y = y40;
    meshPoints[41].x = x41; 
    meshPoints[41].y = y41;
    meshPoints[42].x = x42; 
    meshPoints[42].y = y42;
    meshPoints[43].x = x43; 
    meshPoints[43].y = y43;
    meshPoints[44].x = x44; 
    meshPoints[44].y = y44;
    meshPoints[45].x = x45; 
    meshPoints[45].y = y45;
    meshPoints[46].x = x46; 
    meshPoints[46].y = y46;
    meshPoints[47].x = x47; 
    meshPoints[47].y = y47;
    meshPoints[48].x = x48; 
    meshPoints[48].y = y48;
    meshPoints[49].x = x49; 
    meshPoints[49].y = y49;
    meshPoints[50].x = x50; 
    meshPoints[50].y = y50;
    meshPoints[51].x = x51; 
    meshPoints[51].y = y51;
    meshPoints[52].x = x52; 
    meshPoints[52].y = y52;
    meshPoints[53].x = x53; 
    meshPoints[53].y = y53;
    meshPoints[54].x = x54; 
    meshPoints[54].y = y54;
    meshPoints[55].x = x55; 
    meshPoints[55].y = y55;
    meshPoints[56].x = x56; 
    meshPoints[56].y = y56;
    meshPoints[57].x = x57; 
    meshPoints[57].y = y57;
    meshPoints[58].x = x58; 
    meshPoints[58].y = y58;
    meshPoints[59].x = x59; 
    meshPoints[59].y = y59;
    meshPoints[60].x = x60; 
    meshPoints[60].y = y60;
    meshPoints[61].x = x61; 
    meshPoints[61].y = y61;
    meshPoints[62].x = x62; 
    meshPoints[62].y = y62;
    meshPoints[63].x = x63; 
    meshPoints[63].y = y63;
    meshPoints[64].x = x64; 
    meshPoints[64].y = y64;
    meshPoints[65].x = x65; 
    meshPoints[65].y = y65;
  }

  // --------------------------------------------
  public void loadMeshImg(float x0, float y0, float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4, float x5, float y5, float x6, float y6, float x7, float y7, float x8, float y8, float x9, float y9, float x10, float y10, float x11, float y11, float x12, float y12, float x13, float y13, float x14, float y14, float x15, float y15, float x16, float y16, float x17, float y17, float x18, float y18, float x19, float y19, float x20, float y20, float x21, float y21, float x22, float y22, float x23, float y23, float x24, float y24, float x25, float y25, float x26, float y26, float x27, float y27, float x28, float y28, float x29, float y29, float x30, float y30, float x31, float y31, float x32, float y32, float x33, float y33, float x34, float y34, float x35, float y35, float x36, float y36, float x37, float y37, float x38, float y38, float x39, float y39, float x40, float y40, float x41, float y41, float x42, float y42, float x43, float y43, float x44, float y44, float x45, float y45, float x46, float y46, float x47, float y47, float x48, float y48, float x49, float y49, float x50, float y50, float x51, float y51, float x52, float y52, float x53, float y53, float x54, float y54, float x55, float y55, float x56, float y56, float x57, float y57, float x58, float y58, float x59, float y59, float x60, float y60, float x61, float y61, float x62, float y62, float x63, float y63, float x64, float y64, float x65, float y65) 
  {
    //println("loadMeshImg");  

    meshPoints2[0].x = x0; 
    meshPoints2[0].y = y0; 
    meshPoints2[1].x = x1; 
    meshPoints2[1].y = y1;
    meshPoints2[2].x = x2; 
    meshPoints2[2].y = y2;
    meshPoints2[3].x = x3; 
    meshPoints2[3].y = y3;
    meshPoints2[4].x = x4; 
    meshPoints2[4].y = y4;
    meshPoints2[5].x = x5; 
    meshPoints2[5].y = y5;
    meshPoints2[6].x = x6; 
    meshPoints2[6].y = y6;
    meshPoints2[7].x = x7; 
    meshPoints2[7].y = y7;
    meshPoints2[8].x = x8; 
    meshPoints2[8].y = y8;
    meshPoints2[9].x = x9; 
    meshPoints2[9].y = y9;
    meshPoints2[10].x = x10; 
    meshPoints2[10].y = y10;
    meshPoints2[11].x = x11; 
    meshPoints2[11].y = y11;
    meshPoints2[12].x = x12; 
    meshPoints2[12].y = y12;
    meshPoints2[13].x = x13; 
    meshPoints2[13].y = y13;
    meshPoints2[14].x = x14; 
    meshPoints2[14].y = y14;
    meshPoints2[15].x = x15; 
    meshPoints2[15].y = y15;
    meshPoints2[16].x = x16; 
    meshPoints2[16].y = y16;
    meshPoints2[17].x = x17; 
    meshPoints2[17].y = y17;
    meshPoints2[18].x = x18; 
    meshPoints2[18].y = y18;
    meshPoints2[19].x = x19; 
    meshPoints2[19].y = y19;
    meshPoints2[20].x = x20; 
    meshPoints2[20].y = y20;
    meshPoints2[21].x = x21; 
    meshPoints2[21].y = y21;
    meshPoints2[22].x = x22; 
    meshPoints2[22].y = y22;
    meshPoints2[23].x = x23; 
    meshPoints2[23].y = y23;
    meshPoints2[24].x = x24; 
    meshPoints2[24].y = y24;
    meshPoints2[25].x = x25; 
    meshPoints2[25].y = y25;
    meshPoints2[26].x = x26; 
    meshPoints2[26].y = y26;
    meshPoints2[27].x = x27; 
    meshPoints2[27].y = y27;
    meshPoints2[28].x = x28; 
    meshPoints2[28].y = y28;
    meshPoints2[29].x = x29; 
    meshPoints2[29].y = y29;
    meshPoints2[30].x = x30; 
    meshPoints2[30].y = y30;
    meshPoints2[31].x = x31; 
    meshPoints2[31].y = y31;
    meshPoints2[32].x = x32; 
    meshPoints2[32].y = y32;
    meshPoints2[33].x = x33; 
    meshPoints2[33].y = y33;
    meshPoints2[34].x = x34; 
    meshPoints2[34].y = y34;
    meshPoints2[35].x = x35; 
    meshPoints2[35].y = y35;
    meshPoints2[36].x = x36; 
    meshPoints2[36].y = y36;
    meshPoints2[37].x = x37; 
    meshPoints2[37].y = y37;
    meshPoints2[38].x = x38; 
    meshPoints2[38].y = y38;
    meshPoints2[39].x = x39; 
    meshPoints2[39].y = y39;
    meshPoints2[40].x = x40; 
    meshPoints2[40].y = y40;
    meshPoints2[41].x = x41; 
    meshPoints2[41].y = y41;
    meshPoints2[42].x = x42; 
    meshPoints2[42].y = y42;
    meshPoints2[43].x = x43; 
    meshPoints2[43].y = y43;
    meshPoints2[44].x = x44; 
    meshPoints2[44].y = y44;
    meshPoints2[45].x = x45; 
    meshPoints2[45].y = y45;
    meshPoints2[46].x = x46; 
    meshPoints2[46].y = y46;
    meshPoints2[47].x = x47; 
    meshPoints2[47].y = y47;
    meshPoints2[48].x = x48; 
    meshPoints2[48].y = y48;
    meshPoints2[49].x = x49; 
    meshPoints2[49].y = y49;
    meshPoints2[50].x = x50; 
    meshPoints2[50].y = y50;
    meshPoints2[51].x = x51; 
    meshPoints2[51].y = y51;
    meshPoints2[52].x = x52; 
    meshPoints2[52].y = y52;
    meshPoints2[53].x = x53; 
    meshPoints2[53].y = y53;
    meshPoints2[54].x = x54; 
    meshPoints2[54].y = y54;
    meshPoints2[55].x = x55; 
    meshPoints2[55].y = y55;
    meshPoints2[56].x = x56; 
    meshPoints2[56].y = y56;
    meshPoints2[57].x = x57; 
    meshPoints2[57].y = y57;
    meshPoints2[58].x = x58; 
    meshPoints2[58].y = y58;
    meshPoints2[59].x = x59; 
    meshPoints2[59].y = y59;
    meshPoints2[60].x = x60; 
    meshPoints2[60].y = y60;
    meshPoints2[61].x = x61; 
    meshPoints2[61].y = y61;
    meshPoints2[62].x = x62; 
    meshPoints2[62].y = y62;
    meshPoints2[63].x = x63; 
    meshPoints2[63].y = y63;
    meshPoints2[64].x = x64; 
    meshPoints2[64].y = y64;
    meshPoints2[65].x = x65; 
    meshPoints2[65].y = y65;
  }
};