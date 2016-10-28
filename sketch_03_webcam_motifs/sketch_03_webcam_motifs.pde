import processing.video.*;

// --------------------------------------------------
Capture video;
PImage videoSmall;
int videoSizeDivider = 3;

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
  noStroke();
  fill(0);
  videoSmall.loadPixels();

  float b = 0.0;
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
      
      // Motif à dessiner
      ellipse(xx+stepx/2,yy+stepx/2, b*stepx, b*stepy);
      
    }  
  }
}

// --------------------------------------------------
void captureEvent(Capture c) 
{
  c.read();
}