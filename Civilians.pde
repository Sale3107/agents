class Civilian extends Person {
  
  Civilian (String tempname) {
    super(tempname);
    displaycolour = color(getRC(40, 75), getRC(220, 255), getRC(50, 90));
  }
}
