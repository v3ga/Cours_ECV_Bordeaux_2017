class SceneTypo extends Scene
{
  RuttEtraizer re;

  SceneTypo()
  {
    super("Typo");
  }

  void update()
  {
    PImage imageVisageCompute = faceOSC.getImageVisageCompute();
    if (imageVisageCompute != null)
    {
      if (re == null)
      {
        re = new RuttEtraizer(imageVisageCompute, 1);
      }
    }     

    if (re != null)
    {
      re.apply();
    }
  }

  void draw()
  {

    faceOSC.drawFrameSyphonZoom();    
    if (re != null)
    {
      pushMatrix();
      translate(width/2, height/2, 300);
      re.draw(applet, 100);
      popMatrix();
    }
  }
}