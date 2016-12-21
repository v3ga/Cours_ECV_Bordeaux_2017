// --------------------------------------------
float float_relax(float value,float target,float dt, float T)
{
  value += (target-value)*min(1.0f, dt/T);
  return value;
}


// --------------------------------------------
void drawGrid(float cellw, float cellh)
{
  pushStyle();
  stroke(200,0,0,50);
  for (float y=0; y < height; y = y+cellh)
  {
    line(0, y, width, y);
  }
  for (float x=0; x < width; x = x+cellw)
  {
    line(x, 0, x, height);
  }   
  popStyle();
}

// --------------------------------------------
class Timer
{
  float now = 0;
  float before = 0;
  float dt = 0;

  Timer()
  {
    now = before = millis()/1000.0f;
  }

  float dt()
  {
    now = millis()/1000.0f;
    dt = now - before;
    before = now;
    return dt;
  }

}


// --------------------------------------------
class Triangle 
{
  PVector a;
  PVector b;
  PVector c;
}

// --------------------------------------------
class BoundingBox
{
  PVector position = new PVector();
  PVector dimension = new PVector();
  PVector center = new PVector();

  BoundingBox copy()
  {
    BoundingBox bounding = new BoundingBox();
    bounding.position.set(this.position);
    bounding.dimension.set(this.dimension);
    bounding.center.set(this.center);

    return bounding;
  }

  void compute(PVector[] points)
  {
    float xmin = 10000;
    float xmax = -10000;
    float ymin = 10000;
    float ymax = -10000;

    PVector p;
    for (int i=0; i<points.length; i++) {
      p = points[i];
      if (p.x < xmin) xmin = p.x;
      if (p.x > xmax) xmax = p.x;
      if (p.y < ymin) ymin = p.y;
      if (p.y > ymax) ymax = p.y;
    }

    position.set(xmin, ymin);
    dimension.set(xmax-xmin, ymax-ymin);
    center.set(position.x+0.5*dimension.x, position.y+0.5*dimension.y);
  }

  void draw()
  {
    pushStyle();
    noFill();
    stroke(0, 200, 0);
    rect(position.x, position.y, dimension.x, dimension.y);
    ellipse(center.x, center.y, 5, 5);
    popStyle();
  }
}