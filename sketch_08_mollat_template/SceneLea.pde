// ==================================================
class ParticleLea
{
  // --------------------------------------------
  ParticleLea(VParticle vpart_, PShape shape_)
  {
    this.vpart = vpart_;
    this.shape = shape_;
    
    this.shape.resetMatrix();
  }
  
  VParticle vpart;
  PShape    shape;
}

// ==================================================
class SceneLea extends Scene
{
  VPhysics physics;
  BConstantForce force;
  int amount = 1000;
  PImage img;
  PVector pos;
  float scale;
  float distMin = 20.0f;
  float distMinCurrent = 0.0f;
  float alphaImageFace = 120;

  int DRAW_MODE_BUBBLES = 1;
  int DRAW_MODE_CONNEXIONS = 2;
  int drawMode = DRAW_MODE_CONNEXIONS;
  
  PShape particleShapeGroup;
  PImage particleImage;  

  ArrayList<ParticleLea> particles;

  // --------------------------------------------
  SceneLea(String name)
  {
    super(name);
  }

  // --------------------------------------------
  void setup()
  {
    particleImage = loadImage( getPathData("sprite.png") );
  }
  
  // --------------------------------------------
  void createPhysics()
  {
    if (physics == null && faceOSC.getImageVisage() != null)
    {
      PImage img = faceOSC.getImageVisage();
      physics = new VPhysics(new Vec(0, 0), new Vec(img.width, img.height));
      physics.setfriction(.3f);
      force = new BConstantForce(new Vec());
      physics.addBehavior(force);
      

      particles = new ArrayList<ParticleLea>();
      particleShapeGroup = createShape(GROUP);
      
      PShape particleShape;
      

      for (int i = 0; i < amount; i++) 
      {
        //val for arbitrary radius
        float rad = 5;//random(3, 8);
        //vector for position
        Vec pos = new Vec (random(rad, width-rad), random(rad, height-rad));
        float weight = rad;
        //create particle (Vec pos, mass, radius)
        VParticle particle = new VParticle(pos, weight, rad);
        //add Collision Behavior
        particle.addBehavior(new BCollision().setLimit(.14));
        //add particle to world
        physics.addParticle(particle);
        
        // For drawing
        particleShape = createParticleShape( particle );
        particleShapeGroup.addChild( particleShape );

        // Association physics <-> draw
        particles.add( new ParticleLea(particle,particleShape) );
    
      }
    }
  }

  // --------------------------------------------
  PShape createParticleShape(VParticle particle)
  {
    float partSize = particle.getRadius();
    
    PShape part = createShape();
    part.beginShape(QUAD);
    part.noStroke();
    part.texture(particleImage);
    part.normal(0, 0, 1);
    part.vertex(-partSize/2, -partSize/2, 0, 0);
    part.vertex(+partSize/2, -partSize/2, particleImage.width, 0);
    part.vertex(+partSize/2, +partSize/2, particleImage.width, particleImage.height);
    part.vertex(-partSize/2, +partSize/2, 0, particleImage.height);
    part.endShape();
    
    return part;
  }

  // --------------------------------------------
  void onBeginAnimation()
  {
    super.onBeginAnimation();
  }

  // --------------------------------------------
  void onTerminateAnimation()
  {
    super.onTerminateAnimation();
  }

  // --------------------------------------------
  void onNewFrame()
  {
    
  }

  // --------------------------------------------
  void update()
  {
    super.update();
    
    createPhysics();
    if (physics != null) 
    {
      physics.update();
      // force.setForce(new Vec(width*.5f-mouseX, height*.5f-mouseY).normalizeTo(.03f));
    }
    updateAlphaBackground();
    //    distMinCurrent = map(m_alphaBackground, 0, 255, 1, distMin);
    if (faceOSC.hasStateChanged() && faceOSC.state == FaceOSC.STATE_ZOOMED)
    {
      //      Ani.to(this,4.5,"distMinCurrent",distMin);
    }
    distMinCurrent=distMin;
  }

  // --------------------------------------------
  void beginDraw()
  {
    pos = faceOSC.posBoundingPortraitScreenZoom;
    scale = faceOSC.dimBoundingPortraitScreenZoom.x / float( img.width );

    pushStyle();
    pushMatrix();

    translate(pos.x, pos.y);
    scale(scale, scale);
  }

  // --------------------------------------------
  void endDraw()
  {
    popMatrix();
    popStyle();
  }

  // --------------------------------------------
  void draw()
  {
    img =  faceOSC.getImageVisage();
    if (img == null) return;

    tint( 255, map(m_alphaBackground, 0, 255, 255, alphaImageFace) );
    faceOSC.drawFrameSyphonZoom();

    if (drawMode == DRAW_MODE_BUBBLES)     drawPoints();
    else if (drawMode == DRAW_MODE_CONNEXIONS)     drawConnections();
  }

  // --------------------------------------------
  void drawPoints()
  {
//    beginDraw();
    img.loadPixels();

    int xImg=0;
    int yImg=0; 
    float b=0;
    float s=0;
    float d=0;
    color c;
    noStroke();
    float alpha = m_alphaBackground;


    VParticle p;
    PShape shape;
//    for (VParticle p : physics.particles) 
    for (ParticleLea part : particles)
    {
      p = part.vpart;
      shape = part.shape;
      
      xImg = (int) p.x;
      yImg = (int) p.y;
      c = img.get(xImg, yImg);
      d = p.getRadius()*2;
      b = brightness( c ) / 255.0;
//      s = map(b, 0, 1, 0.6*d, d);
      s = map(b, 0, 1, 0.6, 1.0);
      shape.setTint(color(255));
      shape.resetMatrix();
      shape.translate(scale*p.x,scale*p.y);
//      shape.scale(2);
//      shape.scale(6);
//      fill(c, alpha);
//      ellipse(p.x, p.y, s, s);
      shape(shape);
    }
    
    //shape(particleShapeGroup);

//    endDraw();
  }

  // --------------------------------------------
  void drawConnections()
  {
    beginDraw();
    img.loadPixels();

    int nbParticles = physics.particles.size();
    float d=0.0;
    float alpha = m_alphaBackground;

    beginShape(LINES);
    for (int i=0; i<nbParticles; i++)
    {
      VParticle pi = physics.particles.get(i);
      for (int j=i; j<nbParticles; j++)
      {
        VParticle pj = physics.particles.get(j);
        d = dist(pi.x, pi.y, pj.x, pj.y);
        if (d < distMinCurrent)
        {
          stroke( img.get( (int)pi.x, (int)pi.y), alpha);
          vertex(pi.x, pi.y);
          stroke( img.get( (int)pi.x, (int)pi.y), alpha );
          vertex(pj.x, pj.y);
        }
      }
    }
    endShape();
    endDraw();
  }

  // --------------------------------------------------------------------
  void keyPressed()
  {
    if (key == 'a') drawMode = DRAW_MODE_BUBBLES;
    else if (key == 'z') drawMode = DRAW_MODE_CONNEXIONS;
  }
}


// ==================================================
// ==================================================
class ToolLea extends Tool
{  
  ToolLea(PApplet p)
  {
    super(p);
  }

  // --------------------------------------------------------------------
  public String getId()
  {
    return "__ToolLea__";
  }

  // --------------------------------------------------------------------
  void initControls()
  {
    SceneLea scene = (SceneLea) sceneManager.get("Lea_Lea");

    initTab("lea", "Lea & Lea");
    cp5.addSlider("distMin")
      .plugTo(scene).setRange(3, 30).setValue(20)
      .setLabel("distance").moveTo("lea").setWidth(200).setHeight(20).setPosition(4, 30).linebreak();

    cp5.addSlider("alphaImageFace")
      .plugTo(scene).setRange(0, 255).setValue(200)
      .setLabel("alpha background image").moveTo("lea").setWidth(200).setHeight(20).setPosition(4, 60).linebreak();
  }
}