class Enemy extends Person {
  Enemy (String tempname) {
    super(tempname);
    displaycolour = color(getRC(210, 255), getRC(1, 30), getRC(10, 30));
  }
}
