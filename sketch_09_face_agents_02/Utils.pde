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