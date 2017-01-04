// ==================================================
// ==================================================
class SceneThibaut extends Scene
{
  PImage img, displacementMap;
  PVector pos;
  float scale;
  float displacement = 100;
  PShape grid;
  PGraphics tex;
  PShader shader;

  String texte = "";
  String texteName = "texte.txt"; 

  String fonteName = "BodoniLT-Book-48";
  PFont fonte;
  float textSize = 30;
  float textLeading = 30;

  boolean bSetup = false;  
  boolean bCreateText = true;
  boolean bDoBlur = true;
  float blurLevel = 2;

  float tTransition = 0.0f;

  float resx = 40*2;
  float resy = 30*Z;

  // --------------------------------------------
  SceneThibaut(String name)
  {
    super(name);
    shader = loadShader( getPathData("gridfrag.glsl"), getPathData("gridvert.glsl"));
    texte = loadText(texteName);
  }

  // --------------------------------------------
  String loadText(String name)
  {
    String s = "";
    String[] lines = loadStrings( getPathData(name) );
    for (int i=0; i<lines.length; i++) {
      s += lines[i] + "\n";
    }
    return s;
  }

  // --------------------------------------------
  void setup()
  {
    fonte = loadFont( getPathData(fonteName+".vlw") );
    bSetup = true;
  }

  // --------------------------------------------
  void onNewFrame()
  {
    img = faceOSC.getImageVisage();

    displacementMap = img.copy();
    if (bDoBlur)
    {
      displacementMap.resize(img.width/4,img.height/4);
      displacementMap.filter(BLUR, (int)blurLevel);
    }
  }

  // --------------------------------------------
  void onBeginAnimation()
  {
    super.onBeginAnimation();
    Ani.to(this, 3.0, "tTransition", 1.0);
  }

  // --------------------------------------------
  void onTerminateAnimation()
  {
    super.onTerminateAnimation();
    Ani.to(this, 1.0, "tTransition", 0.0);
  }  

  // --------------------------------------------
  void update()
  {
    super.update();
  }

  // --------------------------------------------
  void createTextImage()
  {
    if (bCreateText)
    {
      bCreateText = false;
      
      if (tex == null)
        tex = createGraphics(width, height, P2D);

      tex.beginDraw();
      tex.background(0);
      tex.noStroke();
      tex.fill(255);
      tex.textFont(fonte);
      tex.textAlign(CENTER);
      tex.textSize(textSize);
      tex.textLeading(textLeading);
      tex.text(texte, 0, 0, width, height);
      tex.endDraw();
    }
  }

  // --------------------------------------------
  void createGrid()
  {
    if (grid == null)
    {
      float stepx = float(width) / resx;
      float stepy = float(height) /resy;
      float x = 0.0;
      float y = 0.0;
      float u = 0.0;
      float v = 0.0;

      grid = createShape();
      grid.beginShape(QUAD);
      grid.noStroke();
      grid.texture(tex);
      for (int j=0; j<=resy; j++)
      {
        x = 0;
        for (int i=0; i<=resx; i++)
        {
          u = x;
          v = y;

          grid.vertex(x, y, 0, u, v);
          grid.vertex(x+stepx, y, 0, u+stepx, v);
          grid.vertex(x+stepx, y+stepy, 0, u+stepx, v+stepy);
          grid.vertex(x, y+stepy, 0, u, v+stepy);
          x+=stepx;
        }
        y+=stepy;
      }
      grid.endShape();
    }
  }

  // --------------------------------------------
  void draw()
  {
    if (tTransition <= 1.0)
      faceOSC.drawFrameSyphonZoom();
    
    if (img !=null)
    {
      createTextImage();
      createGrid();

      shader.set("displacementMap", displacementMap);
      shader.set("visage", img);
      shader.set("displacement", displacement);
      shader.set("alpha", tTransition);
      shader(shader);
      //      shape(grid, pos.x, pos.y, dim.x, dim.y);
      shape(grid, 0, 0, width, height);
      resetShader();
    }
  }
}

// ==================================================
// ==================================================
class ToolThibaut extends Tool
{  
  ToolThibaut(PApplet p)
  {
    super(p);
  }

  // --------------------------------------------------------------------
  public String getId()
  {
    return "__ToolThibaut__";
  }

  // --------------------------------------------------------------------
  void initControls()
  {
    SceneThibaut scene = (SceneThibaut) sceneManager.get("Thibaut_Maxime");
    
    initTab("thibaut", "Thibaut & Maxime");
    cp5.addSlider("displacement")
      .plugTo(scene).setValue(0.0).setRange(0, 1000).setLabel("displacement").moveTo("thibaut")
      .setWidth(200).setHeight(20).setPosition(toolManager.tabX, toolManager.tabY+30).linebreak();

    cp5.addSlider("textSize").addListener(this)
      .plugTo(scene).setValue(30).setRange(10, 100).setLabel("font size").moveTo("thibaut")
      .setWidth(400).setHeight(20).setPosition(toolManager.tabX, toolManager.tabY+60).linebreak();

    cp5.addSlider("textLeading").addListener(this)
      .plugTo(scene).setValue(30).setRange(10, 100).setLabel("font leading").moveTo("thibaut")
      .setWidth(400).setHeight(20).setPosition(toolManager.tabX, toolManager.tabY+90).linebreak();

    cp5.addToggle("bDoBlur")
      .plugTo(scene).setValue(scene.bDoBlur).setLabel("blur").moveTo("thibaut")
      .setWidth(20).setHeight(20).setPosition(toolManager.tabX, toolManager.tabY+120).linebreak();

    cp5.addSlider("blurLevel")
      .plugTo(scene).setValue(2).setRange(1, 4).setLabel("blur level").moveTo("thibaut")
      .setWidth(200).setHeight(20).setPosition(toolManager.tabX, toolManager.tabY+150).linebreak();
}

  // --------------------------------------------------------------------
  void controlEvent(ControlEvent theEvent) 
  {
    SceneThibaut scene = (SceneThibaut) sceneManager.get("Thibaut_Maxime");
    //    if (scene.bSetup) {
    scene.bCreateText = true;
//    scene.createTextImage();
    //    }
  }
}