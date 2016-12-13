// ==================================================
// ==================================================
class SceneGrid extends Scene
{
  int[][] m_grid;
  float m_cellw, m_cellh;
  int m_iOver, m_jOver;

  // --------------------------------------------
  SceneGrid(String name)
  {
    super(name);
  }

  // --------------------------------------------
  void update()
  {
    PImage imageVisageCompute = faceOSC.getImageVisageCompute();
    if (imageVisageCompute != null)
    {
      m_cellw = width / imageVisageCompute.width;
      m_cellh = height / imageVisageCompute.height;

      int w = imageVisageCompute.width;
      int h = imageVisageCompute.height;

      if (m_grid == null /*|| ( m_grid.length != w*h  )*/)
      {
        m_grid = new int[w][h];

        for (int i=0; i<w; i++)
          for (int j=0; j<h; j++)
          {
            initGridCell(i, j);
          }
      }
    }
    
    updateAlphaBackground();
  }

  // --------------------------------------------
  void initGridCell(int i, int j)
  {
    PImage imageVisageCompute = faceOSC.getImageVisageCompute();
    int w = imageVisageCompute.width;
    int h = imageVisageCompute.height;

    if (i<w/2)
    {
      m_grid[i][j] = j<h/2 ? 1 : 0;
    }
    else
    {
      m_grid[i][j] = j<h/2 ? 0 : 1;
    }
  }



  // --------------------------------------------
  void drawGridCell(PImage imgFaceCompute, int i, int j)
  {
    if (imgFaceCompute != null)
    {

      float b = brightness( imgFaceCompute.get(i, j) ) / 255.0;

      float xx = i*m_cellw;
      float yy = j*m_cellh;

      strokeWeight( map(b, 0, 1, 8, 1) );

      if (m_grid[i][j] == 0)
      {
        line(xx, yy, xx+m_cellw, yy+m_cellh);
      } else if (m_grid[i][j] == 1)
      {
        line(xx+m_cellw, yy, xx, yy+m_cellh);
      }
    }
  }

  // --------------------------------------------
  void draw()
  {
    faceOSC.drawFrameSyphonZoom();    

    pushStyle();
    noStroke();
    fill(255, m_alphaBackground);
    rect(0, 0, width, height);
    popStyle();

    if (faceOSC.state == FaceOSC.STATE_ZOOMED)
    {
      PImage imageVisageCompute = faceOSC.getImageVisageCompute();
      if (imageVisageCompute != null)
      {
        imageVisageCompute.loadPixels();

        pushStyle();
        fill(0);
        for (int j = 0; j < imageVisageCompute.height; j++) 
        {
          for (int i = 0; i < imageVisageCompute.width; i++) 
          {
            drawGridCell(imageVisageCompute, i, j);
          }
        }

        popStyle();
      }

      drawGrid(m_cellw, m_cellh);
      drawCellOver();
    }
  }


  // --------------------------------------------
  void drawCellOver()
  {
    if (m_iOver > - 1 && m_jOver > -1)
    {
      pushStyle();
      noStroke();
      fill(200, 0, 0, 70);
      rect(m_iOver*m_cellw, m_jOver*m_cellh, m_cellw, m_cellh);
      popStyle();
    }
  }

  // --------------------------------------------
  void mouseMoved()
  {

    PImage imageVisageCompute = faceOSC.getImageVisageCompute();
    if (imageVisageCompute == null) return ;

    float xx, yy;
    m_iOver = -1;
    m_jOver = -1;
    for (int j = 0; j < imageVisageCompute.height; j++) 
    {
      yy = j*m_cellh;
      for (int i = 0; i < imageVisageCompute.width; i++) 
      {
        xx = i*m_cellw;
        if (mouseX >= xx && mouseX <= (xx+m_cellw) && mouseY >= yy && mouseY <= (yy+m_cellh))
        {
          m_iOver = i;
          m_jOver = j;
          break;
        }
      }
    }
  }

  // --------------------------------------------
  void mousePressed()
  {
    if (m_grid == null) return;
    
    if (m_iOver > - 1 && m_jOver > -1)
    {
      m_grid[m_iOver][m_jOver] = m_grid[m_iOver][m_jOver] == 0 ? 1 : 0;
    }
  }
}