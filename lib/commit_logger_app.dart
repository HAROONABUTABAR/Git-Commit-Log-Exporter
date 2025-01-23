// Commit Parsing Service (Single Responsibility)
import 'package:export_git_to_pdf/commit_model.dart';
import 'package:export_git_to_pdf/directory_not_found_expeption.dart';
import 'package:export_git_to_pdf/i_git_service.dart';
import 'package:export_git_to_pdf/ifiles_system_service.dart';
import 'dart:io' as io;

class CommitParser {
  List<Commit> parseCommits(String commitLog, String project) {
    final List<Commit> commits = [];

    // Split the commit log by the string "commit ", but keep the rest intact
    final commitEntries = commitLog
        .split(RegExp(r'(?=commit )'))
        .where((entry) => entry.isNotEmpty);

    print("Total commits found: ${commitEntries.length}");

    for (var entry in commitEntries) {
      final authorMatch =
          RegExp(r'Author:\s*(.+?)\s*<(.+?)>').firstMatch(entry);
      final messageMatch = RegExp(r'Date:.*?\n\n\s*(.+)').firstMatch(entry);
      if (authorMatch != null && messageMatch != null) {
        final author = authorMatch.group(1) ?? '';
        final email = authorMatch.group(2) ?? '';
        final message = messageMatch.group(1)?.trim() ?? '';

        commits.add(Commit(
            author: author, email: email, message: message, project: project));
      }
    }

    return commits;
  }
}

// Main Application Class (Dependency Inversion)
class CommitLoggerApp {
  final IFileSystemService fileSystemService;
  final IGitService gitService;
  final CommitParser commitParser;

  CommitLoggerApp({
    required this.fileSystemService,
    required this.gitService,
    required this.commitParser,
  });

  Future<List<Commit>> run(
    String rootPath,
    String author,
    String after,
    String before,
  ) async {
    print("Root path $rootPath");
    try {
      final directories = await fileSystemService.listDirectories(rootPath);
      List<Commit> allCommits = [];

      for (final directory in directories) {
        final commitLog = await gitService.getCommitLog(directory,
            author: author, after: after, before: before);

        // Extracting the project name as the parent folder of the .git directory
        final project = io.Directory(directory).parent.path.split('/').last;

        final commits = commitParser.parseCommits(commitLog, project);
        allCommits.addAll(commits);
      }

      print('Found ${allCommits.length} commits');
      return allCommits;
    } on DirectoryNotFoundException {
      print('Error: The directory does not exist.');
      return [];
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }
}
