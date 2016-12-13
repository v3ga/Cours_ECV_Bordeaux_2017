// ==================================================
// ==================================================
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
      for (int i = 0; i < contents.length; i++) 
      {
        // skip hidden files and folders starting with a dot, load .svg files only
        if (contents[i].charAt(0) == '.') continue;
        else if (contents[i].toLowerCase().endsWith(".svg")) 
        {
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

 
}