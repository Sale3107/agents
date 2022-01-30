class Trader extends Person {
  
  int clock = 0;
  int cycleTime = 10;
  
  Location home;
  
  Trader(String tname, Location _home){
    super(tname);
    displaycolour = color(220, 140, 75);
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
