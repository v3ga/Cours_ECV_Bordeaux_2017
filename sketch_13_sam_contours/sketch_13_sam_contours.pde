// --------------------------------------------
import controlP5.*;
import blobDetection.*;
import processing.pdf.*;

// --------------------------------------------
PImage visage;


int levels = 10;                    // number of contours
float levelMax = 1.0;
int factor = 10;
float colorStart =  0;               // Starting dregee of color range in HSB Mode (0-360)
float colorRange =  160;             // color range / can also be negative
BlobDetection[] theBlobDetection = new BlobDetection[int(levels)];

ControlP5 cp5;

boolean bExportPDF = false;

// --------------------------------------------
void settings()
{
  visage = loadImage("LeaThumb.jpg");
  size(visage.width*factor, visage.height*factor);
}

// --------------------------------------------
void setup()
{
  colorMode(HSB, 360, 100, 100);  

  cp5 = new ControlP5(this);
  cp5.setAutoDraw(false);
  cp5.addSlider("levels").setRange(1, 20).linebreak();
  cp5.addSlider("levelMax").setRange(0.1, 1.0).linebreak();
  cp5.addButton("exportPDF").linebreak();

  computeBlobs();
}

// --------------------------------------------
void draw()
{
  background(0);
  if (bExportPDF)
  {
    beginRecord(PDF, "export.pdf");
  }
  
  for (int i=0; i<levels; i++) {
    drawContours(visage, i);
  }
  
  if (bExportPDF)
  {
    endRecord();
    bExportPDF = false;
  }

  cp5.draw();
}

// --------------------------------------------
void computeBlobs()
{
  theBlobDetection = new BlobDetection[levels];

  for (int i=0; i<levels; i++) {
    theBlobDetection[i] = new BlobDetection(visage.width, visage.height);
    theBlobDetection[i].setThreshold(float(i)/float(levels) * levelMax);
    theBlobDetection[i].computeBlobs(visage.pixels);
  }
}

// --------------------------------------------
void drawContours(PImage img, int i) 
{
  Blob b;
  EdgeVertex eA, eB;
  for (int n=0; n<theBlobDetection[i].getBlobNb(); n++) {
    b=theBlobDetection[i].getBlob(n);
    if (b!=null) {
      stroke((float(i)/float(levels)*colorRange)+colorStart, 100, 100);
      for (int m=0; m<b.getEdgeNb(); m++) {
        eA = b.getEdgeVertexA(m);
        eB = b.getEdgeVertexB(m);
        if (eA !=null && eB !=null)
          line(
            eA.x*img.width*factor, eA.y*img.height*factor, 
            eB.x*img.width*factor, eB.y*img.height*factor 
            );
      }
    }
  }
}

// --------------------------------------------
void controlEvent(ControlEvent e)
{
  String name = e.getName();
  if (name.equals("levels"))
  {
    levels = (int)e.getValue();
    computeBlobs();
  }
  if (name.equals("levelMax"))
  {
    computeBlobs();
  }
}

// --------------------------------------------
void exportPDF()
{
  bExportPDF = true;
}