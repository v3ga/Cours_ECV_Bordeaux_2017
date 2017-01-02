class ToolScenes extends Tool
{
  ToolScenes(PApplet p)
  {
    super(p);
  }

  // --------------------------------------------------------------------
  public String getId()
  {
    return "__ToolScenes__";
  }

  // --------------------------------------------------------------------
  void initControls()
  {
    initTab("scenes", "Scenes");

    cp5.addSlider("timeOnBeginAnimCall").plugTo(sceneManager).setValue(sceneManager.timeOnBeginAnimCall).setRange(0.0, 10.0)
      .setLabel("time OnBeginAnimation call").moveTo("scenes")
      .setPosition(toolManager.tabX+4, toolManager.tabY+30).setWidth(200).setHeight(20).linebreak();
  }
}