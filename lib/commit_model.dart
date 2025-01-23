// Data Class for Commit
class Commit {
  final String author;
  final String email;
  final String message;
  final String project;

  Commit({
    required this.author,
    required this.email,
    required this.message,
    required this.project,
  });

  @override
  String toString() {
    return 'author=$author, email=$email, message=$message, project=$project';
  }
}
