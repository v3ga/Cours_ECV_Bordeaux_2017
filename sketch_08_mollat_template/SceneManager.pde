class SceneManager
{
  HashMap<String, Scene> scenes;
  Scene sceneCurrent;
  
  // --------------------------------------------
  SceneManager()
  {
    scenes = new HashMap<String,Scene>();
  }

  // --------------------------------------------
  void add(Scene scene)
  {
    scenes.put( scene.name, scene );
  }

  // --------------------------------------------
  Scene get(String name)
  {
    return scenes.get( name );
  }

  // --------------------------------------------
  void update()
  {}

  // --------------------------------------------
  void draw()
  {}

}