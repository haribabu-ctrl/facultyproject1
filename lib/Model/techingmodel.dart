class TeachingExeData {
  final String userId;
  final String username;
  final List<String> coursename;
  final List<int> s1A, s1B, s3A, s3B, s4A, s4B;
  final List<double> s2Feedback;

  TeachingExeData({
    required this.username,
    required this. coursename,
    required this.userId,
    required this.s1A,
    required this.s1B,
    required this.s2Feedback,
    required this.s3A,
    required this.s3B,
    required this.s4A,
    required this.s4B,
  });
}