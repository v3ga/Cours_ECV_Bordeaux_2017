class Agent
{
  
 void findDestinationPixelFrom(PImage img, int x, int y, int area)
 {
    boolean[] visited = new boolean[area*area];
    for (int i=0;i<visited.length;i++){
      visited[i] = false;
    }

    int xMin = max(x-area,0);
    int xMax = min(x+area,img.width);
    int yMin = max(y-area,0);
    int yMax = min(y+area, img.height);

    int nbVisited = 0;
    boolean destinationFound = false;
    while(nbVisited < visited.length && !destinationFound)
    {
      int i = (int) random(0,area+1);
      int j = (int) random(0,area+1);
        
    }
   
 }
}