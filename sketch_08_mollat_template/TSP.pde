class TSP {

  ArrayList<PVector> PNTS;
  ArrayList<PVector> SAVED_PNTS;
  boolean SAVE_POINTS;

  TSP() {
    PNTS = new ArrayList<PVector>();
    SAVED_PNTS = new ArrayList<PVector>();
    SAVE_POINTS = false;
  }

  /*
   * Method for applying nearest neighbour and saving data
   * @param _pnts is the list of PVector points to apply TSP
   */
  void applyTSP(ArrayList<PVector> _pnts) {
    PNTS = _pnts;
    SAVED_PNTS = new ArrayList<PVector>();
    PVector tempPosition = new PVector(PNTS.get(0).x, PNTS.get(0).y);
    for (int i=0; i<PNTS.size ()-1; i++) {

      // Get nearest neighbour as an index
      int nearestIndex = getNearestNeighbour(tempPosition, PNTS);
      SAVED_PNTS.add( tempPosition );

      // update temp position 
      tempPosition = new PVector(PNTS.get(nearestIndex).x, PNTS.get(nearestIndex).y);
      PNTS.remove(nearestIndex);
    }
  }

  /*
   * Displays the path calculated by TSP
   */

  void displayPath(float _s) {
    strokeWeight(_s);    
    stroke(200, 0, 255);
    for (int i=0; i<SAVED_PNTS.size ()-1; i++) {
      PVector p = SAVED_PNTS.get(i);
      PVector p2 = SAVED_PNTS.get(i+1);
      line(p.x, p.y, p2.x, p2.y);
    }
  }

  void displayPointsInPath(float _s, String _type) {

    for (int i=0; i<SAVED_PNTS.size ()-1; i++) {
      PVector p = SAVED_PNTS.get(i);
      if (_type.equals("FILL")) {
        noStroke();
        fill(255, 200, 0);
        ellipse(p.x, p.y, _s, _s);
      }
      if (_type.equals("NO_FILL")) {
        strokeWeight(1);
        noFill();
        stroke(255, 200, 0);
        ellipse(p.x, p.y, _s, _s);
      }
    }
  }


  /*
 * Returns index for the next closest point from a PVector
   * @param _currentPnt is the current PVector
   * @param _pnts is a list of points from which to check
   */

  int getNearestNeighbour(PVector _currentPnt, ArrayList _pnts) {
    float bestDistance = 50000; //arbitrary large value
    int bestIndex = 0;

    for (int i = 0; i<_pnts.size (); ++i) {
      PVector testPos = (PVector) _pnts.get(i);
      float d2 = PVector.dist(_currentPnt, testPos);
      if (d2 < bestDistance) {
        bestDistance = d2;
        bestIndex = i;
      }
    }
    return bestIndex;
  }


  /*
   * Method for receiving an arrayList of PVector
   */
  void setPoints(ArrayList<PVector> _pnts) {
    PNTS = _pnts;
  }

  /*
   * Method for getting an arrayList of PVector
   */
  ArrayList<PVector> getPoints() {
    return PNTS;
  }
}