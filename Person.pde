class Person {

  Location p_location;
  String name;
  color displaycolour;
  
  //Transfer variables
  boolean isTransferring;
  Location oldLocation;
  Location newLocation;
  float transferProgress;
  float increment = 0.02;
  int queueNumber;
  
  Person (String tempname) {
  
    name = tempname;
    displaycolour = color(240, 245, 246);
    
  }
  
  int getRC(int r1, int r2) {
    int num = round(random(r1, r2));
    return num;
  }
  
  String get_name() {
    return name;
  }
  
  Location get_location() {
    return p_location;
  }
  
  void setPLocation(Location newLocation) {
    p_location = newLocation;
  }
  
  void display(PVector render_position, int size) {
    strokeWeight(1);
    fill(displaycolour);
    stroke(10);
    square(render_position.x, render_position.y, size);
    fill(displaycolour);
    textAlign(LEFT);
    textSize(size * 1.1);
    fill(230);
    text(name, render_position.x + size, render_position.y + (size / 4));
    fill(255);
  }
  
  void startTransfer(Location tempoldLocation, Location tempnewLocation) {
    tempoldLocation.remove_person(this);
    isTransferring = true;
    transferProgress = 0;
    oldLocation = tempoldLocation;
    newLocation = tempnewLocation;
  }
  
  void displayTransfer() {
    int size = 8;
    PVector circlePos = new PVector(oldLocation.position.x, oldLocation.position.y);
    transferProgress += increment;
    
    float oldX = circlePos.x;
    float oldY = circlePos.y;
    
    circlePos.x = lerp(oldX, newLocation.position.x, transferProgress);
    circlePos.y = lerp(oldY, newLocation.position.y, transferProgress);
    
    ellipseMode(CENTER);
    stroke(75);
    if ((oldLocation.checkIfMouseOver()) || (newLocation.checkIfMouseOver())) {
      stroke(10);
      strokeWeight(0.5);
      fill(displaycolour);
      size = 10;
    } else {
      fill(displaycolour + color(10, 10, 10, 40));
    }
    
    ellipse(circlePos.x, circlePos.y, size, size);
    
    if (transferProgress >= 1 - increment) {
      isTransferring = false;
      if (newLocation.exists) {
        newLocation.assign_person(this);
      } else {
        if (oldLocation.exists) {
          startTransfer(newLocation, oldLocation);
        }
        else {
          if (oldLocation.traders.size() == 0) {
            return;
          }
          startTransfer(newLocation, oldLocation.traders.get(floor(random(0, oldLocation.traders.size() - 1))));
        } 
      }
    }
    
  }

  Optional<Location> shouldTransfer()
  {
    return new Optional<Location>();
  }

}
