// Interface for File Operations (Single Responsibility)
abstract class IFileSystemService {
  Future<List<String>> listDirectories(String path);
}
