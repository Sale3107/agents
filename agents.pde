ArrayList<Location> locations = new ArrayList<Location>();
int initalLocationSize = 8;

ArrayList<Person> people = new ArrayList<Person>();
int initialPeopleSize = 0;

String[] names = {
  "Madrid", "Porto", "Tokyo", "Washington D.C", "Shanghai", "Moscow", "Quebec", "Ottowa",
  "Dublin", "Paris", "Berlin", "Rome", "London", "Reikjavik", "Athens", "Sydney","Oslo",
  "Copenhagen", "Stockholm", "Innsbruck", "Lisbon",
};

String createdName = "";
PVector locPos;

String mode = "MAP";
float increment = 0.02;
Location selectedLocation;
int time1;


void setup() {
  background(66, 69, 56);
  fullScreen();
  
  time1 = millis();
  
  //generate a field of evenly distributed points and assign the laocitons to towns
  ArrayList<PVector> distributedPoints = generatePoints(initalLocationSize, width - 250,  height - 250);
  for (int i  = 0; i < distributedPoints.size(); i++) {
    PVector currentPoint = distributedPoints.get(i);
    currentPoint.add(new PVector(125, 125));
  }
  
  //Create towns and assign properties
  for (int i = 0; i < initalLocationSize; i++) {
    int p = round(random(500, 1200));
    boolean isTown;
    if (p < 700) {
       isTown = true;
    } else {
      isTown = false;
    }
    locations.add(new Location(names[i], distributedPoints.get(i), p, i, isTown));
  }
  
  //generate trade routes
  for (int i = 0; i < locations.size(); i++) {
    locations.get(i).setTradeRoutes(generateRoutes(locations, locations.get(i), 500));
    locations.get(i).setConnections(generateRoutes(locations, locations.get(i), 750));
    locations.get(i).setSailRoute(findSailRoute(locations.get(i)));
    
    
    if(locations.get(i).tradeRoutes.size() > 0){
      int amount = locations.get(i).tradeRoutes.size();
      if(amount > 3){
        amount = 3;
      }
      for (int k = 0; k < amount; k++){
        Trader t = new Trader(locations.get(i).name + " Trader", locations.get(i));
        people.add(t);
        locations.get(i).assign_person(t);
      }
    }
    
    if(locations.get(i).connections.size() > 0){
      for(int k = 0; k < 2; k++){
        Traveller tv = new Traveller(locations.get(i).name + " Traveller", locations.get(i));
        people.add(tv);
        locations.get(i).assign_person(tv);
      }
    }
    
    Sailor s = new Sailor(locations.get(i).name + " Sailor", locations.get(i));
    people.add(s);
    locations.get(i).assign_person(s);
    
  }
}

void draw() {
  
  if (millis() > time1 + 1000)
  {
    transferPeople();
    time1 = millis();
  }

  background(69, 71, 57);
  if (mode == "MAP") {

    drawLines();
    for (int i = 0; i < people.size(); i++) {
      if (people.get(i).isTransferring) {
        people.get(i).displayTransfer();

      }
    }
    
    for (int i = 0; i < locations.size(); i++) {
      locations.get(i).setRenderPosition(locations.get(i).position);
      locations.get(i).setRenderSize(45);
      locations.get(i).display(true, true, true, true, true);
    }
    
  } else if (mode == "SINGLE") {
    PVector center = new PVector(width / 2, height / 2);
    selectedLocation.setRenderPosition(center);
    selectedLocation.setRenderSize(100);
    selectedLocation.display(true, false, false, false, false);
    selectedLocation.displayTradeRoutes();
    for (int i = 0; i < selectedLocation.current_people.size(); i++){
      PVector render_position = new PVector(int(center.x + 75) , int(center.y - 40) + (i * 24));
      selectedLocation.displayPerson(render_position, 20, i);
    }
    
    
  } else if (mode == "NEWLOC") {
    
    for (int i = 0; i < locations.size(); i++) {
      stroke(190, 20);
      strokeWeight(0.5);
      line(mouseX, mouseY, locations.get(i).position.x, locations.get(i).position.y);
      locations.get(i).setRenderPosition(locations.get(i).position);
      locations.get(i).setRenderSize(45);
      locations.get(i).display(true, true, true, true, true);
    }
    
    ellipseMode(CENTER);
    stroke(110);
    strokeWeight(2.5);
    if (mouseInValidPlace()){
      fill(100, 250, 90);
    } else {
      fill(250, 90, 90);
    }
    ellipse(mouseX, mouseY, 24, 24);
    
  } else if (mode == "CREATE") {
    for (int i = 0; i < locations.size(); i++) {
      stroke(190, 20);
      strokeWeight(0.5);
      line(locPos.x, locPos.y, locations.get(i).position.x, locations.get(i).position.y);
      locations.get(i).setRenderPosition(locations.get(i).position);
      locations.get(i).setRenderSize(45);
      locations.get(i).display(true, true, true, true, true);
    }
    
    fill(140, 150, 145, 220);
    stroke(20);
    strokeWeight(2);
    ellipse(locPos.x, locPos.y, 24, 24);
    
    fill(210, 200);
    textSize(25);
    text(createdName, locPos.x, locPos.y + 30);
    
  }
}

void mouseClicked() {
  if (mode == "MAP" || mode == "SINGLE") {
    for (int i = 0; i < locations.size(); i ++){
      if (locations.get(i).checkIfMouseOver()){
        if (mouseButton == LEFT){
          println("Mouse has been clicked on: " + locations.get(i).name);
          selectedLocation = locations.get(i);
          mode = "SINGLE";
        } else if (mouseButton == RIGHT){
          removeLocation(locations.get(i));
        }
        
      }
    }
  } else if (mode == "NEWLOC"){
    if (mouseInValidPlace()){
      locPos = new PVector(mouseX, mouseY);
      mode = "CREATE";
    } else {
      println("Location in invalid position.");
    }
    
  } else if (mode == "CREATE"){
    createNewLocation(locPos, createdName);
    createdName = "";
    mode = "MAP";
  }
}

void keyPressed() {  //This is fucking stupid and i hate it.
  if (mode == "CREATE"){  
    createdName += key;
  } else if (mode == "MAP"){
    if (key == '0'){
      mode = "NEWLOC";
    }
  }
  
  if ((mode != "CREATE")){
    if (key == 'm' || key == 'M') {
      mode = "MAP";
    } else if (key == 'a' || key == 'A') {
      mode = "AGENT";
    }
  }
}

void transferPeople() {
  for (int i = 0; i < people.size(); i++) {
    if (people.get(i).isTransferring) {
      continue;
    }
    
    Optional<Location> l = people.get(i).shouldTransfer();
    
    if (l.hasValue) {
      people.get(i).startTransfer(people.get(i).p_location, l.value);
    }
  }
}

void drawLines() {
  for (int i = 0; i < locations.size(); i++) {  //Loop through every location:
    
    if (locations.get(i).checkIfMouseOver()){  //Check if it is being moused Over.
      
      for (int t = 0; t < locations.size(); t++) {  // if it is, then loop through the rest of the locations,
        if (!(t == i)) {  //check if the location is itself.
          if (locations.get(i).tradeRoutes.contains(locations.get(t))){  //and check if it is a trade route.
            stroke(190, 90, 70, 255);  //if it is, then use these display colours.
            strokeWeight(3);
          } else if (locations.get(i).connections.contains(locations.get(t))) {
            stroke(230, 175, 150);
            strokeWeight(2);
          } else {
            stroke(180, 150);  //if not, then use these default ones.
            strokeWeight(1);
          }
          if(locations.get(i).sailRoute == locations.get(t)){
            strokeWeight(4);
            stroke(100, 160, 225);
            noFill();
            float ax1 = locations.get(i).getX();
            float ay1 = locations.get(i).getY();
            float cx1 = locations.get(i).getX() + 10;
            float cy1 = locations.get(i).getY() - 300;
            float cx2 = locations.get(t).getX() - 10;
            float cy2 = locations.get(t).getY() - 300;
            float ax2 = locations.get(t).getX();
            float ay2 = locations.get(t).getY();
            bezier(ax1, ay1, cx1, cy1, cx2, cy2, ax2, ay2);
          } else {
            line(locations.get(i).position.x, locations.get(i).position.y, locations.get(t).position.x, locations.get(t).position.y);
          }
          
          
        }
      }
    }
    
    for (int k = i + 1; k < locations.size(); k++){
        if (locations.get(i).tradeRoutes.contains(locations.get(k))){
          stroke(190, 90, 70, 40);  //if it is, then use these display colours.
          strokeWeight(1.3);
        } else if(locations.get(i).connections.contains(locations.get(k))){
          stroke( 234, 211, 118, 40);
          strokeWeight(1.2);
        } else if(locations.get(i).sailRoute == locations.get(k)){
          strokeWeight(1.1);
          stroke(80, 140, 210, 40);
        } else {
          stroke(240, 40);
          strokeWeight(1);
        }
      line(locations.get(i).position.x, locations.get(i).position.y, locations.get(k).position.x, locations.get(k).position.y);
      
  }   
 }
}

void removeLocation(Location loc){
  //if the location is the last locaiton
  if (locations.size() == 1) {
    return;
  }
  
  locations.remove(locations.indexOf(loc));
  
  loc.exists = false;
  
  //Remove tradeRoute reference from other nodes
  for (int i = 0; i < loc.tradeRoutes.size(); i++) {
    Location traderReference = loc.tradeRoutes.get(i); 
    traderReference.tradeRoutes.remove(traderReference.tradeRoutes.indexOf(loc));
  }

  //if there are no remaining tradeRoutes at the location
  if (loc.tradeRoutes.size() == 0) {
    for (int i = 0; i < loc.current_people.size(); i++) {
      loc.current_people.get(i).startTransfer(loc, locations.get(floor(random(0, locations.size()))));
    }
    return;

  }
  
  //Transfer people through trade routes
  for (int i = 0; i < loc.current_people.size(); i++) {
    Location targetLocation = loc.getRandomTradeRoute();
    loc.current_people.get(i).startTransfer(loc, targetLocation);
  }
}

void createNewLocation(PVector position, String name){  //Click '0' to start the new location mode, then click anywhere on the screen. Then, type the name and click again.
  int p = round(random(500, 1200));
  boolean isTown;
  if (p < 700) {
     isTown = true;
  } else {
    isTown = false;
  }
  Location newLocation = new Location(name, position, p, locations.size(), isTown);
  locations.add(newLocation);
  
  for (int i = 0; i < locations.size(); i++){
    locations.get(i).setTradeRoutes(generateRoutes(locations, locations.get(i), 500));
  }
  
}

boolean mouseInValidPlace(){
  for (int i = 0; i < locations.size(); i++) {
      if (locations.get(i).checkIfMouseOver()){
        return false;
      }
    }
  
  return true;
  
}

ArrayList<PVector> generatePoints(int amount, int canvasWidth, int canvasHeight)
{
    ArrayList<PVector> points = new ArrayList<PVector>();

    points.add(new PVector(random(canvasWidth), random(canvasHeight)));

    for (int iii = 1; iii < amount; iii++)
    {

        //generate 10 points
        PVector[] candidates = new PVector[10];
        for (int i = 0; i < 10; i++)
        {
            candidates[i] = new PVector(random(canvasWidth), random(canvasHeight));
        }

        //find furthest candidate from active points
        PVector furthestVector = new PVector(0,0);
        float vectorDistance = 0;
        for (int i = 0; i < 10; i++)
        {
            //find closest distance from active points to candidate
            float furthestDistanceFromKnownPoints = canvasWidth * canvasHeight;
            for (int ii = 0; ii < points.size(); ii++)
            {
                PVector point = points.get(ii);
                float dist = dist(candidates[i].x, candidates[i].y, point.x, point.y);
                furthestDistanceFromKnownPoints = min(furthestDistanceFromKnownPoints, dist);
            }

            if (furthestDistanceFromKnownPoints > vectorDistance)
            {
                vectorDistance = furthestDistanceFromKnownPoints;
                furthestVector = candidates[i];
            }
        }
        
        //add point to list
        points.add(furthestVector);

    }

    return points;
}

ArrayList<Location> generateRoutes(ArrayList<Location> all_locations, Location currentLocation, int threshold) {
  ArrayList<Location> routes = new ArrayList<Location>();
  for (int i = 0; i < all_locations.size(); i++){
    Location otherLocation = all_locations.get(i);
    if (currentLocation != otherLocation){
      float d = dist(currentLocation.position.x, currentLocation.position.y, otherLocation.position.x, otherLocation.position.y);
      if (d <= threshold) {
        routes.add(otherLocation);
      }
    }
  }
  
  return routes;
  
}

Location findSailRoute(Location currentLocation){
  Location furthestLocation = currentLocation;
  float oldDist = 0;
  for(int i = 1; i < locations.size(); i++){
    float d = dist(currentLocation.getX(), currentLocation.getY(), locations.get(i).getX(), locations.get(i).getY());
    println(oldDist);
    if(d > oldDist){
      oldDist = d;
      furthestLocation = locations.get(i);
    }    
  }
  return furthestLocation; 
}


    
