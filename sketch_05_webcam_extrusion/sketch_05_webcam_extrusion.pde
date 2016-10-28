import processing.video.*;

// --------------------------------------------------
Capture video;
PImage videoSmall;
int videoSizeDivider = 2;

// --------------------------------------------------
void setup()
{
  size(640,480,P3D);
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
  translate(width/2, height/2,-400);
  rotateX( map(mouseY,0,height,-PI,PI) );
  rotateY( map(mouseX,0,width,-PI,PI) );
  translate(-width/2,-height/2,0);
  videoSmall.loadPixels();

  float b = 0.0;
  float xx = 0.0;
  float yy = 0.0;

  float stepx = width / videoSmall.width;
  float stepy = width / videoSmall.height;
  
  color c;
  
  for (int y = 0; y < videoSmall.height; y++) 
  {
    for (int x = 0; x < videoSmall.width; x++) 
    {
      c = videoSmall.get(x,y);
      b = 1.0-brightness( c ) / 255.0;

      xx = x*stepx;
      yy = y*stepy;
      
      // Motif à dessiner
      stroke(c);
      line( xx+stepx/2,yy+stepy/2,0, xx+stepx/2, yy+stepy/2, b*300 );
      
    }  
  }
}

// --------------------------------------------------
void captureEvent(Capture c) 
{
  c.read();
}