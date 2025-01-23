// Concrete Implementation of Git Operations
import 'package:export_git_to_pdf/i_git_service.dart';
import 'dart:io' as io;

class GitService implements IGitService {
  @override
  Future<String> getCommitLog(
    String path, {
    required String author,
    required String after,
    required String before,
  }) async {
    final result = await io.Process.run(
      'git',
      [
        'log',
        '--author',
        author,
        '--after',
        after,
        '--before',
        before,
      ],
      workingDirectory: path,
    );

    if (result.stderr != null && result.stderr.isNotEmpty) {
      throw Exception('Git Error: ${result.stderr}');
    }

    return result.stdout;
  }
}
