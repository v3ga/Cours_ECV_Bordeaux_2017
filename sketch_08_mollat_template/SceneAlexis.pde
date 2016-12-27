// ==================================================
// ==================================================
class SceneAlexis extends Scene
{
  PImage visage;
  PImage visageBig;
  AgentInterface agent;

  float tAlphaFrameSyphon = 1.0f, tAlphaFrameSyphonTarget=1.0f;
  float tAlphaVisage = 0.0f, tAlphaVisageTarget=0.0f;
  float tAlphaAgent = 0.0f, tAlphaAgentTarget=0.0f;

  // --------------------------------------------
  SceneAlexis(String name)
  {
    super(name);
  }

  // --------------------------------------------
  void update()
  {
    super.update();

    tAlphaFrameSyphon = float_relax(tAlphaFrameSyphon, tAlphaFrameSyphonTarget, dt, 0.5f);
    tAlphaVisage = float_relax(tAlphaVisage, tAlphaVisageTarget, dt, 0.5f);
    tAlphaAgent = float_relax(tAlphaAgent, tAlphaAgentTarget, dt, 0.2f);

    if (faceOSC.hasStateChanged() && faceOSC.state != FaceOSC.STATE_ZOOMED)
    {
      tAlphaFrameSyphonTarget = 1.0f;
      tAlphaVisageTarget = 0.0f;
      tAlphaAgentTarget = 0.0f;
    }

    if (agent !=null)
    {
      agent.update(dt);
    }
  }

  // --------------------------------------------
  void onBeginAnimation()
  {
    tAlphaFrameSyphonTarget = 0.0f;
    tAlphaVisageTarget = 1.0f;           
    tAlphaAgentTarget = 1.0f;

    visageBig = faceOSC.getImageVisage().copy();
    visage = faceOSC.getImageVisageCompute().copy();
    //      visage.filter(GRAY);
    //      visage.filter(INVERT);
    //      visage.filter(THRESHOLD, 0.8);

    //      agent = new AgentTSP(visage);
    agent = new Agent(visage);
    agent.compute();
    agent.begin(10);
  }

  // --------------------------------------------
  void draw()
  {
    pushStyle();

    if (tAlphaFrameSyphon>0.1f)
    {
      tint(255, 255.0*tAlphaFrameSyphon);
      faceOSC.drawFrameSyphonZoom();
    }

    if (visageBig != null)
    {
      tint(255, map(tAlphaVisage, 0, 1, 0, 100));
      image(visageBig, 0, 0, width, height);
    }

    if (agent !=null && tAlphaAgent>0.1f)
    {
      stroke(255, 180*tAlphaAgent);
      agent.draw();
    }

    if (visage != null)
    {
      image(visage, 0, height-2*visage.height, visage.width*2, visage.height*2);
    }
    popStyle();
  }
}

// ==================================================
// ==================================================
class ToolAlexis extends Tool
{  
  ToolAlexis(PApplet p)
  {
    super(p);
  }

  // --------------------------------------------------------------------
  public String getId()
  {
    return "__ToolAlexis__";
  }

  // --------------------------------------------------------------------
  void initControls()
  {
    initTab("alexis", "Alexis & Max");
  }
}