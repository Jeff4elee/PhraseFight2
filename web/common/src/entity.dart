part of common;

class Entity {
  num speed = .07;
  Position position;

  var displayObject;

  Entity() {
    position = new Position(0, 0);
  }

  // apply user input to this entity
  void applyInput(Input input) {
    int direction = 0;
    if (input.keyCodes.contains(PFKeyCode.RIGHT)) {
      direction++;
    }
    if (input.keyCodes.contains(PFKeyCode.LEFT)) {
      direction--;
    }

    position.x += input.pressTime * speed * direction;

    if (displayObject != null) {
      displayObject.x = position.x;
    }
  }
}
