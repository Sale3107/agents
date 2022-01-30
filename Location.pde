class Location {

  String name;
  PVector position;
  int population;
  int wealth;
  int outerSquareW;
  int innerColour;
  
  boolean isTown;
  
  ArrayList<Person> current_people = new ArrayList<Person>();
  ArrayList<Location> tradeRoutes = new ArrayList<Location>();
  ArrayList<Location> connections = new ArrayList<Location>();
  
  boolean exists = true;
  
  Location (String tempname, PVector temppos, int temppopulation, int initialwealth, boolean t_isTown) {
    name = tempname;
    position = temppos;
    population = temppopulation;
    outerSquareW = 45;
    isTown = t_isTown;
    
    wealth = initialwealth;
    
    innerColour = color(int(random(40, 190)), int(random(80, 150)), int(random(20, 140)));
    
  }
  
  void setTradeRoutes(ArrayList<Location> temp_traders) {
    tradeRoutes = temp_traders;
  }
  
  void setConnections(ArrayList<Location> temp_connections){
    connections = temp_connections;
  }
  
  float getX() {
    return position.x;
  }
  
  float getY() {
    return position.y;
  }
  
  String name() {
    return name;
  }
  
  PVector coordinates() {
    return position;
  }
  
  void tradeDisplay(PVector renderPosition, float size) {
    strokeWeight(1);
    stroke(1);
    fill(200, 190, 195);
    //Outer Square:
    rectMode(CENTER);
    square(renderPosition.x, renderPosition.y, size);
    //Inner Square Colour Logic:
    if (checkIfMouseOver()) {
      fill(220, 222, 254);
    } else {
      fill(innerColour);
    }
    square(renderPosition.x, renderPosition.y, size / 2);
    fill(255);
    textAlign(CENTER);
    textSize(10);
    text(name, renderPosition.x, renderPosition.y + (size - 2));
  }
  
  void mapDisplay() {
    float r;
    strokeWeight(1);
    stroke(1);
    fill(200, 190, 195, 255);
    //Outer Square:
    if (isTown) {
      
      ellipseMode(CENTER);
      ellipse(position.x, position.y, outerSquareW - 2, outerSquareW - 2);
    } else {
      
      rectMode(CENTER);
      square(position.x, position.y, outerSquareW);
    }  
    
    //Inner Square Colour Logic:
    if (checkIfMouseOver()) {
      fill(220, 222, 254, 255);
      display_agents();
    } else {
      fill(innerColour);
    }
    
    if (isTown) {
      r = 10 + (population / 90);
      ellipse(position.x, position.y, r, r);
    } else {
      r = 10 + (population / 55);
      square(position.x, position.y, r);
    }
    
    
    fill(255, 255, 255, 255);
    //Name Text:
    textAlign(CENTER);
    textSize(12);
    text(name, position.x, position.y + 40);
    //Population text:
    fill(19);
    textSize(12);
    text("P: " + population, position.x, position.y - 30);
    fill(200, 210, 0, 200);
    textSize(11);
    text("i: " + wealth, position.x, position.y - 42);
    //Display trade routes as text.
    for (int i = 0; i < tradeRoutes.size(); i++) {
      Location current_trader = tradeRoutes.get(i);
      fill(180);
      textSize(10);
      text(current_trader.name, position.x, position.y + 50 + (i * 10));
    }
  }
  
  void singleDisplay() {
    float r = 10 + (population / 13.75);
    strokeWeight(1);
    stroke(1);
    fill(200, 190, 195);
    //Outer Square:
    rectMode(CENTER);
    square(width / 2, height / 2, 180);
    //Inner Square:
    fill(innerColour);
    square(width / 2, height / 2, r);
    fill(255);
    textAlign(CENTER);
    textSize(20);
    text(name, width / 2, height / 2 + 120);
    
    for (int i = 0; i < current_people.size(); i++) {
      Person active_agent = current_people.get(i);
      PVector render_position = new PVector(int((width / 2) + 130) , int((height / 2) - 75) + (i * 40));
      active_agent.display(render_position, 30);
    }
    
  }
  
  void displayTradeRoutes() {
    for (int i = 0; i < tradeRoutes.size(); i++) {
      Location active_loc = tradeRoutes.get(i);
      PVector render_position = new PVector(int((width / 2) - 150) , int((height / 2) - 75) + (i * 50));
      active_loc.tradeDisplay(render_position, 30);
    }
  }
  
  
  boolean checkIfMouseOver(){
    int locWidth = (outerSquareW / 2) + 10;
    if ((mouseX < position.x + locWidth)&&(mouseX > position.x - locWidth)){
        if ((mouseY < position.y + locWidth)&&(mouseY > position.y - locWidth)){
          return true;
        } else {
          return false;
        }
    } else {
      return false;
    }
  }
  
  int people() {
    return current_people.size();
  }
  
  void assign_person(Person agent) {
    current_people.add(agent);
    agent.setPLocation(this);
  }
  
  void remove_person(Person agent) {
    for (int i = 0; i < current_people.size(); i++) {
      Person current = current_people.get(i);
      if (current == agent) {
        current_people.remove(i);
      }
    }
  }
  
  void display_agents() {
    for (int i = 0; i < current_people.size(); i++) {
      Person active_agent = current_people.get(i);
      PVector render_position = new PVector(int(position.x + 30) , int(position.y - 10) + (i * 13));
      active_agent.display(render_position, 8);
    }
  }
  
  Location getRandomTradeRoute() {
    return tradeRoutes.get(floor(random(0, tradeRoutes.size())));
  }
  
}
