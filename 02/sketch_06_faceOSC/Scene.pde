class Scene
{
  String name="";
  
  Scene(String name_)
  {
    this.name = name_;
  }
  
  void setup()
  {
  }

  void draw()
  {
    background(0);
    face.update();
    drawFaceImage();
    drawFaceFeatures();
  }
}