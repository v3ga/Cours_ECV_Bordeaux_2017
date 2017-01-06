// --------------------------------------------
import controlP5.*;
import blobDetection.*;
import processing.pdf.*;
import java.text.*;
import java.util.*;

// --------------------------------------------
PImage visage, visageFilter;

int niveauBlur = 1;
int maxPixelH = 15;
int levels = 2;                    // number of contours
float levelMax = 1.0;
int factor = 10;
float colorStart =  0;
float colorRange =  160;
BlobDetection[] theBlobDetection = new BlobDetection[int(levels)];

ControlP5 cp5;

boolean bExportPDF = false;
boolean bDrawImage = true;

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
  cp5.addSlider("niveauBlur").setRange(0, 4).linebreak();
  cp5.addSlider("levels").setRange(1, 20).linebreak();
  cp5.addSlider("levelMax").setRange(0.1, 1.0).setValue(0.5).linebreak();
  cp5.addToggle("bDrawImage").setLabel("draw image").linebreak();
  cp5.addButton("exportPDF").setLabel("export").linebreak();
  
  
  computeBlobs();
}

// --------------------------------------------
void draw()
{
  background(0);
  if (bDrawImage)  
    image(visage,0,0,width,height);
  if (bExportPDF)
  {
    beginRecord(PDF, "export_"+getTime()+".pdf");
  }
  
  for (int i=0; i<levels; i++) {
    drawContours(i);
  }
  
  if (bExportPDF)
  {
    endRecord();
    bExportPDF = false;
  }

  cp5.draw();
}

// --------------------------------------------
// --------------------------------------------
void computeBlobs()
{
  theBlobDetection = new BlobDetection[levels];

  for (int i=0; i<levels; i++) {
    theBlobDetection[i] = new BlobDetection(visageFilter.width, visageFilter.height);
    theBlobDetection[i].setThreshold(float(i)/float(levels) * levelMax);
    theBlobDetection[i].computeBlobs(visageFilter.pixels);
  }
}

// --------------------------------------------
void drawContours(int i) 
{
  Blob b;
  EdgeVertex eA, eB;
  for (int n=0; n<theBlobDetection[i].getBlobNb(); n++) {
    b=theBlobDetection[i].getBlob(n);
    if (b!=null && (b.w*width)*(b.h*height)>=maxPixelH*maxPixelH) {
      stroke((float(i)/float(levels)*colorRange)+colorStart, 100, 100);
      for (int m=0; m<b.getEdgeNb(); m++) {
        eA = b.getEdgeVertexA(m);
        eB = b.getEdgeVertexB(m);
        if (eA !=null && eB !=null)
          line(
            eA.x*width, eA.y*height, 
            eB.x*width, eB.y*height 
            );
      }
    }
  }
}

// --------------------------------------------
void controlEvent(ControlEvent e)
{
  String name = e.getName();
  if (name.equals("niveauBlur"))
  {
    niveauBlur = int(e.getValue());
    filterVisage(niveauBlur);
    computeBlobs();
  }
  else if (name.equals("levels"))
  {
    levels = (int)e.getValue();
    filterVisage(niveauBlur);
    computeBlobs();
  }
  else if (name.equals("levelMax"))
  {
    filterVisage(niveauBlur);
    computeBlobs();
  }
}

// --------------------------------------------
void exportPDF()
{
  bExportPDF = true;
}

// -------------------------------------------

void filterVisage(int _niveauBlur){
  visageFilter = visage.copy();
  if(_niveauBlur>0){
  visageFilter.filter(BLUR, _niveauBlur);
  } 
}

// --------------------------------------------
String getTime() 
{
  Date dNow = new Date( );
  SimpleDateFormat time = new SimpleDateFormat ("hh"+"_"+"mm"+"_"+"ss");
  println(time.format(dNow)); 
  String t = time.format(dNow);
  return t;
}