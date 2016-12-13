void initControls()
{
  // cp5 = new ControlP5(this);

  // By default all controllers are stored inside Tab 'default' 
  // add a second tab with name 'extra'
  toolManager = new ToolManager(this);

  toolManager.addTool( new ToolFaceOSC(this) );

  toolManager.addTool( new ToolEmily(this) );
  toolManager.addTool( new ToolLea(this) );
  toolManager.addTool( new ToolAlexis(this) );
  toolManager.addTool( new ToolThibaut(this) );
  toolManager.addTool( new ToolBenedicte(this) );
  
  toolManager.initControls();
  toolManager.setup();
  
  
/*  cp5.addTab("extra")
    .setColorBackground(color(0, 160, 100))
    .setColorLabel(color(255))
    .setColorActive(color(255, 128, 0))
    ;
/*
  
  cp5.addTab("extra")
    .setColorBackground(color(0, 160, 100))
    .setColorLabel(color(255))
    .setColorActive(color(255, 128, 0))
    ;

  // if you want to receive a controlEvent when
  // a  tab is clicked, use activeEvent(true)

  cp5.getTab("default")
    .activateEvent(true)
    .setLabel("my default tab")
    .setId(1)
    ;

  cp5.getTab("extra")
    .activateEvent(true)
    .setId(2)
    ;
*/
}