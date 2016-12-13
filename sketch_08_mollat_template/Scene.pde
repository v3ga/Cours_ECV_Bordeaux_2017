class Scene
{
  String name="";
  String pathData = "";

  float m_alphaBackground = 0.0;
  float m_alphaBackgroundTarget = 0.0;

  // --------------------------------------------
  Scene(String name_)
  {
    this.name = name_;
    this.pathData = "data/"+this.name+"/";
  }

  // --------------------------------------------
  String getPathData(String filename){return this.pathData+filename;}


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
}