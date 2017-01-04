class ToolFaceOSC extends Tool
{
  
  Chart chartFaceFoundFactor;
  
  ToolFaceOSC(PApplet p)
  {
    super(p);
  }

  // --------------------------------------------------------------------
  public String getId()
  {
    return "__ToolFaceOSC__";
  }

  // --------------------------------------------------------------------
  void initControls()
  {
    initTab("default", "faceOSC");
    
    cp5.addToggle("__DEBUG__").setLabel("debug").moveTo("default").setWidth(20).linebreak();
    cp5.addToggle("__DEBUG_IMAGES__").setLabel("face draw images").moveTo("default").setWidth(20).linebreak();
    cp5.addToggle("__DEBUG_BOUNDINGS__").setLabel("face draw boundings").moveTo("default").setWidth(20).linebreak();
    cp5.addToggle("__DEBUG_FEATURES__").setLabel("face draw features").moveTo("default").setWidth(20).linebreak();
    cp5.addToggle("__DEBUG_INFOS__").setLabel("face draw infos").moveTo("default").setWidth(20).linebreak();
    
    chartFaceFoundFactor = cp5.addChart("faceFoundFactor").setSize(200,100).setRange(0.0,1.25).setView(Chart.LINE).setStrokeWeight(1.5);
    chartFaceFoundFactor.setPosition(width-200-toolManager.tabX, height-100-toolManager.tabY);
    chartFaceFoundFactor.addDataSet("incoming");
    chartFaceFoundFactor.setData("incoming", new float[100]);

    cp5.addSlider("foundFactorRelax").plugTo(faceOSC.getFace()).setValue(faceOSC.getFace().foundFactorRelax).setRange(0.1,1.0)
    .setLabel("face found factor relax").moveTo("default")
    .setWidth(200).setHeight(20).linebreak();
    
    cp5.addToggle("bZoom").plugTo(faceOSC).setValue(faceOSC.bZoom).setLabel("face zoom").moveTo("default").setWidth(20).linebreak();
    cp5.addSlider("zoomSpeed").plugTo(faceOSC).setValue(faceOSC.zoomSpeed).setRange(0.1,1.0)
    .setLabel("face zoom speed").moveTo("default").setWidth(200).setHeight(20).linebreak();

    cp5.addSlider("faceBoundingBorders").setRange(0,100)
    .setLabel("face bounding borders").moveTo("default").setWidth(200).setHeight(20)
    .addListener(this).linebreak();

     cp5.addSlider("faceRatioThreshold").setRange(0.1,1.0)
    .setLabel("face ratio threshold").moveTo("default").setWidth(200).setHeight(20)
    .addListener(this).linebreak();

    cp5.addButton("saveTools").setLabel("save").plugTo(this).moveTo("default").setHeight(20).setPosition(toolManager.tabX,height-20-toolManager.tabY);
  }

  // --------------------------------------------------------------------
  void update()
  {
    chartFaceFoundFactor.push("incoming", faceOSC.getFace().getFoundFactor());
  }

  // --------------------------------------------------------------------
  void saveTools(int value)
  {
    toolManager.saveProperties();
  }
  
  // --------------------------------------------------------------------
  void controlEvent(ControlEvent theEvent) 
  {
    if (theEvent.getName().equals("faceBoundingBorders"))
    {
      faceOSC.getFace().setBoundingPortraitBorders( theEvent.getValue() );
    }
    else if (theEvent.getName().equals("faceRatioThreshold"))
    {
      faceOSC.getFace().setRatioToFrameSyphonThreshold( theEvent.getValue() );
    }
  }
  
}