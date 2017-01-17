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
boolean bDrawContours = true;
boolean bDrawContoursVertex = true;
float alphaContours = 55;

ControlP5 cp5;

boolean bExportPDF = false;
boolean bDrawImage = true;


DotDiagram[] theDiagrams;
boolean bComputeDiagrams = true;
boolean bDrawDiagram = false;
boolean bDrawDiagramDotNumbers = false;
boolean bComputeGlobalDiagram = true;

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
  cp5.addSlider("maxPixelH").setRange(1, 50).setValue(20).linebreak();
  cp5.addToggle("bComputeGlobalDiagram").setLabel("just one diagram please").linebreak();

  cp5.addToggle("bDrawImage").setLabel("draw image").linebreak();
  cp5.addToggle("bDrawContours").setLabel("draw contours").linebreak();
  cp5.addToggle("bDrawContoursVertex").setLabel("draw contours vertices").linebreak();
  cp5.addSlider("alphaContours").setRange(0, 255).setValue(255).linebreak();
  cp5.addToggle("bDrawDiagram").setLabel("draw diagram").linebreak();
  cp5.addToggle("bDrawDiagramDotNumbers").setLabel("draw diagram dots num").linebreak();
  cp5.addButton("exportPDF").setLabel("export").linebreak();
  cp5.addButton("saveProperties").setLabel("save values").linebreak();

  cp5.loadProperties("values");


  compute();
}

// --------------------------------------------
void draw()
{
  background(0);
  if (bDrawImage)  
    image(visageFilter, 0, 0, width, height);
  if (bExportPDF)
  {
    beginRecord(PDF, "export_"+getTime()+".pdf");
  }

  if (bDrawContours)
  {
    for (int i=0; i<levels; i++) {
      drawContours(i);
    }
  }


  if (bDrawDiagram) 
  {
    int numDots = (int)map(mouseY, 1, height, 1, 20);
    int lineThresh = (int)map(mouseX, 1, width, 1, 150);
    for (int i=0; i<theDiagrams.length; i++)
    {
      theDiagrams[i].compute(numDots, 10, "SIMPLE");
      theDiagrams[i].displayDotDiagram(lineThresh, true, bDrawDiagramDotNumbers);
    }
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
    theBlobDetection[i] = new BlobDetection(visageFilter.width, visageFilter.height);
    theBlobDetection[i].setThreshold(float(i)/float(levels) * levelMax);
    theBlobDetection[i].computeBlobs(visageFilter.pixels);
  }
}

// --------------------------------------------
void computeDiagrams()
{
  println("-- computeDiagrams()");
  if (bComputeGlobalDiagram)
  {
    theDiagrams = new DotDiagram[1];
    theDiagrams[0] = new DotDiagram();
    ArrayList<PVector> points = new ArrayList<PVector>();
    for (int i=0; i<levels; i++) 
      points.addAll( getPVectorFromBlobDetection( theBlobDetection[i] ) );
    theDiagrams[0].setDiagramPoints( points );
  } else
  {
    theDiagrams = new DotDiagram[levels];
    for (int i=0; i<levels; i++) 
    {
      println("-- diagram ["+i+"]");
      theDiagrams[i] = new DotDiagram();
      theDiagrams[i].setDiagramPoints( getPVectorFromBlobDetection( theBlobDetection[i] ) );
    }
  }
}

// --------------------------------------------
void compute()
{
  filterVisage(niveauBlur);
  computeBlobs();
  computeDiagrams();
}

// --------------------------------------------
void drawContours(int i) 
{
  Blob b;
  EdgeVertex eA, eB;
  float x, y;
  pushStyle();
  rectMode(CENTER);
          noFill();

  for (int n=0; n<theBlobDetection[i].getBlobNb(); n++) 
  {
    b=theBlobDetection[i].getBlob(n);

    if (b!=null && (b.w*width)*(b.h*height)>=maxPixelH*maxPixelH) 
    {
      stroke((float(i)/float(levels)*colorRange)+colorStart, 100, 100, alphaContours);
      for (int m=0; m<b.getEdgeNb(); m++) 
      {
        eA = b.getEdgeVertexA(m);
        eB = b.getEdgeVertexB(m);

        line(eA.x*width, eA.y*height, eB.x*width, eB.y*height);

        if (bDrawContoursVertex)
        {
          rect(eA.x*width, eA.y*height, 4, 4);
        }
      }
    }
  }
  popStyle();
}

// --------------------------------------------
void controlEvent(ControlEvent e)
{
  String name = e.getName();
  if (name.equals("niveauBlur"))
  {
    niveauBlur = int(e.getValue());
    compute();
  } else if (name.equals("levels"))
  {
    levels = (int)e.getValue();
    compute();
  } else if (name.equals("levelMax"))
  {
    compute();
  } else if (name.equals("is_Diagram"))
  {
    compute();
  }
}

// --------------------------------------------
void exportPDF()
{
  bExportPDF = true;
}

// -------------------------------------------
void saveProperties()
{
  cp5.saveProperties("values");
}

// -------------------------------------------
void filterVisage(int _niveauBlur) 
{
  visageFilter = visage.copy();
  if (_niveauBlur>0) {
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

// --------------------------------------------
void keyPressed() 
{
}

// --------------------------------------------
ArrayList<PVector> getPVectorFromBlobDetection(BlobDetection bd)
{
  ArrayList<PVector> points = new ArrayList<PVector>();

  Blob b;
  EdgeVertex eA, eB;
  for (int n=0; n<bd.getBlobNb(); n++) 
  {
    b=bd.getBlob(n);

    if (b!=null && (b.w*width)*(b.h*height)>=maxPixelH*maxPixelH) 
    {
      for (int m=0; m<b.getEdgeNb(); m++) 
      {
        eA = b.getEdgeVertexA(m);
        eB = b.getEdgeVertexB(m);

        points.add( new PVector(eA.x*width, eA.y*height) );
      }
    }
  }

  println("-- found "+points.size()+ " point(s)");

  return points;
}