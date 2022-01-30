ArrayList<Location> locations = new ArrayList<Location>();
int initalLocationSize = 10;

//Person[] people;

int initialAgentSize = 9;
int initialCivSize = 9;
int initialEnemySize = 9;

ArrayList<Agent> agents = new ArrayList<Agent>();
ArrayList<Civilian> civilians = new ArrayList<Civilian>();
ArrayList<Enemy> enemies = new ArrayList<Enemy>();

ArrayList<Person> people = new ArrayList<Person>();
int initialPeopleSize = initialAgentSize + initialCivSize + initialEnemySize;

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
    locations.get(i).setTraders(generateTradeRoutes(locations, locations.get(i)));
  }
  
  //assign agents to locations
  for (int i = 0; i < initialAgentSize; i++) {
    int random_number = int(random(locations.size()));
    agents.add(new Agent("agent" + str(i)));
    people.add(agents.get(i));
    locations.get(random_number).assign_person(agents.get(i));
  }
  
  //assign civilians to locations
  for (int i = 0; i < initialCivSize; i++) {
    int random_number = int(random(locations.size()));
    civilians.add(new Civilian("civilian" + str(i)));
    people.add(civilians.get(i));
    locations.get(random_number).assign_person(civilians.get(i));
  }
  
  //assign enemies to locations
  for (int i = 0; i < initialEnemySize; i++) {
    int random_number = int(random(locations.size()));
    enemies.add(new Enemy("enemy" + str(i)));
    people.add(enemies.get(i));
    locations.get(random_number).assign_person(enemies.get(i));
  }
  
  
}

void draw() {
  
  if (millis() > time1 + 1000)
  {
    transferAgents();
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
      locations.get(i).mapDisplay();
    }
    
  } else if (mode == "SINGLE") {
    
    selectedLocation.singleDisplay();
    selectedLocation.displayTradeRoutes();
    
  } else if (mode == "AGENT") {
    
    textAlign(LEFT);
    textSize(80);
    stroke(245);
    text("agents: ", 100, 100);
    for (int i = 0; i < agents.size(); i++) {
      PVector displayPos = new PVector(100, 200 + (i * 50));
      agents.get(i).display(displayPos, 40);
    }
    
  } else if (mode == "NEWLOC") {
    
    for (int i = 0; i < locations.size(); i++) {
      stroke(190, 20);
      strokeWeight(0.5);
      line(mouseX, mouseY, locations.get(i).position.x, locations.get(i).position.y);
      locations.get(i).mapDisplay();
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
      locations.get(i).mapDisplay();
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
  if (mode == "MAP") {
    for (int i = 0; i < locations.size(); i ++){
      if (locations.get(i).checkIfMouseOver()){
        println("Mouse has been clicked on: " + locations.get(i).name);
        selectedLocation = locations.get(i);
        mode = "SINGLE";
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
  if (mode == "SINGLE"){
    if (((key == '1'))){
      createAgent(selectedLocation);
    } else if (key == '2'){
      createCivilian(selectedLocation);
    } else if (key == '3'){
      createEnemy(selectedLocation);
    } 
  } else if (mode == "CREATE"){  
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

void transferAgents() {  //Agent Transferring Manager
  for (int i = 0; i < locations.size(); i++) {  //Loop through every location.
    if (int(random(0, 2)) == 1) {  //Random chance that it will lose a person.
      if (locations.get(i).traders.size() > 0) {  //Check if it has any available trade routes
        int amountOfPeople = int(random(0, 3));  //Generate amount of people to get, then Check if it has enough people.
        if (locations.get(i).current_people.size() > amountOfPeople) {  //If it does then:  
          for (int peopleCount = 0; peopleCount < amountOfPeople; peopleCount++) {
            
            //Generate a random person from current location's 'current_people' list.
            Person newPerson = locations.get(i).current_people.get(int(random(0, locations.get(i).current_people.size())));
            
            //Generate the new location from the trade route options.
            int randomLocation = int(random(0, locations.get(i).traders.size()));
            Location newLocation = locations.get(i).traders.get(randomLocation);
            
            //Tell the person it is transferring.
            newPerson.startTransfer(locations.get(i), newLocation);        
            locations.get(i).remove_person(newPerson);  
            
          }            
        }
      }
    }
  }
}

void drawLines() {
  for (int i = 0; i < locations.size(); i++) {  //Loop through every location:
    
    if (locations.get(i).checkIfMouseOver()){  //Check if it is being moused Over.
      
      for (int t = 0; t < locations.size(); t++) {  // if it is, then loop through the rest of the locations,
        float d = dist(locations.get(i).position.x, locations.get(i).position.y, locations.get(t).position.x, locations.get(t).position.y); // generate distance between the 2 places.
        if (!(t == i)) {  //check if the location is itself.
          if (locations.get(i).traders.contains(locations.get(t))){  //and check if it is a trade route.
            stroke(190, 90, 70, 255);  //if it is, then use these display colours.
            strokeWeight(3);
          } else if (d <= 750) {
            stroke(230, 175, 150);
            strokeWeight(2);
          } else {
            stroke(180, 150);  //if not, then use these default ones.
            strokeWeight(1);
          }
          line(locations.get(i).position.x, locations.get(i).position.y, locations.get(t).position.x, locations.get(t).position.y);
          fill(25);
          textSize(10);
          float x = (locations.get(i).position.x + locations.get(t).position.x) / 2;
          float y = (locations.get(i).position.y + locations.get(t).position.y) / 2;
          text(d, x, y);
        }
      }
    }
    
    for (int k = i + 1; k < locations.size(); k++){
      float d = dist(locations.get(i).getX(), locations.get(i).getY(), locations.get(k).getX(), locations.get(k).getY());
      if (d <= 750) {
        if (locations.get(i).traders.contains(locations.get(k))){
          stroke(190, 90, 70, 40);  //if it is, then use these display colours.
          strokeWeight(1);
        } else {
          stroke(240, 40);
          strokeWeight(1);
        }
        
      line(locations.get(i).position.x, locations.get(i).position.y, locations.get(k).position.x, locations.get(k).position.y);
    }
  }   
 }
}

void createAgent(Location loc){
  Agent newAgent = new Agent("agent" + agents.size());
  agents.add(newAgent);
  people.add(newAgent);
  loc.assign_person(newAgent);
}

void createCivilian(Location loc){
  Civilian newCiv = new Civilian("civilian" + (agents.size()));
  civilians.add(newCiv);
  people.add(newCiv);
  loc.assign_person(newCiv);
}

void createEnemy(Location loc){
  Enemy newEnemy = new Enemy("enemy" + (agents.size()));
  enemies.add(newEnemy);
  people.add(newEnemy);
  loc.assign_person(newEnemy);
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
  newLocation.setTraders(generateTradeRoutes(locations, newLocation));
  locations.add(newLocation);
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

ArrayList<Location> generateTradeRoutes(ArrayList<Location> all_locations, Location currentLocation) {
  ArrayList<Location> traders = new ArrayList<Location>();
  for (int i = 0; i < all_locations.size(); i++){
    Location otherLocation = all_locations.get(i);
    if (currentLocation != otherLocation){
      float d = dist(currentLocation.position.x, currentLocation.position.y, otherLocation.position.x, otherLocation.position.y);
      if (d <= 500) {
        traders.add(otherLocation);
      }
    }
  }
  
  return traders;
  
}


    
