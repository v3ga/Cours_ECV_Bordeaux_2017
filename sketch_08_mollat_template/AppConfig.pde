// --------------------------------------------
class AppConfig
{
  String name;
  int windowWidth = 600, windowHeight = 800; 
  boolean bFullscreen = false;
  int controlTabX = 0, controlTabY = 0;

  // --------------------------------------------
  AppConfig(String name_, int ww_, int wh_, boolean fullscreen_, int controlTabX_, int controlTabY_)
  {
    this.name = name_;
    this.windowWidth = ww_;
    this.windowHeight = wh_;
    this.bFullscreen = fullscreen_;
    this.controlTabX = controlTabX_;
    this.controlTabY = controlTabY_;
  }
}

// --------------------------------------------
class AppConfigs extends ArrayList<AppConfig>
{
  // --------------------------------------------
  AppConfig select(String name)
  {
    for (AppConfig config : this)
    {
      if (config.name.equals(name))
        return config;
    }
    return null;
  }

  // --------------------------------------------
  void load(String filename)
  {
    String pathFile = sketchPath(filename);
    println("   loading '"+pathFile+"'");
    
    JSONArray configs = loadJSONArray(pathFile);
    for (int i = 0; i < configs.size(); i++) 
    {
      JSONObject jsonConfig = configs.getJSONObject(i);

      String name = jsonConfig.getString("name");
      int ww = jsonConfig.getInt("windowWidth");
      int wh = jsonConfig.getInt("windowHeight");
      boolean bFullscreen = jsonConfig.getBoolean("fullscreen");
      int cTabX = jsonConfig.getInt("controlTabX");
      int cTabY = jsonConfig.getInt("controlTabY");

      println("   new config '"+name+"'");


      add( new AppConfig(name,ww,wh,bFullscreen,cTabX,cTabY));
    }
  }
}