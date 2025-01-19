enum Activities {
  leetcodeEasy("Leetcode Easy", points: 10),
  leetcodeMedium("Leetcode Medium", points: 20),
  leetcodeHard("Leetcode Hard", points: 40);

  final int points;

  const Activities(String name, {required this.points});
}
