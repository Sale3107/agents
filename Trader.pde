class Trader extends Person {
  
  Trader(String tname){
    super(tname);
    displaycolour = color(220, 140, 75);
    
  }
  
  void update() {
    
  }
  
  Optional<Location> shouldTransfer() {
    return new Optional<Location>();
  }
  
}
