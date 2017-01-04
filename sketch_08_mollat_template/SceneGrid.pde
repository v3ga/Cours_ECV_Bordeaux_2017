// ==================================================
class GridCell
{
  int i, j;  
  int wGrid, hGrid;  
  int value;
  float alpha, alphaTarget;
  float timeReveal=0.0, timeRevealFactor=0.9;
  float time=0.0;

  // --------------------------------------------
  GridCell(int i_, int j_, int wGrid_, int hGrid_)
  {
    this.i = i_;
    this.j = j_;
    this.wGrid = wGrid_;
    this.hGrid = hGrid_;
    reset();
  }

  // --------------------------------------------
  void reset()
  {
    this.value = 0;
    this.alpha = this.alphaTarget = 0.0;
    this.time = 0.0;
    this.timeReveal = computeTimeReveal();
  }

  // --------------------------------------------
  float computeTimeReveal()
  {
    //return noise(float(i)*0.01, float(j)*0.01);
    //return random(0.0f, 0.7f);
    return dist(i, j, wGrid/2, hGrid/2)/max(wGrid, hGrid)*2;
  }

  // --------------------------------------------
  void update(float dt)
  {
    this.time+=dt;
    if (this.time >= this.timeReveal) {
      this.alphaTarget = 255.0;
    }
    this.alpha = float_relax(this.alpha, this.alphaTarget, dt, timeRevealFactor);
  }
}

// ==================================================
class SceneGrid extends Scene
{
  GridCell[][] m_grid;
  float m_cellw, m_cellh;
  int m_gridw, m_gridh;
  int m_iOver, m_jOver;
  float cellTimeRevealFactor;
  boolean bGridChanged = false;
  int imageDivider=4;

  // --------------------------------------------
  SceneGrid(String name)
  {
    super(name);
    m_gridw = m_gridh = 0;
    m_cellw = m_cellh = 0;
  }

  // --------------------------------------------
  void initGridCell(GridCell gc)
  {
    PImage imageVisageCompute = faceOSC.getImageVisageCompute();
    int w = imageVisageCompute.width;
    int h = imageVisageCompute.height;

    if (gc.i<w/2)
    {
      gc.value = gc.j<h/2 ? 1 : 0;
    } else
    {
      gc.value = gc.j<h/2 ? 0 : 1;
    }
  }

  // --------------------------------------------
  void resetGrid()
  {
    int i, j;
    for (i=0; i<m_gridw; i++)
      for (j=0; j<m_gridh; j++)
      {
        m_grid[i][j].reset();
        m_grid[i][j].timeRevealFactor = cellTimeRevealFactor;
      }
  }

  // --------------------------------------------
  void setGridChanged(int divider)
  {
    bGridChanged = true;
    imageDivider = divider;
  }

  // --------------------------------------------
  void setCellTimeRevealFactor(float factor)
  {
    this.cellTimeRevealFactor = factor;

    if (m_grid == null) return;

    int i, j;
    for (i=0; i<m_gridw; i++)
      for (j=0; j<m_gridh; j++)
      {
        m_grid[i][j].timeRevealFactor = factor;
      }
  }

  // --------------------------------------------
  void onBeginAnimation()
  {
    super.onBeginAnimation();
    resetGrid();
  }

  // --------------------------------------------
  void onTerminateAnimation()
  {
    super.onTerminateAnimation();
    resetGrid();
  }

  // --------------------------------------------
  void onNewFrame()
  {
      PImage imageVisageCompute = faceOSC.getImageVisageCompute();
    if (bGridChanged && imageVisageCompute!=null)
    {
        

      imageVisageCompute.resize( faceOSC.imageVisageWidth / imageDivider, faceOSC.imageVisageHeight / imageDivider );

      m_gridw = imageVisageCompute.width;
      m_gridh = imageVisageCompute.height;

      m_cellw = width / m_gridw;
      m_cellh = height / m_gridh;

        println("-- creating grid ("+m_gridw+","+m_gridh+")");
        bGridChanged  = false;
        m_grid = new GridCell[m_gridw][m_gridh];

        int i, j;
        for (i=0; i<m_gridw; i++)
          for (j=0; j<m_gridh; j++)
          {
            GridCell gc = new GridCell(i, j, m_gridw, m_gridh);
            m_grid[i][j] = gc;

            initGridCell(gc);
          }
    }
  }

  // --------------------------------------------
  void update()
  {
    super.update();

    // Grid is set
    if (m_grid !=null)
    {
      if (bOnBeginAnimCalled)
      {
        int i, j;
        for (i=0; i<m_gridw; i++)
          for (j=0; j<m_gridh; j++)
          {
            m_grid[i][j].update(dt);
          }
      }
    }
  }

  // --------------------------------------------
  void drawGridCell(PImage imgFaceCompute, int i, int j)
  {
    if (imgFaceCompute != null && m_grid != null)
    {


      float alpha = m_grid[i][j].alpha;
      if (alpha < 2.0f)
        return;


      float b = brightness( imgFaceCompute.get(i, j) ) / 255.0;

      float xx = i*m_cellw;
      float yy = j*m_cellh;
      noStroke();
      fill(255, alpha);
      rect(xx, yy, m_cellw, m_cellh);

      noFill();
      stroke(0, alpha);
      strokeWeight( map(b, 0, 1, 8, 1) );

      if (m_grid[i][j].value == 0)
      {
        line(xx, yy, xx+m_cellw, yy+m_cellh);
      } else if (m_grid[i][j].value == 1)
      {
        line(xx+m_cellw, yy, xx, yy+m_cellh);
      }
    }
  }

  // --------------------------------------------
  void draw()
  {
    faceOSC.drawFrameSyphonZoom();    

    if (faceOSC.isFound())
    {
      PImage imageVisageCompute = faceOSC.getImageVisageCompute();
      if (imageVisageCompute != null)
      {
        imageVisageCompute.loadPixels();

        pushStyle();
        fill(0);

        m_cellw = float(width) / float(imageVisageCompute.width);
        m_cellh = float(height) / float(imageVisageCompute.height);

        int i, j;
        for (j = 0; j < imageVisageCompute.height; j++) 
        {
          for (i = 0; i < imageVisageCompute.width; i++) 
          {
            drawGridCell(imageVisageCompute, i, j);
          }
        }

        popStyle();
      }

      if (__DEBUG__)
      {
        drawGrid(m_cellw, m_cellh);
        drawCellOver();
      }
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
      //      m_grid[m_iOver][m_jOver] = m_grid[m_iOver][m_jOver] == 0 ? 1 : 0;
    }
  }
}