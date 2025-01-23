
// Concrete Implementation of File Operations
import 'package:export_git_to_pdf/directory_not_found_expeption.dart';
import 'package:export_git_to_pdf/ifiles_system_service.dart';
import 'dart:io' as io;


class FileSystemService implements IFileSystemService {
  @override
  Future<List<String>> listDirectories(String path) async {
    final dir = io.Directory(path);

    if (!await dir.exists()) {
      throw DirectoryNotFoundException();
    }

    return dir
        .listSync(recursive: true)
        .whereType<io.Directory>()
        .where((dir) => dir.path.endsWith('.git'))
        .map((dir) => dir.path)
        .toList();
  }
}
