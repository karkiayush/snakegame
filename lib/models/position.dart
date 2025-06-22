class Position {
  final int x;
  final int y;

  Position(this.x, this.y);

  /*For finding whether the position of snake head and food is at same coordinate, if true then they are at same position and snake ate the food*/
  bool equals(Position other) {
    return x == other.x && y == other.y;
  }
}
