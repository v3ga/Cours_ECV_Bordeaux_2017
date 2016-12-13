// ==================================================
// ==================================================
class SceneBenedicte extends SceneGridSVG
{
  float imageSize = 4;

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
    // get current color
    color c = imgFaceCompute.pixels[j*imgFaceCompute.width+i];

    // greyscale conversion
    int greyscale = round(red(c)*0.222+green(c)*0.707+blue(c)*0.071);

    int gradientToIndex = round(map(greyscale, 0, 255, 0, shapeCount-1));
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

    cp5.addSlider("imageSize").addListener(this).plugTo(sceneManager.get("Benedicte_Alice"))
      .moveTo("benedicte")
      .setPosition(4, 30)
      .setWidth(200)
      .setRange(2, 8) // values can range from big to small as well
      .setValue(128)
      .setNumberOfTickMarks(7)
      .setSliderMode(Slider.FLEXIBLE)
      ;
  }

  // --------------------------------------------------------------------
  void controlEvent(ControlEvent e)
  {
    SceneBenedicte scene = (SceneBenedicte) sceneManager.get("Benedicte_Alice");
    faceOSC.setImageVisageComputeWidth( (int)(faceOSC.imageVisageWidth / scene.imageSize  ));
  }
}