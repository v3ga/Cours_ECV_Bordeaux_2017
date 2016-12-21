// --------------------------------------------
void drawBlobsAndEdges(BlobDetection theBlobDetection, boolean drawBlobs, boolean drawEdges)
{
  pushStyle();
  noFill();
  Blob b;
  EdgeVertex eA, eB;
  for (int n=0 ; n<theBlobDetection.getBlobNb() ; n++)
  {
    b=theBlobDetection.getBlob(n);
    if (b!=null)
    {
      // Edges
      if (drawEdges)
      {
        strokeWeight(2);
        stroke(0, 255, 0);
        for (int m=0;m<b.getEdgeNb();m++)
        {
          eA = b.getEdgeVertexA(m);
          eB = b.getEdgeVertexB(m);
          if (eA !=null && eB !=null)
            line(
            eA.x*width, eA.y*height, 
            eB.x*width, eB.y*height
              );
        }
      }

      // Blobs
      if (drawBlobs)
      {
        strokeWeight(1);
        stroke(255, 0, 0);
        rect(
        b.xMin*width, b.yMin*height, 
        b.w*width, b.h*height
          );
      }
    }
  }
  popStyle();
}

// --------------------------------------------
class Timer
{
  float now = 0;
  float before = 0;
  float dt = 0;

  Timer()
  {
    now = before = millis()/1000.0f;
  }

  float dt()
  {
    now = millis()/1000.0f;
    dt = now - before;
    before = now;
    return dt;
  }

}