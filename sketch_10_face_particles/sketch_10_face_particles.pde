import punktiert.physics.*;
import punktiert.math.Vec;


// --------------------------------------------
PShape particleShape, particleShapeGroup;
PImage particleImage;
PImage faceImage;
float sx, sy; 

// world object
VPhysics physics;
BConstantForce physicsForce;
ParticleShape[] particles;

// --------------------------------------------
void setup()
{
  size(480, 640, P3D);
  particleImage = loadImage("sprite.png");
  faceImage = loadImage("52.png");
  faceImage.resize(320/5, 240/5);
  //faceImage.filter(GRAY);
  particleShapeGroup = createShape(GROUP);
  createPhysics();
  hint(DISABLE_DEPTH_MASK);

  sx = float(faceImage.width) / float(width);
  sy = float(faceImage.height) / float(height);
}

// --------------------------------------------
void draw()
{
  if (mousePressed)
  {
    createParticle(mouseX, mouseY);
    particles = physics.particles.toArray( new ParticleShape[physics.particles.size()] );
  }

  physicsForce.setForce(new Vec(width*.5f-mouseX, height*.5f-mouseY).normalizeTo(.03f));
  physics.update();


  background(0);
  drawFaceImage();
  drawConnexions( map(mouseX,0,width,2,40) );
  fill(255);
  text(""+(int)frameRate + " / " + physics.particles.size() +" particles", 5, height-20);
}

// --------------------------------------------
void drawFaceImage()
{
  //  tint(255,100);
  //  image(faceImage,0,0,width,height);
}

// --------------------------------------------
void drawParticles()
{
  shape(particleShapeGroup);
}

// --------------------------------------------
void drawConnexions(float distMinCurrent)
{
  int nbParticles = physics.particles.size();
  float d=0.0;

  strokeWeight(2);
  beginShape(LINES);
  for (int i=0; i<nbParticles; i++)
  {
    ParticleShape pi = particles[i];//(ParticleShape)physics.particles.get(i);
    for (int j=i; j<nbParticles; j++)
    {
      ParticleShape pj = particles[j];//(ParticleShape)physics.particles.get(j);
      d = dist(pi.x, pi.y, pj.x, pj.y);
      if (d < distMinCurrent)
      {
        stroke( pi.col, 255);
        vertex(pi.x, pi.y);
        stroke( pj.col, 255 );
        vertex(pj.x, pj.y);
      }
    }
  }
    endShape();
}

// --------------------------------------------
void createParticle(float x, float y)
{
  // val for arbitrary radius
  float rad = random(4, 7);
  // vector for position
  //  Vec pos = new Vec(random(rad, width - rad), random(rad, height - rad));
  // create particle (Vec pos, mass, radius)
  ParticleShape particle = new ParticleShape(particleShapeGroup, particleImage, new Vec(x, y), 2, rad);
  //   VParticle particle = new VParticle(pos, 2, rad);

  // add particle to world
  physics.addParticle(particle);
}
// --------------------------------------------
void createPhysics()
{
  physics = new VPhysics();
  physics.setfriction(.2f);
  physicsForce = new BConstantForce(new Vec());
  //  physics.addBehavior(physicsForce);
}