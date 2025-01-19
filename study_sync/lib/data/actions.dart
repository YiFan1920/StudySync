enum Actions {
  studying(phrase: [
    "Time to hit the books! ✍️",
    "Focus mode: ON. Let’s study! 💡",
  ]),
  relaxing(phrase: [
    "Relaxation mode: ON! ☀️",
    "Time to kick back and unwind! 🌊",
    "Just a little break to reset! 🧘‍♂️"
  ]),
  sleeping(phrase: [
    "Catching some Zzz’s! 😴",
    "Off to dreamland! 🌙",
    "Time for a well-deserved rest! 🌌",
    "Time to recharge the batteries! 🔋"
  ]);

  final List<String> phrase;

  const Actions({required this.phrase});

  static String getPhrase(Actions action) {
    action.phrase.shuffle();
    return action.phrase[0];
  }
}
