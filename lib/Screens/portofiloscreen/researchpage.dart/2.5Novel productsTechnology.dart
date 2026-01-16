import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:open_filex/open_filex.dart';
import 'dart:typed_data';
import 'dart:html' as html;

/// GLOBAL VARIABLE TO STORE TOTAL POINTS
double noveltotal = 0;

/// ================= ROW MODEL =================
class NovelRow {
  String details;
  String status; // Developed / Implemented
  int points;

  bool pdfAttached;
  String? pdfPath;
  Uint8List? pdfBytes;

  NovelRow({
    this.details = '',
    this.status = '',
    this.points = 0,
    this.pdfAttached = false,
    this.pdfPath,
    this.pdfBytes,
  });

  static const List<String> statuses = [
    "Developed",
    "Implemented",
  ];

  void calculatePoints() {
    if (status == "Developed") {
      points = 10;
    } else if (status == "Implemented") {
      points = 20;
    } else {
      points = 0;
    }
  }
}

/// ================= PAGE =================
class NovelProduct extends StatefulWidget {
  const NovelProduct({super.key});

  @override
  State<NovelProduct> createState() => _NovelProductPageState();
}

class _NovelProductPageState extends State<NovelProduct> {
  List<NovelRow> rows = [NovelRow()];

  int get totalPoints => rows.fold(0, (sum, item) => sum + item.points);

  void addRow() => setState(() => rows.add(NovelRow()));

  void removeRow() {
    if (rows.length > 1) setState(() => rows.removeLast());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("2.5 Novel products / Technology"),
        backgroundColor: Colors.indigo,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _headingCard(),
                const SizedBox(height: 12),
                _tableHeader(),
                const SizedBox(height: 6),
                ...rows.asMap().entries.map((e) => _tableRow(e.key, e.value)),
                const SizedBox(height: 80), // space for bottom buttons
              ],
            ),
          ),

          /// ===== BOTTOM ADD / REMOVE & SAVE BUTTONS =====
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: Row(
              children: [
                /// ===== ADD / REMOVE ROW BUTTONS LEFT =====
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: addRow,
                      icon: const Icon(Icons.add),
                      label: const Text("Add Row"),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: removeRow,
                      icon: const Icon(Icons.remove),
                      label: const Text("Remove Row"),
                    ),
                  ],
                ),

                const Spacer(),

                /// ===== SAVE BUTTON RIGHT =====
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    noveltotal = totalPoints.toDouble();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Saved Successfully: ${noveltotal.toStringAsFixed(0)} points",
                          textAlign: TextAlign.center,
                        ),
                        backgroundColor: Colors.green,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: const Text(
                    "SAVE",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
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
              "2.5 Novel products / Technology",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text("(Select Developed / Implemented for automatic points)"),
            Text("(For PI and Co-PIs)"),
          ],
        ),
      ),
    );
  }

  // ================= TABLE HEADER =================
  Widget _tableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: Colors.indigo.shade100,
      child: const Row(
        children: [
          _HeaderCell("S.No", flex: 1),
          _HeaderCell("Details of the Novel Product / Technology", flex: 4),
          _HeaderCell("Developed / Implemented", flex: 3),
          _HeaderCell("Upload PDF", flex: 2),
          _HeaderCell("Points claimed", flex: 2),
        ],
      ),
    );
  }

  // ================= TABLE ROW =================
  Widget _tableRow(int index, NovelRow row) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          _cell(Text("${index + 1}"), 1),
          _cell(
            TextField(
              decoration: const InputDecoration(
                hintText: "Enter details",
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (v) => row.details = v,
            ),
            4,
          ),

          /// ===== DROPDOWN FOR DEVELOPED / IMPLEMENTED =====
          _cell(
            DropdownButtonFormField<String>(
              value: row.status.isEmpty ? null : row.status,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
              ),
              items: NovelRow.statuses
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e, overflow: TextOverflow.ellipsis),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                setState(() {
                  row.status = v ?? '';
                  row.calculatePoints();
                  noveltotal = totalPoints.toDouble();
                });
              },
            ),
            3,
          ),

          // ===== PDF COLUMN =====
          _cell(
            OutlinedButton.icon(
              onPressed: () async {
                if (row.pdfAttached) {
                  openPdf(row);
                } else {
                  await pickPdf(row);
                  setState(() {});
                }
              },
              icon: Icon(
                row.pdfAttached ? Icons.check_circle : Icons.upload_file,
                color: row.pdfAttached ? Colors.green : Colors.indigo,
              ),
              label: Text(
                row.pdfAttached ? "Attached" : "Upload",
                overflow: TextOverflow.ellipsis,
              ),
            ),
            2,
          ),

          // ===== POINTS COLUMN =====
          _cell(
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                row.points.toString(),
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

  // ================= PDF LOGIC =================
  Future<void> pickPdf(NovelRow row) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: kIsWeb,
    );
    if (result == null) return;

    if (kIsWeb) {
      row.pdfBytes = result.files.single.bytes;
    } else {
      row.pdfPath = result.files.single.path;
    }
    row.pdfAttached = true;
  }

  void openPdf(NovelRow row) {
    if (kIsWeb && row.pdfBytes != null) {
      final blob = html.Blob([row.pdfBytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.window.open(url, '_blank');
    } else if (!kIsWeb && row.pdfPath != null) {
      OpenFilex.open(row.pdfPath!);
    }
  }
}

/// ================= HEADER CELL =================
class _HeaderCell extends StatelessWidget {
  final String text;
  final int flex;
  const _HeaderCell(this.text, {this.flex = 1});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
