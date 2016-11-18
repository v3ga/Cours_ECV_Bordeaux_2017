class SceneGridSVG extends SceneGrid
{
  PShape[] shapes;
  int shapeCount = 0;

  // --------------------------------------------
  SceneGridSVG(String name)
  {
    super(name);
  }

  // --------------------------------------------
  void loadShapes()
  {
    File dir = new File(sketchPath(""), this.pathData);
    println( dir );
    if (dir.isDirectory()) {
      String[] contents = dir.list();
      shapes = new PShape[contents.length]; 
      for (int i = 0; i < contents.length; i++) {
        // skip hidden files and folders starting with a dot, load .svg files only
        if (contents[i].charAt(0) == '.') continue;
        else if (contents[i].toLowerCase().endsWith(".svg")) {
          File childFile = new File(dir, contents[i]);
          println(childFile.getPath());        
          shapes[shapeCount] = loadShape(childFile.getPath());
          shapeCount++;
        }
      }
    }
  }

  // --------------------------------------------
  void setup()
  {
    loadShapes();
  }

  // --------------------------------------------
/*  void drawGridCell(PImage imgFaceCompute, int i, int j)
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
*/
}