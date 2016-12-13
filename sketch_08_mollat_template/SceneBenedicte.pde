// ==================================================
// ==================================================
class SceneBenedicte extends SceneGridSVG
{

  // --------------------------------------------
  SceneBenedicte(String name)
  {
    super(name);
  }

 // --------------------------------------------
  void drawGridCell(PImage imgFaceCompute, int i, int j)
  {
      // get current color
      color c = imgFaceCompute.pixels[j*imgFaceCompute.width+i];
      // greyscale conversion
      int greyscale = round(red(c)*0.222+green(c)*0.707+blue(c)*0.071);

      m_cellw = width / imgFaceCompute.width;
      m_cellh = height / imgFaceCompute.height;
    
      int gradientToIndex = round(map(greyscale, 0,255, 0,shapeCount-1));
      shape(shapes[gradientToIndex], i*m_cellw,j*m_cellh, m_cellw,m_cellh);
  
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
  // --------------------------------------------------------------------
  void initControls()
  {
    initTab("benedicte", "Benedicte & Alice");
  }
}