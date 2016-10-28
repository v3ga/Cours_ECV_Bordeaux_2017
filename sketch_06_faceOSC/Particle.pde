// A simple Particle class

class Particle {
  ParticleSystem parent;
  PVector location;
  PVector velocity;
  PVector acceleration;
  float rotation=0.0;
  float rotationVelocity=0.0;
  float lifespan;
  PImage imgParticle;
  float scale=1;
  float locationYMin = random(0,150);
  float locationYMax = random(0,height-150);
  boolean isConstrain = false;

  Particle(ParticleSystem parent_, PVector l) {
    parent = parent_;
    acceleration = parent.acceleration.get();
    velocity = PVector.random2D();
    location = l.get();
    lifespan = 255.0;
  }

  void setVelocity(PVector v_)
  {
    velocity.mult(random(v_.x, v_.y));
  }

  void run() {
    update();
  }



  // Method to update location
  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    if (isConstrain)
      location.y = constrain(location.y,locationYMin,locationYMax);
    lifespan -= 1.0;
    rotation+=rotationVelocity;
  }

  // Method to display
  void display() {
    stroke(255, lifespan);
    fill(255, lifespan);
    ellipse(location.x, location.y, 8, 8);
  }

  // Is the particle still useful?
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } 
    else {
      return false;
    }
  }
}


// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;
  PVector originSpeed = new PVector();
  PImage imgParticle;
  PVector acceleration = new PVector();
  int mode = 0; // 0 = ellipse , 1 = image, 2 = text
  String particleText = "";
  float particleTextWidth = 0;
  int particleTextFontSize = 12;
  PFont textFont;
  float particleRotationVelocity=0.0;
  float particleScale = 1.0;
  boolean particleConstrain = false;


  ParticleSystem(PVector location, float gravity_) {
    setOrigin(location);
    setGravity(gravity_);
    setOriginSpeed(0.4, 5);
    particles = new ArrayList<Particle>();
  }

  void setMode(int mode_)
  {
    mode = mode_;
    if (mode>2) mode=0;
  }

  void setParticleRotationVelocity(float rotVelocity_)
  {
    particleRotationVelocity = rotVelocity_;
  }

  void setParticleImage(PImage img_)
  {
    imgParticle = img_;
    setMode(1);
  }

  void setParticleTextFont(PFont font_)
  {
    textFont = font_;
    textFont(textFont);
  }

  void setParticleTextFontSize(int fontSize_)
  {
    particleTextFontSize = fontSize_;
  }


  void setParticleText(String text_)
  {
    particleText = text_;
    setMode(2);
  }

  void setOrigin(PVector location_)
  {
    origin = location_.get();
  }

  void setOriginSpeed(PVector v_)
  {
    originSpeed = v_.get();
  }

  void setOriginSpeed(float vx_, float vy_)
  {
    setOriginSpeed( new PVector(vx_, vy_) );
  }


  void setGravity(float g_)
  {
    acceleration.y = g_;
  }
  
  void setParticleScale(float s_)
  {
    particleScale = s_;
  }

  void addParticle(int number) {
    for (int i = 0; i < number; i++) {
      Particle p = new Particle(this, origin);
      p.setVelocity(originSpeed.get());
      if (mode == 1 && imgParticle!=null)
      {
        p.imgParticle = imgParticle;
        p.rotationVelocity = particleRotationVelocity;
        p.scale = particleScale;
        p.isConstrain = particleConstrain;
      }
      particles.add(p);
    }
  }



  void run() 
  {
    if (mode == 2)
    {
      if (!particleText.equals(""))
      {
        particleTextWidth = textWidth(particleText);
      }
    }

    pushStyle();
    if (mode == 2)
    {
      textSize(particleTextFontSize);
    }

    for (int i = particles.size()-1; i >= 0; i--) 
    {
      Particle p = particles.get(i);
      // Update
      p.run();
      // display
      if (mode == 0)
      {
        stroke(255, p.lifespan);
        fill(255, p.lifespan);
        ellipse(p.location.x, p.location.y, 8, 8);
      }
      else if (mode == 1)
      {
        if (p.imgParticle !=null) 
        {
          tint(255, p.lifespan); 
          pushMatrix();
          translate(p.location.x, p.location.y);     
          rotate(radians(p.rotation));
          scale(p.scale);
          translate(-p.imgParticle.width/2, -p.imgParticle.height/2);
          image(p.imgParticle, 0, 0);
          popMatrix();
        }
      }
      else if (mode == 2) 
      {
        fill(255);
        text(particleText, p.location.x-particleTextWidth/2, p.location.y);
      }

      if (p.isDead()) {
        particles.remove(i);
      }
    }
    popStyle();
  }
}