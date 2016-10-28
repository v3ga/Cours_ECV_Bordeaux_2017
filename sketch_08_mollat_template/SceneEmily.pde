class SceneEmily extends Scene
{
  int[][] grid;


  // --------------------------------------------
  SceneEmily()
  {
    super("SceneEmily");
  }

  // --------------------------------------------
  void update()
  {
    if (grid == null)
    {
      PImage imageVisageCompute = faceOSC.getImageVisageCompute();
      int w = imageVisageCompute.width;
      int h = imageVisageCompute.height;
      grid = new int[w][h];

      for (int i=0; i<w; i++)
        for (int j=0; j<h; j++)
        {
          grid[i][j] = (int)random(2);
        }
    }
  }

  // --------------------------------------------
  void draw()
  {
    PImage imageVisageCompute = faceOSC.getImageVisageCompute();
    if (imageVisageCompute != null)
    {
      imageVisageCompute.loadPixels();

      float xx = 0.0;
      float yy = 0.0;
      float b = 0.0;

      float stepx = width / imageVisageCompute.width;
      float stepy = height / imageVisageCompute.height;

      stroke(255);
      for (int y = 0; y < imageVisageCompute.height; y++) 
      {
        for (int x = 0; x < imageVisageCompute.width; x++) 
        {
          b = 1.0-brightness( imageVisageCompute.get(x, y) ) / 255.0;

          xx = x*stepx;
          yy = y*stepy;

          strokeWeight( map(b, 0,1, 8,1) );

          if (grid[x][y] == 0)
          {
            line(xx,yy,xx+stepx,yy+stepy);
          }
          else if (grid[x][y] == 1)
          {
            line(xx+stepx,yy,xx,yy+stepy);
          }

        }
      }
    }
  }
}