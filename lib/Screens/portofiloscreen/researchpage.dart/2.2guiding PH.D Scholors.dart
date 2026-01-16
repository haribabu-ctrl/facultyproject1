import 'dart:typed_data';
import 'dart:html' as html; // WEB
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_filex/open_filex.dart';

double guidingtotal = 0;

class GuidingPhDScholar extends StatefulWidget {
  const GuidingPhDScholar({super.key});

  @override
  State<GuidingPhDScholar> createState() => _GuidingPhDScholarsPageState();
}

class _GuidingPhDScholarsPageState extends State<GuidingPhDScholar> {
  List<PhDRow> rows = [PhDRow()];

  double get totalPoints =>
      rows.fold(0, (sum, r) => sum + r.points);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("2.2 Guiding Ph.D Scholars"),
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
              (e) => _tableRow(e.key, e.value),
            ),

            const SizedBox(height: 14),

            /// ADD / REMOVE + SAVE
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() => rows.add(PhDRow()));
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Add Row"),
                ),
                const SizedBox(width: 8),
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
                const Spacer(),

                /// SAVE BUTTON
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22, vertical: 14),
                  ),
                  onPressed: () {
                    setState(() {
                      guidingtotal = totalPoints;
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Points saved successfully"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  icon: const Icon(Icons.save),
                  label: const Text("SAVE"),
                ),
              ],
            ),

            const SizedBox(height: 16),
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
        child: Text(
          "2.2 Guiding Ph.D Scholars:\n"
          "Pursuing – 2 Points\n"
          "Awarded – 20 Points",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
          _HeaderCell("Name of the Research Scholar (FT/PT)", flex: 4),
          _HeaderCell("University", flex: 3),
          _HeaderCell("Month & Year of Admission / Award", flex: 3),
          _HeaderCell("Pursuing / Awarded", flex: 2),
          _HeaderCell("Upload PDF", flex: 2),
          _HeaderCell("Points claimed", flex: 2),
        ],
      ),
    );
  }

  // ================= TABLE ROW =================
  Widget _tableRow(int index, PhDRow row) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          _cell(Text("${index + 1}"), 1),
          _cell(_textField(row.nameController), 4),
          _cell(_textField(row.universityController), 3),
          _cell(_textField(row.monthYearController), 3),

          _cell(
            DropdownButtonFormField<String>(
              isExpanded: true,
              value: row.status,
              hint: const Text("Select"),
              items: const [
                DropdownMenuItem(value: "Pursuing", child: Text("Pursuing")),
                DropdownMenuItem(value: "Awarded", child: Text("Awarded")),
              ],
              onChanged: (val) {
                setState(() {
                  row.status = val;
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
                color: row.pdfAttached ? Colors.green : Colors.indigo,
              ),
              label: Text(row.pdfAttached ? "Attached" : "Upload"),
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
                row.points.toStringAsFixed(0),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            2,
          ),
        ],
      ),
    );
  }

  Widget _textField(TextEditingController c) {
    return TextField(
      controller: c,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        isDense: true,
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
          "Self-Assessment Points : ${totalPoints.toStringAsFixed(0)}",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // ================= PDF =================
  Future<void> pickPdfForRow(PhDRow row) async {
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

  void openPdf(PhDRow row) {
    if (kIsWeb && row.pdfBytes != null) {
      final blob = html.Blob([row.pdfBytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
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
class PhDRow {
  TextEditingController nameController = TextEditingController();
  TextEditingController universityController = TextEditingController();
  TextEditingController monthYearController = TextEditingController();

  String? status;
  double points = 0;

  bool pdfAttached = false;
  Uint8List? pdfBytes;
  String? pdfPath;

  void calculatePoints() {
    if (status == "Pursuing") {
      points = 2;
    } else if (status == "Awarded") {
      points = 20;
    } else {
      points = 0;
    }
  }
}
