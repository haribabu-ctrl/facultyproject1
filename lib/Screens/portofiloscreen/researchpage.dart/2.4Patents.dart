import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:open_filex/open_filex.dart';
import 'dart:typed_data';

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

/* ======================= MODEL ======================= */
class PatentRow {
  String title = '';
  String country = '';
  String status = '';
  int points = 0;

  bool pdfAttached = false;
  String? pdfPath;
  Uint8List? pdfBytes;
  String? pdfName;

  void calculatePoints() {
    if (status == "Granted") {
      points = 20;
    } else if (status == "Published") {
      points = 5;
    } else {
      points = 0;
    }
  }
}

/* ======================= PAGE ======================= */
class PatentsPage extends StatefulWidget {
  const PatentsPage({super.key});

  @override
  State<PatentsPage> createState() => _PatentsPageState();
}

class _PatentsPageState extends State<PatentsPage> {
  List<PatentRow> rows = [PatentRow()];

  int get totalPoints =>
      rows.fold(0, (sum, r) => sum + r.points);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("2.4 Patents Published / Granted"),
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
            ...rows.asMap().entries
                .map((e) => _tableRow(e.key, e.value)),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() => rows.add(PatentRow()));
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
                      setState(() => rows.removeLast());
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

  Widget _headingCard() {
    return Card(
      color: Colors.grey.shade200,
      child: const Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "2.4 Patents Published / Granted",
              style:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text("(Published – 5 points, Granted – 20 points)"),
          ],
        ),
      ),
    );
  }

  Widget _tableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: Colors.indigo.shade100,
      child: const Row(
        children: [
          _HeaderCell("S.No", flex: 1),
          _HeaderCell(
              "Patent Title along with Number and Date",
              flex: 4),
          _HeaderCell("Patent filed Country", flex: 3),
          _HeaderCell("Published / Granted", flex: 2),
          _HeaderCell("Upload PDF", flex: 2),
          _HeaderCell("Points", flex: 2),
        ],
      ),
    );
  }

  Widget _tableRow(int index, PatentRow row) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        border:
            Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          _cell(Text("${index + 1}"), 1),

          _cell(
            TextField(
              decoration: const InputDecoration(
                hintText: "Enter Patent Title",
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (v) => row.title = v,
            ),
            4,
          ),

          _cell(
            TextField(
              decoration: const InputDecoration(
                hintText: "Enter Country",
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (v) => row.country = v,
            ),
            3,
          ),

          _cell(
            DropdownButtonFormField<String>(
              value: row.status.isEmpty ? null : row.status,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
              ),
              items: const [
                DropdownMenuItem(
                    value: "Published",
                    child: Text("Published")),
                DropdownMenuItem(
                    value: "Granted",
                    child: Text("Granted")),
              ],
              onChanged: (v) {
                setState(() {
                  row.status = v ?? '';
                  row.calculatePoints();
                });
              },
            ),
            2,
          ),

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
                row.pdfAttached
                    ? Icons.check_circle
                    : Icons.upload_file,
                color: row.pdfAttached
                    ? Colors.green
                    : Colors.indigo,
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
                row.points.toString(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold),
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

  Widget _totalCard() {
    return Card(
      elevation: 4,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green.shade400,
              Colors.indigo.shade400
            ],
          ),
        ),
        child: Text(
          "Self-Assessment Points : $totalPoints",
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
      ),
    );
  }

  Future<void> pickPdf(PatentRow row) async {
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

  void openPdf(PatentRow row) {
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

/* ================= HEADER CELL ================= */
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