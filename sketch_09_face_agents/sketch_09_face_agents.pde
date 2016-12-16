PImage visage;
PImage visageNB;
PGraphics offscreen;

// --------------------------------------------
void setup()
{
  visage = loadImage("pic.png");
  visage.filter(GRAY);
  visage.filter(INVERT);
  visage.filter(THRESHOLD,0.7);
  size(670,970);
}

// --------------------------------------------
void draw()
{
  image(visage,0,0,width,height);
}