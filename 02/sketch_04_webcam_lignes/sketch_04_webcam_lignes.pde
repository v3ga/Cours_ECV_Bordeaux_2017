import processing.video.*;

// --------------------------------------------------
Capture video;
PImage videoSmall;
int videoSizeDivider = 2;
  float longueur = 30;

// --------------------------------------------------
void setup()
{
  size(640,480);
  video = new Capture(this, 160, 120);  
  videoSmall = new PImage(video.width/videoSizeDivider,video.height/videoSizeDivider);
  video.start();  
}

// --------------------------------------------------
void draw()
{
  videoSmall.copy(video,0,0,video.width,video.height,0,0,videoSmall.width,videoSmall.height);
  //image(videoSmall,0,0,width,height);
  background(255);
  stroke(0);
  videoSmall.loadPixels();

  float b = 0.0;
  float angle = 0.0;
  float xx = 0.0;
  float yy = 0.0;

  float stepx = width / videoSmall.width;
  float stepy = width / videoSmall.height;
  
  for (int y = 0; y < videoSmall.height; y++) 
  {
    for (int x = 0; x < videoSmall.width; x++) 
    {
      b = 1.0-brightness( videoSmall.get(x,y) ) / 255.0;

      xx = x*stepx;
      yy = y*stepy;
      
      angle = map(b,0.0,1.0,0,TWO_PI);
      // Motif à dessiner
      line( xx+stepx/2,yy+stepy/2,xx+stepx/2+longueur*cos(angle),yy+stepy/2+longueur*sin(angle) );
      
    }  
  }
}

// --------------------------------------------------
void captureEvent(Capture c) 
{
  c.read();
}