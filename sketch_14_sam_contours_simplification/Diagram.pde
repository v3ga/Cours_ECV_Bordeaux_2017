/*
 * Displays a join the dot diagram
 */


class DotDiagram {
  ArrayList<PVector> SIMPLE_PNTS; // original points
  ArrayList<PVector> FILTER_PNTS; // filtered points
  

  DotDiagram() {
    SIMPLE_PNTS = new ArrayList<PVector>();
  }

  /*
   * Grab points
   */
  void setDiagramPoints(ArrayList<PVector> _pnts) {    
    SIMPLE_PNTS = _pnts;
  }

  void compute(int _step, int _mult, String _type)
  {
    if(SIMPLE_PNTS == null || SIMPLE_PNTS.size() == 0) return;
    
    if (_type.equals("SIMPLE")) {
    FILTER_PNTS = SIMPLIFY_POLY(SIMPLE_PNTS, _step, SIMPLE_PNTS.size()/20);
    }else if(_type.equals("RADIAL")) {
    FILTER_PNTS = simplifyRadialDist(SIMPLE_PNTS, _step * _mult); //(_mult was 10)
    }else if(_type.equals("PEUCKER")) {
    FILTER_PNTS = simplifyDouglasPeucker(SIMPLE_PNTS, _step * 10);
    }
  
  }

  /*
   * Displays diagram
   * @param _t is step for num of vertices
   * @param _tMax is threshold limit for line drawing
   * @param _isDots for showing dots + numbers
   */
  void displayDotDiagram(float _tMax, boolean _isDots, boolean _isDotsNum) {
    if(FILTER_PNTS == null ) return;
    

    for (int i=0; i<FILTER_PNTS.size () - 1; i++) {
      PVector p1 = FILTER_PNTS.get(i); 
      PVector p2 = FILTER_PNTS.get(i+1); 
      float d = calculateDistance(p1, p2); 

      if (d<_tMax) {
        //stroke(0, 255, 255);
        stroke(300,100,100);
        line(p1.x, p1.y, p2.x, p2.y);
      }
      if (_isDots) {
        noStroke(); 
          fill(50, 100, 100); 
        if (_isDotsNum)
        {
          textSize(8); 
          text(i, p1.x-15, p1.y); 
        }
//        fill(255, 0, 0); 
        ellipse(p1.x, p1.y, 6, 6);
      }
    }
  }

  // square distance between 2 points
  public float getSqDist(PVector p1, PVector p2) {
    float dx = p1.x - p2.x, 
      dy = p1.y - p2.y;
    return dx * dx + dy * dy;
  }

  // square distance from a point to a segment
  public float getSqSegDist(PVector p, PVector p1, PVector p2) {
    float x = p1.x, 
      y = p1.y, 
      dx = p2.x - x, 
      dy = p2.y - y;
    if (dx != 0 || dy != 0) {
      float t = ((p.x - x) * dx + (p.y - y) * dy) / (dx * dx + dy * dy);
      if (t > 1) {
        x = p2.x;
        y = p2.y;
      } else if (t > 0) {
        x += dx * t;
        y += dy * t;
      }
    }
    dx = p.x - x;
    dy = p.y - y;
    return dx * dx + dy * dy;
  }

  // basic distance-based simplification
  public ArrayList<PVector> simplifyRadialDist(ArrayList<PVector> points, float sqTolerance) {
    PVector prevPoint = points.get(0);
    ArrayList<PVector> newPoints = new ArrayList<PVector>();
    newPoints.add(prevPoint);
    PVector point = new PVector();
    for (int i = 1, len = points.size (); i < len; i++) {
      point = points.get(i);

      if (getSqDist(point, prevPoint) > sqTolerance) {
        newPoints.add(point);
        prevPoint = point;
      }
    }
    if (prevPoint.x != point.x && prevPoint.y != point.y) newPoints.add(point);
    return newPoints;
  }

  public void simplifyDPStep(ArrayList<PVector> points, int first, int last, float sqTolerance, ArrayList<PVector> simplified) {
    float maxSqDist = sqTolerance;
    int index = 0;
    for (int i = first + 1; i < last; i++) {
      float sqDist = getSqSegDist(points.get(i), points.get(first), points.get(last));
      if (sqDist > maxSqDist) {
        index = i;
        maxSqDist = sqDist;
      }
    }
    if (maxSqDist > sqTolerance) {
      if (index - first > 1) simplifyDPStep(points, first, index, sqTolerance, simplified);
      simplified.add(points.get(index));
      if (last - index > 1) simplifyDPStep(points, index, last, sqTolerance, simplified);
    }
  }


  // simplification using Ramer-Douglas-Peucker algorithm
  public ArrayList<PVector> simplifyDouglasPeucker(ArrayList<PVector> points, float sqTolerance) {
    int last = points.size() - 1;
    ArrayList<PVector> simplified = new ArrayList<PVector>();
    simplified.add(points.get(0));
    simplifyDPStep(points, 0, last, sqTolerance, simplified);
    simplified.add(points.get(last));
    return simplified;
  }

  /**
   *  
   * returns a new simplified list of points, from a given pvector
   * author: thomas diewald
   *
   * @param polyline to simplify
   * @param step    the number of vertices in a row, that are checked for the maximum offset
   * @param max_offset maximum offset a vertice can have 
   * @return new simplified polygon
   */
  public ArrayList<PVector> SIMPLIFY_POLY(  ArrayList<PVector> polyline, int step, float max_offset ) {
    ArrayList<PVector> poly_simp = new ArrayList<PVector>(); 
    int index_cur  = 0; 
    int index_next = 0; 
    poly_simp.add(polyline.get(index_cur)); 

    while ( index_cur != polyline.size ()-1 ) {
      index_next = ((index_cur + step) >= polyline.size()) ? (polyline.size()-1) :  (index_cur + step); 

      PVector p_cur  = polyline.get(index_cur); 
      PVector p_next = polyline.get(index_next);

      while ( (++index_cur < index_next) &&  (max_offset > abs(distancePoint2Line(p_cur, p_next, polyline.get(index_cur))) ) ); 
      poly_simp.add(polyline.get(index_cur));
    }
    return poly_simp;
  }

  /**
   * author: thomas diewald
   * returns the shortest distance of a point(p3) to a line (p1-p2)
   */

  public float distancePoint2Line(PVector p1, PVector p2, PVector p3 ) {
    float x1 = p2.x-p1.x, y1 = p2.y-p1.y; 
    if ( x1 == 0 && y1 == 0)
      return 0; 
    float x2 = p3.x-p1.x, y2 = p3.y-p1.y; 
    if ( x2 == 0 && y2 == 0)
      return 0; 
    float A = x1*y2 - x2*y1; 
    if ( A == 0)
      return 0; 
    float p1p2_mag = (float)Math.sqrt(x1*x1 + y1*y1); 
    return A/p1p2_mag;
  }
}

// does what it says ;–)
float calculateDistance(PVector _last, PVector _target) {
  float d = _last.dist( _target );
  return d;
}