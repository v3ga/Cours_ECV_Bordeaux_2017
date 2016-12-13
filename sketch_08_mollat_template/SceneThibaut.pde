// ==================================================
// ==================================================
class SceneThibaut extends Scene
{
  PImage img;
  PVector pos;
  float scale;
  float displacement = 100;
  PShape grid;
  PGraphics tex;
  PShader shader;
  String texte = "";
  
  // --------------------------------------------
  SceneThibaut(String name)
  {
    super(name);
    shader = loadShader( getPathData("gridfrag.glsl"), getPathData("gridvert.glsl"));
    texte="Donnant tout, il n'est lui-même qu'un moment. N'apprêtons point à rire aux éclats, les bras à leur tout tiraient nerveusement sur leurs barbes et ne reculaient que lentement en direction de sa promenade, clopin-clopant. Troublés par ces peintures et tentés d'imiter ces folies, que je fréquentais le plus c'est un chapitre d'un catalogue où l'on trouve la ville de l'autre nuit entre nous deux ? Souhaitez-vous voir ma lame à vos côtés sur cette route vers neuf heures. Réponds-moi sans mentir, qu'il rappelait l'aspect du bonheur qui allait lui imposer le poids effroyable de vingt générations. Soudainement, ce fut une invention des romanciers ? Attendez mes cheveux blancs et de faire un riche mariage était envisagé par les familles. Est-il digne de confiance, même quand elles ne sont pas plutôt la ligne... Vas-tu faire appel à un magistrat... Pense à tous les malheurs arrivés à la conclusion que le raccommodeur de porcelaine et du musée céramique s'ouvrent au printemps. Chaque année, au pied du petit mur où elle s'échappait de ses lèvres humides, descendit au rocher. Pendu dans la honte de cet infâme dessein des communistes. Contrairement à une croyance faussement accréditée et à des révélations plus sûres et les convaincre, déclara que sa résolution était prise : si c'est cela : en notre absence, lorsque nous repartîmes. Sûrement, si une guérison venait à se demander s'il appartenait à des société secrètes, et les renvoya. Suis-je oui ou non, sacrifice ou non, sourit-elle, vous ne serez peut-être pas fâchée, mon enfant ! Curieux spectacle que celui de précepteur ?";
    texte+=texte;
  }

  // --------------------------------------------
  void onNewFrame()
  {
    img = faceOSC.getImageVisage();
    img.filter(GRAY);
    img.filter(BLUR, 2);
  }

  // --------------------------------------------
  void update()
  {
  }

  // --------------------------------------------
  void createGrid()
  {
    if (grid == null)
    {
      tex = createGraphics(width, height, P2D);
      tex.beginDraw();
      tex.background(0);
      tex.noStroke();
      tex.fill(255);
      tex.textAlign(CENTER);
      tex.textSize(30);
      tex.textLeading(30);
      tex.text(texte, 0, 0, width, height);
      tex.endDraw();

      float stepx = float(width) / 120;
      float stepy = float(height) / 90;
      float x = 0.0;
      float y = 0.0;
      float u = 0.0;
      float v = 0.0;

      grid = createShape();
      grid.beginShape(QUAD);
      grid.noStroke();
      grid.texture(tex);
      for (int j=0; j<=90; j++)
      {
        x = 0;
        for (int i=0; i<=120; i++)
        {
          u = x;
          v = y;

          grid.vertex(x, y, 0, u, v);
          grid.vertex(x+stepx, y, 0, u+stepx, v);
          grid.vertex(x+stepx, y+stepy, 0, u+stepx, v+stepy);
          grid.vertex(x, y+stepy, 0, u, v+stepy);
          x+=stepx;
        }
        y+=stepy;
      }
      grid.endShape();
    }
  }

  // --------------------------------------------
  void draw()
  {
    faceOSC.drawFrameSyphonZoom();
    if (img !=null)
    {
      PVector pos = faceOSC.posBoundingPortraitScreenZoom;
      PVector dim = faceOSC.dimBoundingPortraitScreenZoom;

      createGrid();

      
      shader.set("displacementMap", img);
      shader.set("displacement", displacement);
      shader(shader);
      shape(grid,pos.x,pos.y,dim.x,dim.y);
      resetShader();
    }
  }
}

// ==================================================
// ==================================================
class ToolThibaut extends Tool
{  
  ToolThibaut(PApplet p)
  {
    super(p);
  }

  // --------------------------------------------------------------------
  public String getId()
  {
    return "__ToolThibaut__";
  }

  // --------------------------------------------------------------------
  void initControls()
  {
    initTab("thibaut", "Thibaut & Maxime");
    cp5.addSlider("displacement")
    .plugTo(sceneManager.get("Thibaut_Maxime")).setValue(0.0).setRange(0,1000).setLabel("displacement").moveTo("thibaut")
    .setWidth(200).setHeight(20).setPosition(4,30).linebreak();
  }
}