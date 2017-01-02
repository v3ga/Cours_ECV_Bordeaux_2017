// ==================================================
// ==================================================
class SceneBenedicte extends SceneGridSVG
{
  float imageSizeBene = 4;

  // --------------------------------------------
  SceneBenedicte(String name)
  {
    super(name);
  }

  // --------------------------------------------
  void setup()
  {
    loadImageShapes();
  }


  // --------------------------------------------
  void drawGridCell(PImage imgFaceCompute, int i, int j)
  {
    if (m_grid == null) return;
    
    noStroke();
    fill(255,m_grid[i][j].alpha);
    rect(float(i)*m_cellw, float(j)*m_cellh, m_cellw, m_cellh);
    
    // get current color
    color c = imgFaceCompute.pixels[j*imgFaceCompute.width+i];
    // greyscale conversion
    int greyscale = round(red(c)*0.222+green(c)*0.707+blue(c)*0.071);
    int gradientToIndex = round(map(greyscale, 0, 255, 0, shapeCount-1));
    tint(255,m_grid[i][j].alpha);
    image(imageShapes[gradientToIndex], float(i)*m_cellw, float(j)*m_cellh, m_cellw, m_cellh);
  }
}


// ==================================================
// ==================================================
class ToolBenedicte extends Tool
{
  ToolBenedicte(PApplet p)
  {
    super(p);
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  public String getId()
  {
    return "__ToolBenedicte__";
  }

  // --------------------------------------------------------------------
  void initControls()
  {
    initTab("benedicte", "Benedicte & Alice");

    cp5.addSlider("imageSizeBene").addListener(this).plugTo(sceneManager.get("Benedicte_Alice")).moveTo("benedicte")
      .setPosition(toolManager.tabX, toolManager.tabY+30).setWidth(200).setHeight(20)
      .setRange(2, 8).setValue(128)
      .setNumberOfTickMarks(7)

    cp5.addSlider("timeRevealBene").addListener(this).moveTo("benedicte")
      .setPosition(toolManager.tabX, toolManager.tabY+60).setWidth(200).setHeight(20)
      .setRange(0.1, 1.0).setValue(0.9);

  }

  // --------------------------------------------------------------------
  void controlEvent(ControlEvent e)
  {
    SceneBenedicte scene = (SceneBenedicte) sceneManager.get("Benedicte_Alice");
    if (e.getName().equals("imageSizeBene"))
    {
      faceOSC.setImageVisageComputeWidth( (int)(faceOSC.imageVisageWidth / scene.imageSizeBene  ));
    }
    else if (e.getName().equals("timeRevealBene"))
    {
      scene.setCellTimeRevealFactor( e.getValue() );
    }
  }
}