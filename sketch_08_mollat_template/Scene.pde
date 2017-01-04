class Scene
{
  // Scene Manager
  SceneManager sceneManager;

  // Name + path for data
  String name="";
  String pathData = "";

  // Background
  float m_alphaBackground = 0.0;
  float m_alphaBackgroundTarget = 0.0;

  // Export
  boolean canExportPDF = false;
  boolean bExportPDF = false;
  boolean bFaceSaved = false;

  // Save face id
  int idFaceSave=0;

  // trigger animation variables (onBeginAnimation call)
  boolean bOnBeginAnimCalled = false;
  float timeOnBeginAnimCall = 0.0f;


  // --------------------------------------------
  Scene(String name_)
  {
    this.name = name_;
//    this.pathData = sketchPath("data/scenes/"+this.name+"/");
    this.pathData = "data/scenes/"+this.name+"/";
  }

  // --------------------------------------------
  void setSceneManager(SceneManager sceneManager_)
  {
    this.sceneManager = sceneManager_;
  }

  // --------------------------------------------
  String getPathData(String filename) {
    return this.pathData+filename;
  }

  // --------------------------------------------
  // called once at creation 
  void setup()
  {
  }

  // --------------------------------------------
  // called when the scene changes in application
  void reset()
  {
    bFaceSaved = false;
    bExportPDF = false;

    bOnBeginAnimCalled = false;
    timeOnBeginAnimCall = 0.0f;
  }

  // --------------------------------------------
  // called when a new syphon frame is available
  // can perform here computations on faceOSC images
  void onNewFrame()
  {
  }

  // --------------------------------------------
  // called when faceOSC.state == FaceOSC.STATE_ZOOMED
  // after a certain amount of time
  void onBeginAnimation()
  {
    println("onBeginAnimation()");
  }

  // --------------------------------------------
  // called when faceOSC.state == FaceOSC.STATE_ZOOMED terminates
  void onTerminateAnimation()
  {
    println("onTerminateAnimation()");
  }

  // --------------------------------------------
  // called just before draw
  // dt must be available as global variable
  void update()
  {
    // save here spetactor face in a daily directory with file depending on idFaceSave 
    updateSaveFace();

    // Update state 
    updateOnBeginAnimCall();
    updateOnTerminateAnimCall();
  }

  // --------------------------------------------
  void updateOnBeginAnimCall()
  {
    // 
    if (faceOSC.state == FaceOSC.STATE_ZOOMED)
    {
      timeOnBeginAnimCall += dt;
      if (timeOnBeginAnimCall > sceneManager.timeOnBeginAnimCall && !bOnBeginAnimCalled)
      {
        onBeginAnimation();
        bOnBeginAnimCalled = true;
      }
    } else
    {
      timeOnBeginAnimCall = 0;
      bOnBeginAnimCalled = false;
    }
  }

  // --------------------------------------------
  void updateOnTerminateAnimCall()
  {
    if (faceOSC.hasStateChanged() && faceOSC.statePrevious == FaceOSC.STATE_ZOOMED)
    {
      onTerminateAnimation();
    }
  }

  // --------------------------------------------
  void updateAlphaBackground()
  {
    if (faceOSC.state == FaceOSC.STATE_REST || faceOSC.state == FaceOSC.STATE_ZOOMING)
      m_alphaBackgroundTarget = 0.0f;
    else if (faceOSC.state == FaceOSC.STATE_ZOOMED)
      m_alphaBackgroundTarget = 255.0f;
    m_alphaBackground = float_relax(m_alphaBackground, m_alphaBackgroundTarget, dt, 0.5f);
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
    } else
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
      } else
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

  // --------------------------------------------
  String getDebugInfos()
  {
    return "Scene : "+this.name+" / frameRate = " + int(frameRate);
  }
}