class ParticleShape extends VParticle
{
  PShape shape;
  BCollision bCollision;
  BAttractionLocal bAttractionLocal;
  float attractionLocalRadiusFactor = 1.0;
  float age;
  float scale;
  color col = color(255);
  boolean bUpdateShape = true;
  float colAlpha = 100;

  float sx, sy;
  PImage imgSource;

  // --------------------------------------------
  ParticleShape(PShape group, PImage sprite, Vec v, float w, float r)
  {
    super(v, w, r);

    this.bCollision = new BCollision();
    this.bAttractionLocal = new BAttractionLocal(r*10, -6);
    setAttractionLocalRadiusFactor(10.0);

    this.addBehavior(bCollision);
    this.addBehavior(bAttractionLocal);

    this.shape = createParticleShape(sprite);
    group.addChild( this.shape );

    age = 0;
    scale = 0;
  }

  // --------------------------------------------
  void setAlpha(float alpha)
  {
    this.colAlpha = alpha;
  }

  // --------------------------------------------
  void setRadius(float radius)
  {
    super.setRadius(radius);
    setAttractionLocalRadiusFactor( attractionLocalRadiusFactor );
  }

  // --------------------------------------------
  void setAttractionLocalRadiusFactor(float v)
  {
    attractionLocalRadiusFactor = v;
    if (this.bAttractionLocal !=null)
      this.bAttractionLocal.setRadius( getRadius()*v );
  }

  // --------------------------------------------
  void setAttractionLocalStrength(float v)
  {
    this.bAttractionLocal.setStrength(v);
  }

  // --------------------------------------------
  void setUpdateShape(boolean b)
  {
    bUpdateShape = b;
  }

  // --------------------------------------------
  void setContext(PImage img, float w, float h)
  {
    this.imgSource = img;
    this.sx = float(imgSource.width) / w;
    this.sy = float(imgSource.height) / h;
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
    col = imgSource.get( (int)(x*sx), (int)(y*sy));
    if (bUpdateShape)
    {
      scale = map(age, 0, 100, 0, 1);
      scale = min(scale, 1);
      age++;

      if (scale > 0)
      {
        shape.setTint( color(red(col),green(col), blue(col),colAlpha) );
        shape.resetMatrix();
        shape.translate(x, y);
      }
    }
  }
}