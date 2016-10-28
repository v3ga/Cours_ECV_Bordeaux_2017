import processing.video.*;

// --------------------------------------------------
Capture video;


// --------------------------------------------------
void setup()
{
  size(320,240);
  video = new Capture(this, 160, 120);  
  video.start();  
}

// --------------------------------------------------
void draw()
{
  image(video,0,0,width,height);
}

// --------------------------------------------------
void captureEvent(Capture c) 
{
  c.read();
}