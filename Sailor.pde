class Sailor extends Person {
  
  int clock = 0;
  int cycleTime = 20;
  
  Location home;
  
  Sailor (String tname, Location _home) {
    super(tname);
    increment = 0.005;
    displaycolour = color(100, 160, 225);
    home = _home;
  }
  
  Optional<Location> shouldTransfer() {
    clock++;
    
    if (clock > cycleTime) {
      clock = 0;
      if (p_location == home) { 
        return new Optional<Location>(p_location.getRandomTradeRoute());
      }
        return new Optional<Location>(home);
    }
    
    return new Optional<Location>();
  }
  
}
