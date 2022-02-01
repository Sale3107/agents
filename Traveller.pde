class Traveller extends Person {
  
  private int clock = 0;
  private int cycleTime = 7;
  private int cycleStage = 0;
  
  private Location home;
  
  Traveller (String tname, Location _home) {
    super(tname);
    increment = 0.012 - random(0, 0.0025);
    displaycolour = color(240, 235, 140);
    home = _home;
  }
  
  int getCycleStage(){
    return cycleStage;
  }
  
 
  Optional<Location> shouldTransfer() {
    clock++;
    
    if (clock > cycleTime) {
      clock = 0;
      if (cycleStage < 4){
        cycleStage++;
        return new Optional<Location>(p_location.connections.get(floor(random(0, p_location.connections.size()))));
      } else if(cycleStage == 4){
        cycleStage = 0;
        if (p_location.connections.contains(home)){
          return new Optional<Location>(home);
        }
        }
      }
  
    return new Optional<Location>();
  
  }
  
}
