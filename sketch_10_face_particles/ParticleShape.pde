class ParticleShape extends VParticle
{
  PShape shape;
  BCollision bCollision;
  BAttractionLocal bAttractionLocal;
  float age;
  float scale;
  color col;
  boolean bUpdateShape = true;

  // --------------------------------------------
  ParticleShape(PShape group, PImage sprite, Vec v, float w, float r)
  {
    super(v, w, r);

    bCollision = new BCollision();
    bAttractionLocal = new BAttractionLocal(r*2, 6);

    addBehavior(bCollision);
    //    addBehavior(bAttractionLocal);

    this.shape = createParticleShape(sprite);
    group.addChild( this.shape );

    age = 0;
    scale = 0;
  }

  // --------------------------------------------
  void setUpdateShape(boolean b)
  {
    bUpdateShape = b;
  }

  // --------------------------------------------
  PShape createParticleShape(PImage img)
  {
    //  float partSize = min(width,height);
    float partSize =  getRadius()*2;

    PShape part = createShape();
    part.beginShape(QUAD);
    part.noStroke();
    part.texture(img);
    part.normal(0, 0, 1);
    part.vertex(-partSize/2, -partSize/2, 0, 0);
    part.vertex(+partSize/2, -partSize/2, img.width, 0);
    part.vertex(+partSize/2, +partSize/2, img.width, img.height);
    part.vertex(-partSize/2, +partSize/2, 0, img.height);
    part.endShape();

    return part;
  }

  // --------------------------------------------
  void update()
  {
    super.update();
    col = faceImage.get( (int)(x*sx), (int)(y*sy));
    if (bUpdateShape)
    {
      scale = map(age, 0, 100, 0, 1);
      scale = min(scale, 1);
      age++;

      if (scale > 0)
      {
        shape.setTint( col );
        shape.resetMatrix();
        shape.translate(x, y);
        //      shape.scale( 2 );
      }
    }
  }
}