import processing.video.*;

// --------------------------------------------------
Capture video;
PImage videoSmall;
int videoSizeDivider = 2;


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
  image(videoSmall,0,0,width,height);
}

// --------------------------------------------------
void captureEvent(Capture c) 
{
  c.read();
}