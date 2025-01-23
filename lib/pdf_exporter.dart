import 'package:export_git_to_pdf/commit_model.dart';
import 'dart:io' as io;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PDFExporter {
  Future<void> exportCommitLogToPdf(
      List<Commit> commits, String filePath) async {
    final pdf = pw.Document();

    // Add metadata page
    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  'Git Commit Log Report',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.black,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Generated on: ${DateTime.now()}',
                  style: pw.TextStyle(fontSize: 14, color: PdfColors.grey),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Total Commits: ${commits.length}',
                  style: pw.TextStyle(fontSize: 18),
                ),
              ],
            ),
          );
        },
      ),
    );

    // Group commits by project
    final groupedCommits = _groupCommitsByProject(commits);

    // Add content for each project using MultiPage to handle large content
    groupedCommits.forEach((project, projectCommits) {
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            return [
              pw.Header(level: 0, text: 'Project: $project'),
              pw.SizedBox(height: 10),
              _buildCommitTable(projectCommits),
            ];
          },
        ),
      );
    });

    // Save the PDF
    final file = io.File(filePath);
    try {
      await file.writeAsBytes(await pdf.save());
      print('PDF saved to $filePath');
    } catch (e) {
      print('Error saving PDF: $e');
    }
  }

  // Group commits by project name
  Map<String, List<Commit>> _groupCommitsByProject(List<Commit> commits) {
    final Map<String, List<Commit>> groupedCommits = {};
    for (final commit in commits) {
      if (!groupedCommits.containsKey(commit.project)) {
        groupedCommits[commit.project] = [];
      }
      groupedCommits[commit.project]!.add(commit);
    }
    return groupedCommits;
  }

  // Create commit table
  pw.Widget _buildCommitTable(List<Commit> commits) {
    return pw.Table(
      border: pw.TableBorder.all(width: 1, color: PdfColors.grey),
      columnWidths: {
        0: pw.FlexColumnWidth(2),
        1: pw.FlexColumnWidth(3),
        2: pw.FlexColumnWidth(5),
      },
      children: [
        // Table header row
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            _buildTableHeader('Author'),
            _buildTableHeader('Email'),
            _buildTableHeader('Message'),
          ],
        ),
        // Commit data rows
        ...commits.asMap().entries.map((entry) {
          final index = entry.key;
          final commit = entry.value;
          return pw.TableRow(
            decoration: pw.BoxDecoration(
              color: index % 2 == 0 ? PdfColors.white : PdfColors.grey200,
            ),
            children: [
              _buildTableCell(commit.author),
              _buildTableCell(commit.email),
              _buildTableCell(commit.message),
            ],
          );
        }),
      ],
    );
  }

  // Helper function for table header
  pw.Widget _buildTableHeader(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8.0),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.black,
        ),
      ),
    );
  }

  // Helper function for table cell
  pw.Widget _buildTableCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8.0),
      child: pw.Text(text, style: pw.TextStyle(fontSize: 12)),
    );
  }
}
