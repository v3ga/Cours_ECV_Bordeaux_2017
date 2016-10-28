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
    for (int i=0;i<points.length;i++){
      p = points[i];
      if (p.x < xmin) xmin = p.x;
      if (p.x > xmax) xmax = p.x;
      if (p.y < ymin) ymin = p.y;
      if (p.y > ymax) ymax = p.y;
    }
    
    position.set(xmin,ymin);
    dimension.set(xmax-xmin,ymax-ymin);
    center.set(position.x+0.5*dimension.x, position.y+0.5*dimension.y);
  }

  void draw()
  {
    pushStyle();
    noFill();
    stroke(0,200,0);
    rect(position.x,position.y,dimension.x,dimension.y);
    ellipse(center.x,center.y,5,5);
    popStyle();
  }
}