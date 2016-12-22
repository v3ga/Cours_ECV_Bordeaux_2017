class Tool implements ControlListener
{
  PApplet applet=null;
  int id = 0;
  String tabName = "";
  
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
  void initTab(String name, String label)
  {
    tabName = name;
    cp5.getTab(tabName).activateEvent(true);
    cp5.getTab(tabName).setHeight(20);
    cp5.getTab(tabName).getCaptionLabel().getStyle().marginTop = 2;
    cp5.getTab(tabName).setId(id);
    cp5.getTab(tabName).setLabel(label);
    // cp5.getTab(tabName).setColorBackground(color(0, 0, 117));
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
  void initControls()
  {
    cp5 = new ControlP5(applet);
//    cp5.setAutoDraw(false);
    //cp5.setFont(createFont("helvetica",10));

    for (Tool t : this)
      t.initControls();
  }

  // --------------------------------------------------------------------
  void saveProperties()
  {
    cp5.saveProperties("data/tools");
  }

  // --------------------------------------------------------------------
  void loadProperties()
  {
    cp5.loadProperties("data/tools");
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