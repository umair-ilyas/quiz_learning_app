class AppUser {
  final String id;
  final String name;
  final String avatarUrl;
  final String rank;
  int score;
  int quizzesTaken;
  int totalQuizzes;

  AppUser({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.rank,
    this.score = 0,
    this.quizzesTaken = 0,
    this.totalQuizzes = 5,
  });

  AppUser copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    String? rank,
    int? score,
    int? quizzesTaken,
    int? totalQuizzes,
  }) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      rank: rank ?? this.rank,
      score: score ?? this.score,
      quizzesTaken: quizzesTaken ?? this.quizzesTaken,
      totalQuizzes: totalQuizzes ?? this.totalQuizzes,
    );
  }

  factory AppUser.dummy() => AppUser(
    id: 'user_001',
    name: 'Alex Johnson',
    avatarUrl:
        'https://api.dicebear.com/7.x/adventurer/png?seed=Alex&backgroundColor=b6e3f4',
    rank: 'Quiz Master',
    score: 0,
    quizzesTaken: 0,
    totalQuizzes: 5,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'avatarUrl': avatarUrl,
    'rank': rank,
    'score': score,
    'quizzesTaken': quizzesTaken,
    'totalQuizzes': totalQuizzes,
  };
}
