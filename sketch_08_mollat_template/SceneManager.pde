class SceneManager
{
  HashMap<String, Scene> scenes;
  ArrayList<Scene> scenesSequence;
  Scene sceneCurrent;
  int indexSequence = 0;

  float timeOnBeginAnimCall = 2.0f;
  float timeChangeScene = 30.0f;
  float time = 0.0f;

  boolean bSequenceEnabled = false;
  boolean bChangeScene = false;
  boolean bHasFaceZoomed = false;

  // --------------------------------------------
  SceneManager()
  {
    scenes = new HashMap<String, Scene>();
    scenesSequence = new ArrayList<Scene>();
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
  void addForSequence(String name)
  {
    Scene scene = scenes.get(name);
    if (scene != null)
      scenesSequence.add(scene);
  }

  // --------------------------------------------
  void enableSequence()
  {
    if (scenesSequence.size() >= 2)
    {
      indexSequence = 0;
      sceneCurrent = scenesSequence.get(indexSequence);
      
      bSequenceEnabled = true;
    }
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
    if (bSequenceEnabled == false)
    {
      sceneCurrent = scenes.get(name);
      if (sceneCurrent != null)
        sceneCurrent.reset();
    }
  }

  // --------------------------------------------
  Scene get(String name)
  {
    return scenes.get( name );
  }

  // --------------------------------------------
  void update(float dt)
  {
    if (bSequenceEnabled)
    {
      if (bHasFaceZoomed == false)
        if (faceOSC.getState() == FaceOSC.STATE_ZOOMED)
          bHasFaceZoomed = true;
      
      time += dt;
      if (time >= timeChangeScene && bHasFaceZoomed)
      {
        bChangeScene = true;

        if (bChangeScene && (faceOSC.getState() == FaceOSC.STATE_REST && faceOSC.getStateTime()>=2.0f))
        {
          indexSequence = (indexSequence+1) % scenesSequence.size();
          sceneCurrent = scenesSequence.get(indexSequence);
          
          time = 0.0;
          bChangeScene = false;
          bHasFaceZoomed = false;
        }
      }
    }
  }
}