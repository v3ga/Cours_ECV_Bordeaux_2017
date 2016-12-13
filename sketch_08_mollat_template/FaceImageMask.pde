class FaceImageMask
{
  PGraphics offscreen;

  // --------------------------------------------
  FaceImageMask(int w, int h)
  {
    offscreen = createGraphics(w, h, P2D);
  }

  // --------------------------------------------
  PGraphics get()
  {
    return offscreen;
  }

  // --------------------------------------------
  int getWidth()
  {
    return offscreen.width;
  }

  // --------------------------------------------
  int getHeight()
  {
    return offscreen.height;
  }

  // --------------------------------------------
  void update()
  {
    offscreen.beginDraw();
    offscreen.background(0);
    offscreen.fill(255);  
    offscreen.noStroke();
    if (faceOSC.isFound())
    {
      faceOSC.drawMeshTrianglesOffscreen( offscreen );
    }
    offscreen.endDraw();
    
    /*    if (face.found>0)
     {
     offscreen.scale(scaleOffscreen);
     face.drawMeshTrianglesOffscreen(offscreen);
     }
     offscreen.endDraw();
     
     if (face.found>0 && faceImageMasked!=null) {
     faceBounding.compute(face.meshPoints);
     faceImage.beginDraw();
     faceImage.background(0);
     float xFace = faceImage.width/2 - faceBounding.center.x;
     float yFace = faceImage.height/2 - faceBounding.center.y;
     faceImage.image(faceImageMasked, xFace, yFace);
     faceImage.endDraw();
     }
     */
  }

  // --------------------------------------------
  void applyMask()
  {
    /*    if (canvas != null && offscreen!=null)
     {
     faceImageMasked = canvas.get();
     faceImageMasked.mask(offscreen);
     }
     */
  }
}