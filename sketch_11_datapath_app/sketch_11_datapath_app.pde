import controlP5.*;
ControlP5 cp5;
float widthRect=20;
JSONObject jsonRandom; 

// --------------------------------------------
void setup()
{
  size(800, 600);
  cp5 = new ControlP5(this);
  cp5.addSlider("widthRect").setBroadcast(false).setRange(0, 400).setHeight(20).setWidth(200).setBroadcast(true);
  cp5.loadProperties(sketchPath("data/tools"));

  try
  {
    jsonRandom = loadJSONObject("data/randomid.json");
  } 
  catch(Exception e)
  {
    if (jsonRandom == null)
    {
      jsonRandom = new JSONObject();
      jsonRandom.setFloat("value", random(100));
    }
  }
}

// --------------------------------------------
void draw()
{
  background(0);
  rectMode(CENTER);
  noStroke();
  fill(255);
  rect(width/2, height/2, widthRect, widthRect);
  text(jsonRandom.getFloat("value"),5,15);
}

// --------------------------------------------
void keyPressed()
{
  if (key == 's')
  {
    cp5.saveProperties(sketchPath("data/tools"));
  } else if (key == 'e')
  {
    saveFrame("data/export.jpg");
  } else if (key == 'r')
  {
    jsonRandom.setFloat("value", random(100));
    saveJSONObject(jsonRandom, "data/randomid.json");
  }
}

// --------------------------------------------
void controlEvent(ControlEvent e )
{
  //  println(e);
}