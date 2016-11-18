class SceneMycelium extends Scene
{
  ArrayList cells;
  ArrayList newcells;  

  float food[][];
  boolean started = false;
  PImage img;
  PGraphics offscreen;

  // --------------------------------------------
  SceneMycelium()
  {
    super("Mycelium");
  }

  // --------------------------------------------
  void update()
  {
  }

  // --------------------------------------------
  void draw()
  {
    faceOSC.drawFrameSyphonZoom();    

    if (faceOSC.state == FaceOSC.STATE_ZOOMED)
    {
      if (!started)
      {
        started = true;
        saveFrame(this.pathData+"face.jpg");
        startMycelium();
      }
      else
      {
        
      }
    }
  }

  // --------------------------------------------
  void startMycelium()
  {
    img = loadImage(this.pathData+"face.jpg");
    food = new float[width][height];
    for (int x = 0; x < width; ++x)
      for (int y = 0; y < height; ++y) {
        food[x][y] = ((img.pixels[(x+y*width)] >> 8) & 0xFF)/255.0;
      }
    cells = new ArrayList();
    newcells = new ArrayList();
    Cell c = new Cell();
    c.xpos = width/2;
    c.ypos = height/4;
    cells.add(c);
  }

  // --------------------------------------------
  float feed(int x, int y, float thresh) 
  {
    float r = 0.0;
    if (x >= 0 && x < width && y >= 0 && y < height) {
      if (food[x][y] > thresh) {
        r = thresh;
        food[x][y] -= thresh;
      } else {
        r = food[x][y];
        food[x][y] = 0.0;
      }
    }
    return r;
  }

  // --------------------------------------------
  class Cell 
  {
    float xpos, ypos;
    float dir;
    float state;

    Cell() 
    {
      xpos = random(width);
      ypos = random(height);
      dir = random(2*PI);
      state = 0;
    }

    // --------------------------------------------
    Cell(Cell c) 
    {
      xpos = c.xpos;
      ypos = c.ypos;
      dir = c.dir;
      state = c.state;
    }

    // --------------------------------------------
    void draw(boolean inverted)
    {
      if (state > 0.001 && xpos >= 0 && xpos < width && ypos >= 0 && ypos < height) {
        if (inverted) {
          pixels[ int(xpos) + int(ypos) * width ] = color(0, 0, 0);
        } else {
          pixels[ int(xpos) + int(ypos) * width ] = color(255, 255, 255);
        }
      }
    }

    // --------------------------------------------
    void update()
    {
      state += feed(int(xpos), int(ypos), 0.3) - 0.295;
      xpos += cos(dir);
      ypos += sin(dir);
      dir += random(-PI/4, PI/4);
      if (state > 0.15 && cells.size() < 100) 
      {
        divide();
      } else
        if (state < 0) {
          xpos += random(-15, +15);
          ypos += random(-15, +15);
          state = 0.001;
        }
    }

    // --------------------------------------------
    void divide() 
    {
      state /= 2;
      Cell c = new Cell(this);
      float dd = random(PI/4);
      dir += dd;
      c.dir -= dd;
      newcells.add(c);
    }
  }
}