// Main Function
import 'dart:io';

import 'package:export_git_to_pdf/commit_logger_app.dart';
import 'package:export_git_to_pdf/file_system_service.dart';
import 'package:export_git_to_pdf/git_service.dart';
import 'package:export_git_to_pdf/pdf_exporter.dart';

void main() async {
  // Prompt the user for input
  print('Enter the root path:');
  final rootPath = stdin.readLineSync()?.trim() ?? '';

  print('Enter the author (email):');
  final author = stdin.readLineSync()?.trim() ?? '';

  print('Enter the start date (YYYY-MM-DD):');
  final startDate = stdin.readLineSync()?.trim() ?? '';

  print('Enter the end date (YYYY-MM-DD):');
  final endDate = stdin.readLineSync()?.trim() ?? '';

  // Validate inputs
  if (rootPath.isEmpty ||
      author.isEmpty ||
      startDate.isEmpty ||
      endDate.isEmpty) {
    print('Error: All fields are required.');
    return;
  }

  // Print the collected inputs
  print('Root Path: $rootPath');
  print('Author: $author');
  print('Start Date: $startDate');
  print('End Date: $endDate');

  final app = CommitLoggerApp(
    fileSystemService: FileSystemService(),
    gitService: GitService(),
    commitParser: CommitParser(),
  );

  const outputPath = 'commit_log.pdf'; // --> OutPub

  // Run the app and get the list of commits
  final commits = await app.run(rootPath, author, startDate, endDate);

  // You can now save the commits to a PDF or do something else
  if (commits.isNotEmpty) {
    final pdfExporter = PDFExporter();
    await pdfExporter.exportCommitLogToPdf(commits, outputPath);
  }
}
