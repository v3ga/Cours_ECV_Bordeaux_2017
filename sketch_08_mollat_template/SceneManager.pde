class SceneManager
{
  HashMap<String, Scene> scenes;
  Scene sceneCurrent;

  // --------------------------------------------
  SceneManager()
  {
    scenes = new HashMap<String, Scene>();
  }

  // --------------------------------------------
  Scene getCurrent() {
    return sceneCurrent;
  }

  // --------------------------------------------
  void add(Scene scene)
  {
    scenes.put( scene.name, scene );
  }

  // --------------------------------------------
  void setup()
  {
    for (Scene scene : scenes.values())
      scene.setup();
  }
  
  // --------------------------------------------
  void select(String name)
  {
    sceneCurrent = scenes.get(name);
  }

  // --------------------------------------------
  Scene get(String name)
  {
    return scenes.get( name );
  }

  // --------------------------------------------
  void update()
  {
  }

  // --------------------------------------------
  void draw()
  {
  }
}