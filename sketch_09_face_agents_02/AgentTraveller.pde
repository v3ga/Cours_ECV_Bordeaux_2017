class AgentTraveller
{
  Agent parent;
  int posIndexBegin, posIndexEnd, posIndex;
  Ani anim;
  float t;
  PVector A, B, P;
  PVector[] positions;

  float noiseOffset = random(100.0f);

  // --------------------------------------------
  AgentTraveller()
  {
  }
  
  // --------------------------------------------
  AgentTraveller(Agent parent_, int posIndexBegin_, int posIndexEnd_)
  {
    init(parent_,posIndexBegin_,posIndexEnd_);
  }

  // --------------------------------------------
  void init(Agent parent_, int posIndexBegin_, int posIndexEnd_)
  {
    this.parent = parent_;
    this.posIndexBegin = posIndexBegin_;
    this.posIndexEnd = posIndexEnd_;
  }
  
  // --------------------------------------------
  void begin()
  {
    positions = new PVector[parent.nbPositions];
    posIndex = 0;
    selectPoints();
    beginAni();
  }

  // --------------------------------------------
  void selectPoints()
  {
    A = parent.positions[posIndex+posIndexBegin].copy();
    A.x = map(A.x, 0, parent.img.width-1, 0, width);
    A.y = map(A.y, 0, parent.img.height-1, 0, height);

    B = parent.positions[posIndex+1+posIndexBegin].copy();
    B.x = map(B.x, 0, parent.img.width-1, 0, width);
    B.y = map(B.y, 0, parent.img.height-1, 0, height);

    P = A.copy();
  }

  // --------------------------------------------
  void beginAni()
  {
    t = 0.0;
    anim = new Ani(this, 0.01, "t", 1.0, Ani.EXPO_IN_OUT, "onEnd:animDone");
    anim.start();
  }

  // --------------------------------------------
  void update(float dt)
  {
    noiseOffset += 1.1*dt;

    PVector PP;
    for (int i=0; i<posIndex; i++)
    {
      PP = positions[i];
     PP.z = map(mouseX,0,width,0,300)*noise(PP.x*0.01+noiseOffset,PP.y*0.01+noiseOffset*1.2);
    }

    P = PVector.lerp(A, B, t);
  }

  // --------------------------------------------
  void animDone()
  {
    positions[posIndex] = A.copy();
    posIndex++;
    if ((posIndex+posIndexBegin) <= posIndexEnd)
    {
      selectPoints();
      beginAni();
    }
  }

  // --------------------------------------------
  void draw()
  {
    PVector AA, BB;
    for (int i=0; i<posIndex-1; i++)
    {
      AA = positions[i];
      BB = positions[i+1];
      line(AA.x, AA.y, BB.x, BB.y);
    }

    if (posIndex>0)
      line(positions[posIndex-1].x, positions[posIndex-1].y, A.x, A.y);

    line(A.x, A.y, P.x, P.y);
  }
}