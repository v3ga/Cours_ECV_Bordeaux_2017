class Scene
{
  String name="";
  String pathData = "";

  Scene(String name_)
  {
    this.name = name_;
    this.pathData = "data/"+this.name+"/";
  }
  void setup()
  {
  }

  void update()
  {
  }

  void drawFaceOSCFrameZoom()
  {
    faceOSC.drawFrameSyphon();
  }

  void draw()
  {
  }

  void mouseMoved()
  {
  }

  void mousePressed()
  {
  }
}