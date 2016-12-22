class AgentTSP extends AgentInterface
{
  TSP tsp;
  float threshold = 70.0;

  // --------------------------------------------
  AgentTSP(PImage img_)
  {
    this.img = img_;
    this.tsp = new TSP();
  }

  // --------------------------------------------
  void compute()
  {
    nbPositions = 0;
    tsp.applyTSP(applyBrightness(threshold));
    
    int nbPoints = tsp.SAVED_PNTS.size();
    if (nbPoints > 0)
    {
      this.positions = new PVector[nbPoints];
      tsp.SAVED_PNTS.toArray(this.positions);
      this.nbPositions = nbPoints;
    }
  }

  // --------------------------------------------
  ArrayList<PVector> applyBrightness(float _thresh) 
  {
    if (this.img !=null)
    {
      ArrayList<PVector> points = new ArrayList<PVector>();
      img.loadPixels();
      int x,y,pos;
      float pixelBright;
      for (y = 0; y <img.height; y++) {
        for (x = 0; x <img.width; x++) { 
          pos = (y * img.width) + x;
          pixelBright = brightness(img.pixels[pos]);
          if (pixelBright < _thresh) {
            PVector point = new PVector(x, y);        
            points.add( point );
          }
        }
      }
      return points;
    }
    return null;
  }
}