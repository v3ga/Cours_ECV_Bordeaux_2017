class SceneDebug extends Scene
{
  // --------------------------------------------
  SceneDebug(String name)
  {
    super(name);
  }

  // --------------------------------------------
  void onNewFrame()
  {
  }

  // --------------------------------------------
  void onBeginAnimation()
  {
    super.onBeginAnimation();
  }

  // --------------------------------------------
  void onTerminateAnimation()
  {
    super.onTerminateAnimation();
  }

  // --------------------------------------------
  void update()
  {
    super.update();
  }

  // --------------------------------------------
  void draw()
  {
    faceOSC.drawFrameSyphonZoom();
  }
}