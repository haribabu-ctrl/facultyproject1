import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:io';

import 'package:open_filex/open_filex.dart';

// Web support
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
class PaperPublication extends StatefulWidget {
  const PaperPublication({super.key});

  @override
  State<PaperPublication> createState() =>
      _ResearchPaperPublicationPageState();
}

class _ResearchPaperPublicationPageState
    extends State<PaperPublication> {
  List<ResearchRow> rows = [];

  @override
  void initState() {
    super.initState();
    rows.add(ResearchRow());
  }

  double get totalPoints {
    double sum = 0;
    for (var r in rows) {
      sum += r.points;
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Research – Paper Publication"),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headingCard(),
            const SizedBox(height: 12),
            _tableHeader(),
            const SizedBox(height: 6),
            ...rows.asMap().entries.map(
              (entry) => _tableRow(entry.key, entry.value),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      rows.add(ResearchRow());
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Add Row"),
                ),
                const SizedBox(width: 10),
                if (rows.length > 1)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red),
                    onPressed: () {
                      setState(() {
                        rows.removeLast();
                      });
                    },
                    icon: const Icon(Icons.remove),
                    label: const Text("Remove Row"),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            _totalCard(),
          ],
        ),
      ),
    );
  }

  // ================= HEADING =================
  Widget _headingCard() {
    return Card(
      color: Colors.grey.shade200,
      child: const Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "2.1 Paper publication:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text(
                "IEEE / ASME / ASCE / ACM / FT-50 / Scopus Top-10%  - 25 Points + IF"),
            Text("SCIE and Scopus (Q1/Q2) - 20 Points + IF"),
            Text("SCIE / Scopus (Q1/Q2) - 15 Points + IF"),
            Text("Scopus (Q3/Q4) / ESCI - 10 Points + IF"),
            SizedBox(height: 6),
            Text(
              "(IF – JCR 2025 impact factor will be considered for points)",
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _tableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: Colors.indigo.shade100,
      child: const Row(
        children: [
          _HeaderCell("S.No", flex: 1),
          _HeaderCell("Article details in IEEE format", flex: 4),
          _HeaderCell("Category of the Journal", flex: 3),
          _HeaderCell("JCR Impact Factor", flex: 2),
          _HeaderCell("Upload PDF", flex: 2), // ✅ NEW
          _HeaderCell("Points claimed", flex: 2),
        ],
      ),
    );
  }

  // ================= ROW =================
  Widget _tableRow(int index, ResearchRow row) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        children: [
          _cell(Text("${index + 1}"), 1),

          _cell(
            TextField(
              controller: row.articleController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: "Enter article details",
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            4,
          ),

          _cell(
            DropdownButtonFormField<String>(
              isExpanded: true,
              value: row.category,
              hint: const Text("Select"),
              items: ResearchRow.categories
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (val) {
                setState(() {
                  row.category = val;
                  row.calculatePoints();
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            3,
          ),

          _cell(
            TextField(
              controller: row.ifController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) {
                setState(() {
                  row.calculatePoints();
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            2,
          ),

          // ================= PDF UPLOAD =================
          _cell(
            OutlinedButton.icon(
              onPressed: () async {
                if (row.pdfAttached) {
                  openPdf(row);
                } else {
                  await pickPdfForRow(row);
                  setState(() {});
                }
              },
              icon: Icon(
                row.pdfAttached ? Icons.check_circle : Icons.upload_file,
                color:
                    row.pdfAttached ? Colors.green : Colors.indigo,
              ),
              label: Text(
                row.pdfAttached ? "Attached" : "Upload",
                overflow: TextOverflow.ellipsis,
              ),
            ),
            2,
          ),

          _cell(
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                row.points.toStringAsFixed(2),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            2,
          ),
        ],
      ),
    );
  }

  Widget _cell(Widget child, int flex) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: child,
      ),
    );
  }

  // ================= TOTAL =================
  Widget _totalCard() {
    return Card(
      elevation: 4,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade400, Colors.indigo.shade400],
          ),
        ),
        child: Text(
          "Self-Assessment Points : ${totalPoints.toStringAsFixed(2)}",
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
      ),
    );
  }

  // ================= PDF LOGIC =================
  Future<void> pickPdfForRow(ResearchRow row) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: kIsWeb,
    );

    if (result == null) return;

    if (kIsWeb) {
      row.pdfBytes = result.files.single.bytes;
      row.pdfName = result.files.single.name;
    } else {
      row.pdfPath = result.files.single.path;
    }

    row.pdfAttached = true;
  }

  void openPdf(ResearchRow row) {
    if (kIsWeb && row.pdfBytes != null) {
      final blob =
          html.Blob([row.pdfBytes], 'application/pdf');
      final url =
          html.Url.createObjectUrlFromBlob(blob);
      html.window.open(url, '_blank');
    } else if (!kIsWeb && row.pdfPath != null) {
      OpenFilex.open(row.pdfPath!);
    }
  }
}

// ================= HEADER CELL =================
class _HeaderCell extends StatelessWidget {
  final String text;
  final int flex;

  const _HeaderCell(this.text, {this.flex = 1});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

// ================= MODEL =================
class ResearchRow {
  static const List<String> categories = [
    "IEEE / ASME / ASCE / ACM / FT-50 / Scopus Top-10%",
    "SCIE and Scopus (Q1/Q2)",
    "SCIE / Scopus (Q1/Q2)",
    "Scopus (Q3/Q4) / ESCI",
  ];

  TextEditingController articleController =
      TextEditingController();
  TextEditingController ifController =
      TextEditingController();

  String? category;
  double points = 0;

  // PDF
  bool pdfAttached = false;
  String? pdfPath;
  Uint8List? pdfBytes;
  String? pdfName;

  void calculatePoints() {
    if (category == null) {
      points = 0;
      return;
    }

    double base = switch (category) {
      "IEEE / ASME / ASCE / ACM / FT-50 / Scopus Top-10%" => 25,
      "SCIE and Scopus (Q1/Q2)" => 20,
      "SCIE / Scopus (Q1/Q2)" => 15,
      _ => 10,
    };

    double impact =
        double.tryParse(ifController.text) ?? 0;
    points = base + max(0, impact);
  }
}