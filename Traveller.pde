class Traveller extends Person {
  
  private int clock = 0;
  private int cycleTime = 3;
  private int cycleStage = 0;
  
  private Location home;
  
  Traveller (String tname, Location _home) {
    super(tname);
    increment = 0.0125;
    displaycolour = color(240, 235, 140);
    home = _home;
  }
  
  Optional<Location> shouldTransfer() {
    clock++;
    
    if (clock > cycleTime) {
      clock = 0;
      if (cycleStage != 4) {
        Location newLocation = p_location.connections.get(floor(random(0, p_location.connections.size())));
        cycleStage++;
        return new Optional<Location>(newLocation);
      } else if(cycleStage == 4){
        
        for(int i = 0; i < p_location.connections.size(); i++){
          if(p_location.connections.contains(home)){
            cycleStage = 5;
            return new Optional<Location>(p_location.connections.get(i));
          }
        }
        
        cycleStage = 0;
        return new Optional<Location>(home);
        
      } else if(cycleStage == 5){
        cycleStage = 0;
        return new Optional<Location>(home);
      } 
    }
  
    return new Optional<Location>();
  
  }
  
}
