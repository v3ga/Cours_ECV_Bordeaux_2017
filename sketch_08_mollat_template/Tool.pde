class Tool implements ControlListener
{
  PApplet applet=null;
  int id = 0;
  String tabName = "";
  ToolManager toolManager;  
    
  // --------------------------------------------------------------------
  Tool(PApplet p)
  {
    this.applet = p;
  }

  // --------------------------------------------------------------------
  String _id(String name)
  {
    return tabName+"_"+name;
  }

    // --------------------------------------------------------------------

  // --------------------------------------------------------------------
  void initTab(String name, String label)
  {
    tabName = name;
    cp5.getTab(tabName).setLabel(label).setId(id).activateEvent(true).setHeight(20)/*.setPosition(toolManager.tabX,0)*/;
    Label tabLabel = cp5.getTab(tabName).getCaptionLabel();
    //tabLabel.setPosition(controlPosX, tabPosY);
    tabLabel.getStyle().marginTop = 2;
    // cp5.getTab(tabName).setColorBackground(color(0, 0, 117));
  }

  // --------------------------------------------------------------------
  void setToolManager(ToolManager tm_)
  {
    this.toolManager = tm_;
  }
  
  // --------------------------------------------------------------------
  void setup(){}
  void update(){}
  void draw(){}
  void select(){}
  void unselect(){}
  void mousePressed(){}
  void mouseDragged(){}
  void mouseReleased(){}
  void keyPressed(){}

  void initControls(){}
  public void controlEvent(ControlEvent theEvent) {}
}

class ToolManager extends ArrayList<Tool>
{
  PApplet applet=null;
  Tool toolSelected = null;
  int idTool = 0;
  int tabX = 0;
  int tabY = 0;
  
  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  ToolManager(PApplet applet)
  {
    this.applet = applet;
  }
  
  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void addTool(Tool t)
  {
    add(t);
    t.id = ++idTool;
  }  
  
  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void setup()
  {
    for (Tool t:this)
      t.setup();
    toolSelected = get(0);
  }
  
  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void initControls(int tabX_, int tabY_, boolean autoDraw_)
  {
    println("-- initControls("+tabX_+","+tabY_+","+autoDraw_+")");
    this.tabX = tabX_;
    this.tabY = tabY_;
    
    cp5 = new ControlP5(applet);
    cp5.setAutoDraw(false);
    //cp5.setFont(createFont("helvetica",10));
    cp5.getWindow().setPositionOfTabs(tabX,tabY);

    for (Tool t : this)
    {
      t.setToolManager(this);

      cp5.begin(tabX,tabY+40);
      t.initControls();
      cp5.end();
    }
  }

  // --------------------------------------------------------------------
  void saveProperties()
  {
    cp5.saveProperties(sketchPath("data/tools"));
  }

  // --------------------------------------------------------------------
  void loadProperties()
  {
    cp5.loadProperties(sketchPath("data/tools"));
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void update()
  {
    for (Tool t : this)
      t.update();
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void draw()
  {
    if (toolSelected != null)
      toolSelected.draw();
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  Tool getTool(int id)
  {
    Tool t = null;
    for (int i=0;i<size();i++){
      t = get(i);
      if (t.id == id) break;
    }
    return t;
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void select(Tool which)
  {
    select(which.id);  
    cp5.getWindow(applet).activateTab(which.tabName);
  }
  
  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void select(int id)
  {
    if (toolSelected != null)
      toolSelected.unselect();

    Tool t = getTool(id);
    if (t != toolSelected){
      toolSelected = t;
      t.select();
    }
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void mousePressed()
  {
    if (toolSelected !=null)
      toolSelected.mousePressed();
  }
  
  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void mouseDragged()
  {
    if (toolSelected !=null)
      toolSelected.mouseDragged();
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void mouseReleased()
  {
    if (toolSelected !=null)
      toolSelected.mouseReleased();
  }


  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void keyPressed()
  {
    if (toolSelected !=null)
      toolSelected.keyPressed();
  }
}