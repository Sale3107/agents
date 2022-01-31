class Sailor extends Person {
  
  private int clock = 0;
  private int cycleTime = 20;
  
  private Location home;
  
  Sailor (String tname, Location _home) {
    super(tname);
    increment = 0.0006 + random(0.001, 0.0002);
    displaycolour = color(100, 160, 225);
    home = _home;
  }
  
  Optional<Location> shouldTransfer() {
    clock++;
    
    if (clock > cycleTime) {
      clock = 0;
      if (p_location == home) { 
        return new Optional<Location>(home.sailRoute);
      }
        return new Optional<Location>(home);
    }
    
    return new Optional<Location>();
  }
  
}
