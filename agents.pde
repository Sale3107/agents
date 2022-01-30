//Location[] locations;
ArrayList<Location> locations = new ArrayList<Location>();
int initalLocationSize = 5;

Person[] people;

Agent[] agents;
Civilian[] civilians;
Enemy[] enemies;

PVector newPos;

String amongus;

String[] names = {
  "Madrid", "Porto", "Tokyo", "Washington D.C", "Shanghai", "Moscow", "Quebec", "Ottowa",
  "Dublin", "Paris", "Berlin", "Rome", "London", "Reikjavik", "Athens", "Sydney","Oslo",
  "Copenhagen", "Stockholm", "Innsbruck", "Lisbon",
};

String mode = "MAP";
float increment = 0.02;
Location selectedLocation;
int time1;
int timer2;

String gay = "among us";

void setup() {
  background(66, 69, 56);
  fullScreen();
  
  time1 = millis();
  timer2 = millis();
  
  agents = new Agent[15];
  civilians = new Civilian[12];
  enemies = new Enemy[10];
  
  people = new Person[agents.length + civilians.length + enemies.length];
  
  ArrayList<PVector> distributedPoints = generatePoints(initalLocationSize, width - 250,  height - 250);
  for (int i  = 0; i < distributedPoints.size(); i++) {
    PVector currentPoint = distributedPoints.get(i);
    currentPoint.add(new PVector(125, 125));
  }
  
  for (int i = 0; i < initalLocationSize; i++) {
    int p = round(random(500, 1200));
    boolean isTown;
    if (p < 700) {
       isTown = true;
    } else {
      isTown = false;
    }
    String name = names[floor(random(0, names.length))];
    locations.add(new Location(name, distributedPoints.get(i), round(random(500, 1200)), i, isTown));
  }
  
  for (int i = 0; i < locations.size(); i++) {
    Location cLocation = locations.get(i);
    locations.get(i).setTraders(generateTradeRoutes(locations, locations.get(i)));
  }
  
  
  for (int i = 0; i < agents.length; i++) {
    int random_number = int(random(locations.size()));
    agents[i] = new Agent("agent" + str(i));
    people[i] = agents[i];
    locations.get(random_number).assign_person(agents[i]);
  }
  
  for (int i = 0; i < civilians.length; i++) {
    int random_number = int(random(locations.size()));
    civilians[i] = new Civilian("civilian" + str(i));
    people[i + agents.length] = civilians[i];
    locations.get(random_number).assign_person(civilians[i]);
  }
  
  for (int i = 0; i < enemies.length; i++) {
    int random_number = int(random(locations.size()));
    enemies[i] = new Enemy("enemy" + str(i));
    people[i + agents.length + civilians.length] = enemies[i];
    locations.get(random_number).assign_person(enemies[i]);
  }
  
  
}

void draw() {
  
  if (millis() > time1 + 1000)
  {
    transferAgents();
    time1 = millis();
  } 
  
  if(millis() > timer2 + 1000) {
    //transferResources();
    timer2 = millis();
  }

  background(69, 71, 57);
  if (mode == "MAP") {
    //drawRelationships();
    drawLines();
    //drawLinesFromLineList();
    for (int i = 0; i < people.length; i++) {
      if (people[i].isTransferring) {
        people[i].displayTransfer();
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
    for (int i = 0; i < agents.length; i++) {
      PVector displayPos = new PVector(100, 200 + (i * 50));
      agents[i].display(displayPos, 40);
    }
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
  }
}

void keyPressed() {
  if (key == 'm' || key == 'M') {
    mode = "MAP";
  } else if (key == 'a' || key == 'A') {
      mode = "AGENT";
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


    
