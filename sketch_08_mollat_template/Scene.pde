class Scene
{
  String name="";
  String pathData = "";

  float m_alphaBackground = 0.0;
  float m_alphaBackgroundTarget = 0.0;

  boolean canExportPDF = false;
  boolean bExportPDF = false;
  boolean bFaceSaved = false;
  
  int idFaceSave=0;
  

  // --------------------------------------------
  Scene(String name_)
  {
    this.name = name_;
    this.pathData = "data/"+this.name+"/";
  }

  // --------------------------------------------
  String getPathData(String filename) {
    return this.pathData+filename;
  }


  // --------------------------------------------
  void setup()
  {
  }

  // --------------------------------------------
  // 
  void onNewFrame()
  {
  }

  // --------------------------------------------
  void update()
  {
  }

  // --------------------------------------------
  void updateAlphaBackground()
  {
    if (faceOSC.state == FaceOSC.STATE_REST || faceOSC.state == FaceOSC.STATE_ZOOMING)
      m_alphaBackgroundTarget = 0.0f;
    else if (faceOSC.state == FaceOSC.STATE_ZOOMED)
      m_alphaBackgroundTarget = 255.0f;

    m_alphaBackground += (m_alphaBackgroundTarget - m_alphaBackground)*0.2;
  }

  // --------------------------------------------
  void drawFaceOSCFrameZoom()
  {
    faceOSC.drawFrameSyphon();
  }

  // --------------------------------------------
  void draw()
  {
  }

  // --------------------------------------------
  void mouseMoved()
  {
  }

  // --------------------------------------------
  void mousePressed()
  {
  }

  // --------------------------------------------
  void keyPressed()
  {
  }

  // --------------------------------------------
  void beginExportPDF()
  {
    if (canExportPDF && bExportPDF)
    {
      
    }
  }

  // --------------------------------------------
  void endExportPDF()
  {
    if (bExportPDF)
    {

      bExportPDF = false;
    }
  }
  
  // --------------------------------------------
  void updateSaveFace()
  {
    // Not saved yet ? 
    if (bFaceSaved == false)
    {
      if (faceOSC.getStateTime() >= 5.0f && faceOSC.state == FaceOSC.STATE_ZOOMED)
      {
        saveFace();
        bFaceSaved = true;
        bExportPDF = true;
      }
    }
    else
    {
      if (faceOSC.state == FaceOSC.STATE_REST)
      {
        bFaceSaved = false;
      }
    }
  }

  // --------------------------------------------
  void saveFace()
  {
    PImage imgVisage = faceOSC.getImageVisage();
    if (imgVisage != null)
    {
      createDirForToday();
      idFaceSave= faceOSC.getId(); // is useful is canExportPDF is et to true
      String faceFilePath = getFaceFilePath()+".png";
      if (imgVisage.save( faceFilePath ))
      {
        println("saveFace(), saved "+faceFilePath);
        faceOSC.incrementId();
      }
      else
      {
        println("saveFace(), erro saving "+faceFilePath);
      }
    }
  }

  // --------------------------------------------
  String getFaceFilePath()
  {
    return getTodayDirPath()+"/"+idFaceSave;
  }

  // --------------------------------------------
  String getTodayDirName()
  {
    return year()+"_"+month()+"_"+day();
  }

  // --------------------------------------------
  String getTodayDirPath()
  {
    return dataPath("_exports/"+getTodayDirName());
  }
  
  // --------------------------------------------
  void createDirForToday()
  {
    String dirName = getTodayDirName();
    File dir = new File(dataPath("_exports/"+dirName));
    if (dir.exists() == false)
    {
      dir.mkdir();
    }
  }
}