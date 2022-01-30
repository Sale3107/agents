class Agent extends Person {
  
  String mode;
  color agentColour;
  
  Agent (String tempname) {
    super(tempname);
    displaycolour = color(getRC(40, 75), getRC(40, 75), getRC(210, 255));
  }  
  
  void display(PVector render_position, int size) {
    strokeWeight(1);
    fill(displaycolour);
    stroke(10);
    ellipse(render_position.x, render_position.y, size, size);
    fill(displaycolour);
    textAlign(LEFT);
    textSize(size * 1.1);
    fill(230);
    text(name, render_position.x + size, render_position.y + (size / 4));
    fill(255);
  }

}
