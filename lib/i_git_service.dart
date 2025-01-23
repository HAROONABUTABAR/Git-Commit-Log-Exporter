// Interface for Git Operations (Single Responsibility)
abstract class IGitService {
  Future<String> getCommitLog(
    String path, {
    required String author,
    required String after,
    required String before,
  });
}
