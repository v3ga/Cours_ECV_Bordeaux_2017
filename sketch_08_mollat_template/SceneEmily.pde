// ==================================================
// ==================================================
class SceneEmily extends SceneGridSVG
{
  float imageSize = 4;

  // --------------------------------------------
  SceneEmily(String name)
  {
    super(name);
  }

  // --------------------------------------------
  void setup()
  {
    loadImageShapes();
  }

  // --------------------------------------------
/*  void drawGridCell(PImage imgFaceCompute, int i, int j)
  {
    // get current color
    color c = imgFaceCompute.pixels[j*imgFaceCompute.width+i];

    // greyscale conversion
    int greyscale = round(red(c)*0.222+green(c)*0.707+blue(c)*0.071);

    int gradientToIndex = round(map(greyscale, 0, 255, shapeCount-1, 0));
    image(imageShapes[gradientToIndex], float(i)*m_cellw, float(j)*m_cellh, m_cellw, m_cellh);
  }
*/
}


// ==================================================
// ==================================================
class ToolEmily extends Tool
{  
  ToolEmily(PApplet p)
  {
    super(p);
  }

  // --------------------------------------------------------------------
  public String getId()
  {
    return "__ToolEmily__";
  }


  // --------------------------------------------------------------------
  void initControls()
  {
    initTab("emily", "Emily & Anna");

    cp5.addSlider("imageSize").addListener(this).plugTo(sceneManager.get("Emily_Anna")).moveTo("emily")
      .setPosition(4, 30).setWidth(200).setHeight(20)
      .setRange(2, 8).setValue(128)
      .setNumberOfTickMarks(7)
      .setSliderMode(Slider.FLEXIBLE);
  }

  // --------------------------------------------------------------------
  void controlEvent(ControlEvent e)
  {
    SceneEmily scene = (SceneEmily) sceneManager.get("Emily_Anna");
    faceOSC.setImageVisageComputeWidth( (int)(faceOSC.imageVisageWidth / scene.imageSize  ));
  }
}