// ==================================================
class SceneLea extends Scene
{
  VPhysics physics;
  BConstantForce force;
  ParticleShape[] particles;


  int amountMax = 2000;
  int amount = 0;
  PImage imgFace;
  PVector pos;
  float scale;
  float distMin = 20.0f;
  float distMinCurrent = 0.0f;
  float alphaImageFace = 120;
  float radiusMin = 5;
  float radiusMax = 10;

  int DRAW_MODE_BUBBLES = 1;
  int DRAW_MODE_CONNEXIONS = 2;
  int drawMode = DRAW_MODE_CONNEXIONS;


  PShape particleShape, particleShapeGroup;
  PImage particleImage;

  float timeSpawn = 0;
  float tTransition = 0.0;
  float tTransitionConnexions = 0.0;
  
  float alphaBackground = 0;
  
  float particleAttractionStrength = 3;
  float particleAttractionRadiusFactor = 6;

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
      physics = new VPhysics(new Vec(0, 0), new Vec(width, height));
      physics.setfriction(.1f);
      force = new BConstantForce(new Vec());
      physics.addBehavior(force);

      particleShapeGroup = createShape(GROUP);

      /*      for (int i = 0; i < amount; i++) 
       {
       createParticle(img, random(width), random(height));
       }
       particles = physics.particles.toArray( new ParticleShape[physics.particles.size()] );
       */
    }
  }

  // --------------------------------------------
  void deletePhysics()
  {
    physics = null;
    particles = null;
  }
  // --------------------------------------------
  void createParticle(PImage face, float x, float y)
  {
    // val for arbitrary radius
    float rad = random(radiusMin, radiusMax);
    // vector for position
    //  Vec pos = new Vec(random(rad, width - rad), random(rad, height - rad));
    // create particle (Vec pos, mass, radius)
    ParticleShape particle = new ParticleShape(particleShapeGroup, particleImage, new Vec(x, y), 2, rad);
    particle.setContext(face, width, height);
    particle.setAttractionLocalStrength( particleAttractionStrength );
    particle.setAttractionLocalRadiusFactor( particleAttractionRadiusFactor );

    // add particle to world
    physics.addParticle(particle);
  }


  // --------------------------------------------
  void onBeginAnimation()
  {
    super.onBeginAnimation();
    //    createPhysics();
    Ani.to(this, 1.0, "tTransition", 1.0, Ani.EXPO_IN_OUT, "onEnd:createPhysics");
//    Ani.to(this, 10.0, "tTransitionConnexions", 1.0);
    timeSpawn = 0;
  }

  // --------------------------------------------
  void onTerminateAnimation()
  {
    super.onTerminateAnimation();
    Ani.to(this, 1.0, "tTransition", 0.0, Ani.EXPO_IN_OUT, "onEnd:deletePhysics");
//    Ani.to(this, 1.0, "tTransitionConnexions", 0.0);
  }

  // --------------------------------------------
  void onNewFrame()
  {
    imgFace = faceOSC.getImageVisage();
  }

  // --------------------------------------------
  void update()
  {
    super.update();


    if (physics != null && (particles == null || particles.length < amountMax))
    {
      timeSpawn += dt;
      if (timeSpawn>0.01f)
      {
        createParticle(imgFace, width/2+random(-10,10), height/2+random(-10,10));
        createParticle(imgFace, width/4+random(-10,10), height/4+random(-10,10));
        createParticle(imgFace, 3*width/4+random(-10,10), height/4+random(-10,10));
        createParticle(imgFace, width/2+random(-10,10), 3*height/4+random(-10,10));
        particles = physics.particles.toArray( new ParticleShape[physics.particles.size()] );
        timeSpawn=0;
      }
    
      if (particles !=null)
      {
        for (int i=0;i<particles.length;i++)
        {
          particles[i].setAttractionLocalStrength( particleAttractionStrength );
          particles[i].setAttractionLocalRadiusFactor( particleAttractionRadiusFactor );
      
        }
      }
    }

    if (physics != null)
    {
//      force.setForce(new Vec( -1 + 2*noise(0.01f*frameCount), -1+2*noise(0.03f*frameCount) ).normalizeTo(.23f));
      physics.update();
    }
//    distMinCurrent = tTransitionConnexions * distMin;
    distMinCurrent=distMin;
  }

  // --------------------------------------------
  void beginDraw()
  {

    //    pos = faceOSC.posBoundingPortraitScreenZoom;
    scale = faceOSC.dimBoundingPortraitScreenZoom.x / float( imgFace.width );


    pushStyle();
    pushMatrix();

    //    translate(pos.x, pos.y);
    //    scale(scale, scale);
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
    if (imgFace == null) return;
    imgFace.loadPixels();

//    tint( 255, map(tTransition, 0, 1, 255, alphaImageFace) );
    float alphaFace = 255;
    if (particles != null && particles.length>0)
      alphaFace = map(particles.length, 0, amountMax, 255, alphaImageFace); 
    tint( 255,  alphaFace);
    faceOSC.drawFrameSyphonZoom();

    if (drawMode == DRAW_MODE_BUBBLES)     drawPoints();
    else if (drawMode == DRAW_MODE_CONNEXIONS)     drawConnections();

    tint(255,255);
}

  // --------------------------------------------
  void drawPoints()
  {
    if (particleShapeGroup == null) return;
    beginDraw();
    shape(particleShapeGroup);
    endDraw();
  }

  // --------------------------------------------
  void drawConnections()
  {
    if (particles == null) return;
    if (distMinCurrent < 2.0f) return;

    beginDraw();

    int nbParticles = particles.length;
    float d=0.0;
    float alpha = tTransition*255;

    strokeWeight(2);
    beginShape(LINES);
    for (int i=0; i<nbParticles; i++)
    {
      ParticleShape pi = particles[i];
      for (int j=i; j<nbParticles; j++)
      {
        ParticleShape pj = particles[j];
        d = dist(pi.x, pi.y, pj.x, pj.y);
        if (d < distMinCurrent)
        {
          stroke( pi.col, alpha);
          vertex(pi.x, pi.y);
          stroke( pj.col, alpha );
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
    if (key == 'a')
    {
      drawMode = DRAW_MODE_BUBBLES;
      //     int nbParticles = particles.length;
      //      for (int i=0;i<nbParticles;i++
    } else if (key == 'z') drawMode = DRAW_MODE_CONNEXIONS;
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

    cp5.addSlider("particleAttractionStrength")
      .plugTo(scene).setRange(-10, 10).setValue(5)
      .setLabel("attraction local strength").moveTo("lea").setWidth(200).setHeight(20).setPosition(4, 90).linebreak();

    cp5.addSlider("particleAttractionRadiusFactor")
      .plugTo(scene).setRange(1, 15).setValue(2)
      .setLabel("attraction local radius factor").moveTo("lea").setWidth(200).setHeight(20).setPosition(4, 120).linebreak();
}
}