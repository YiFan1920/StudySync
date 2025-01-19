enum Players {
  james("James", imagePath: "assets/avatar_face/face 2.jpeg", points: 587),
  ellie("Ellie", imagePath: "assets/avatar_face/face 1.jpeg", points: 345),
  peter("Peter", imagePath: "assets/avatar_face/face 2.jpeg", points: 4564),
  adam("Adam", imagePath: "assets/avatar_face/face 2.jpeg", points: 5464),
  justin("Justin", imagePath: "assets/avatar_face/face 2.jpeg", points: 654),
  lebron("Lebron", imagePath: "assets/avatar_face/face 2.jpeg", points: 5587),
  lisa("Lisa", imagePath: "assets/avatar_face/face 1.jpeg", points: 463),
  jennie("Jennie", imagePath: "assets/avatar_face/face 1.jpeg", points: 6450),
  alice("Allice", imagePath: "assets/avatar_face/face 1.jpeg", points: 64),
  parker("Parker", imagePath: "assets/avatar_face/face 2.jpeg", points: 876),
  drake("Drake", imagePath: "assets/avatar_face/face 2.jpeg", points: 344),
  sheeta("Seeta", imagePath: "assets/avatar_face/face 1.jpeg", points: 253);

  final String name;
  final String imagePath;
  final int points;

  const Players(this.name, {required this.imagePath, required this.points});

  static int getLength = Players.values.length;
}
