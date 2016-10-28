class SceneParticles extends Scene
{
  ParticleSystem psEyeLeft;
  ParticleSystem psEyeRight;
  ParticleSystem psMouth;

  float gravity = 0.5;

  PImage imgPart1;

  // --------------------------------------------------------------
  SceneParticles()
  {
    super("Particles");
    imgPart1 = loadImage("sprite.png");
  }

  // --------------------------------------------------------------
  void setup()
  {
    psEyeLeft   = new ParticleSystem(new PVector(), gravity);
    psEyeRight  = new ParticleSystem(new PVector(), gravity);
    psMouth  = new ParticleSystem(new PVector(), -gravity);

    // Détermine avec quelle vitesse les particules sont émises 
    //psEyeLeft.setOriginSpeed(0,0);
    //psEyeRight.setOriginSpeed(0,0);
    //psMouth.setOriginSpeed(0,0);

    // Associe une image aux particules de la bouche
    psMouth.setParticleImage(imgPart1);

    
    //psMouth.setParticleText("BLAH");
    //psMouth.setParticleTextFontSize(30);
  }

  // --------------------------------------------------------------
  void draw()
  {
    face.update();

    PVector eyeLeftScreenPosition = transformToScreen( face.eyeLeftPosition );
    PVector eyeRightScreenPosition = transformToScreen( face.eyeRightPosition );
    PVector mouthScreenPosition = transformToScreen( face.mouthPosition );

    psEyeLeft.setOrigin( eyeLeftScreenPosition );
    psEyeRight.setOrigin( eyeRightScreenPosition );
    psMouth.setOrigin( mouthScreenPosition );

    // Si la hauteur des sourcirls > 18
    // on lance des particules depuis la position des yeux
    if (face.eyebrowLeft + face.eyebrowRight>=18)
    {
      psEyeLeft.addParticle(1);
      psEyeRight.addParticle(1);
    }

    // Si la hauteur de la bouche > 2
    // on lance 10 particules en même temps
    if (face.mouthHeight >= 2)
    {
      psMouth.addParticle(1);
    }

    // dessin du fond
    background(0);

    // dessin du visage
    drawFaceImage();
    drawFaceFeatures();


    // dessin des particules
    psEyeLeft.run();
    psEyeRight.run();
    psMouth.run();
  }
}