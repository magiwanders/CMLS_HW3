/* NEVER USED */

public class Polygon{
  float x, y, radius, angle; 
  int numPoints;
  
  public Polygon(float x_polygon, float y_polygon, float radius_polygon, int numPoints_polygon){
    x = x_polygon;
    y = y_polygon;
    radius = radius_polygon;
    numPoints = numPoints_polygon;
    this.angle = TWO_PI / numPoints_polygon;
    
  }
  
  public void draw(){
    pushMatrix();
    polygon(x,  y, radius, numPoints);  // Pentagon
    popMatrix();
    
  }
  
  void polygon(float x, float y, float radius, int npoints) {
    float angle = TWO_PI / npoints;
    beginShape();
    for (float a = 0; a < TWO_PI; a += angle) {
      float sx = x + cos(a) * radius;
      float sy = y + sin(a) * radius;
      vertex(sx, sy);
    }
    endShape(CLOSE);
  }
  
  
}
