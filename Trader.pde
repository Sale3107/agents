class Trader extends Person {
  
  private int clock = 0;
  private int cycleTime = 10;
  
  private Location home;
  
  Trader(String tname, Location _home){
    super(tname);
    increment = 0.01;
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
