class ToolFaceOSC extends Tool
{
  ToolFaceOSC(PApplet p)
  {
    super(p);
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  public String getId()
  {
    return "__ToolFaceOSC__";
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void initControls()
  {
    initTab("default", "faceOSC");
    
    cp5.addToggle("__DEBUG__").setLabel("debug").moveTo("default").setWidth(20).linebreak();
    cp5.addToggle("__DEBUG_IMAGES__").setLabel("face draw images").moveTo("default").setWidth(20).linebreak();
    cp5.addToggle("__DEBUG_BOUNDINGS__").setLabel("face draw boundings").moveTo("default").setWidth(20).linebreak();
    cp5.addToggle("__DEBUG_FEATURES__").setLabel("face draw features").moveTo("default").setWidth(20).linebreak();
    cp5.addToggle("__DEBUG_INFOS__").setLabel("face draw infos").moveTo("default").setWidth(20).linebreak();
    
    cp5.addToggle("bZoom").plugTo(faceOSC).setValue(faceOSC.bZoom).setLabel("face zoom").moveTo("default").setWidth(20).linebreak();
    cp5.addSlider("zoomSpeed").plugTo(faceOSC).setValue(faceOSC.zoomSpeed).setRange(0.1,1.0)
    .setLabel("face zoom speed").moveTo("default").setWidth(200).linebreak();
  }
}