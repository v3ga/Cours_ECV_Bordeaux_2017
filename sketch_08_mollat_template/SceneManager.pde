class SceneManager
{
  HashMap<String, Scene> scenes;
  Scene sceneCurrent;
  
  float timeOnBeginAnimCall = 2.0f;

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
    scene.setSceneManager(this);
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
    if (sceneCurrent != null)
      sceneCurrent.reset();
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