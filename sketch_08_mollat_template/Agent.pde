class AgentInterface
{
  // --------------------------------------------
  PVector[] positions;
  int nbPositions = 0;
  AgentTraveller[] travellers;
  PImage img;

  // --------------------------------------------
  void compute() {
  }

  // --------------------------------------------
  void begin(int nbTravellers)
  {
    println("------------------------------");
    int nbPosPerTraveller = nbPositions / nbTravellers ;
    int nbPosPerTravellerRest = nbPositions - nbPosPerTraveller * nbTravellers;

    if (nbPosPerTravellerRest>=5)
      nbTravellers += 1;

    println("agent.nbPositions ="+nbPositions );
    println("nbTravellers="+nbTravellers);
    println("nbPosPerTraveller="+nbPosPerTraveller);
    println("nbPosPerTravellerRest="+nbPosPerTravellerRest);

    travellers = new AgentTraveller[nbTravellers];
    int posIndex=0, posIndexBegin=0, posIndexEnd=0;
    for (int i=0; i<nbTravellers; i++)
    {

      posIndexBegin = posIndex;
      posIndexEnd = min(posIndex+nbPosPerTraveller-1, this.nbPositions-1);

      println("--  ="+i);
      println("posIndexBegin="+posIndexBegin);
      println("posIndexEnd="+posIndexEnd);


      travellers[i] = new AgentTraveller(this, posIndexBegin, posIndexEnd);
      posIndex+=nbPosPerTraveller;
    }

    for (int i=0; i<travellers.length; i++) travellers[i].begin();
  }
  
  // --------------------------------------------
  void update(float dt) 
  {
    for (int i=0; i<travellers.length; i++)
    {
      travellers[i].update(dt);
    }
  }

  // --------------------------------------------
  void draw() 
  {
    for (int i=0; i<travellers.length; i++)
    {
      travellers[i].draw();
    }
  }

  // --------------------------------------------
  void drawDirect() {
  }
}

class Agent extends AgentInterface
{
  //  BlobDetection theBlobDetection;
  boolean[] visited;
  PImage imgVisited;

  // --------------------------------------------
  Agent(PImage img_)
  {
    this.positions = new PVector[4000];

    this.img = img_;
    this.imgVisited = this.img.copy();
    this.visited = new boolean[img.width * img.height];
    for (int i=0; i<this.visited.length; i++) this.visited[i] = false;
  }

  // --------------------------------------------
  void compute()
  {
    /*    theBlobDetection = new BlobDetection(img.width, img.height);
     theBlobDetection.setPosDiscrimination(false);
     theBlobDetection.setThreshold(0.7f);
     theBlobDetection.computeBlobs(img.pixels);
     */
    nbPositions = 0;
    for (int i=0; i<positions.length; i++)
    {
      //      println("—— positions "+i);
      if (i == 0 || positions[i-1] !=null)
      {
        positions[i] = findDestinationPixelFrom(i==0 ? new PVector(img.width/2, img.height/2) : positions[i-1], 4);
        nbPositions++;
      }
    }
  }

  // --------------------------------------------
  void drawDirect()
  {
    //    drawBlobsAndEdges(theBlobDetection, false, true);
    pushMatrix();
    float w = float(width) / float(img.width);
    float h = float(height) / float(img.height);
    PVector A, B;
    translate(w/2, h/2);
    for (int i=0; i<positions.length-1; i++)
    {
      A = positions[i];
      B = positions[i+1];
      if (B == null) break;
      line(A.x*w, A.y*h, B.x*w, B.y*h);
    }    
    popMatrix();
  }

  // --------------------------------------------
  PVector findDestinationPixelFrom(PVector pos, float radius)
  {
    PVector posDest = new PVector();
    float x = pos.x;
    float y = pos.y;

    img.loadPixels();


    boolean found = false;
    int nbAttempts = 0;
    while (!found && nbAttempts < 10)
    {
      float dx = 0;
      float dy = 0;
      float angle = 0;
      int xx = 0;
      int yy = 0;
      color c;
      int nbAttemptsDest = 120;
      for (int i=0; i<nbAttemptsDest; i++)
      {
        angle = random(TWO_PI);
        //        int guess = (int)random(10.2);
        //        angle = guess * PI/10;

        dx = radius * cos(angle);
        dy = radius * sin(angle);
        //        dx = random(-radius,radius);
        //        dy = random(-radius,radius);

        xx = int(x+dx);
        yy = int(y+dy);

        if (xx < 0 || x>=img.width || yy<0 || y>=img.height) {
          continue;
        } else {
          c = img.get(xx, yy);
          if (red(c)>100 && !visited[xx + yy*img.width])
          {
            found = true;
            posDest.set( xx, yy );
            visited[xx + yy*img.width] = true;
            imgVisited.set(xx, yy, color(0));
            //            println("found ! attempt = "+i);
            break;
          }
        }
      }
      if (!found)
      {
        radius += 4;
        nbAttempts++;
      }
    }

    if (!found)
      return null;

    return posDest;
  }
}