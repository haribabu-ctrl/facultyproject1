import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:open_filex/open_filex.dart';
import 'dart:typed_data';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

/// GLOBAL VARIABLE TO STORE TOTAL POINTS
double projectTotalPoints = 0;

class ProjectConsultancy extends StatefulWidget {
  const ProjectConsultancy({super.key});

  @override
  State<ProjectConsultancy> createState() => _ProjectConsultancyPage26State();
}

class _ProjectConsultancyPage26State extends State<ProjectConsultancy> {
  List<ProjectRow> rows = [];

  @override
  void initState() {
    super.initState();
    rows.add(ProjectRow());
  }

  double get totalPoints => rows.fold(0, (sum, r) => sum + r.points);

  void calculatePoints(ProjectRow row) {
    if (row.status == null || row.status!.isEmpty) {
      row.points = 0;
      return;
    }

    if (row.status == "Shortlisted") {
      row.points = 5;
    } else if (row.status == "Sanctioned") {
      double amt = double.tryParse(row.amountController.text) ?? 0;
      row.points = amt * 5;
    }
  }

  void addRow() => setState(() => rows.add(ProjectRow()));

  void removeRow() {
    if (rows.length > 1) setState(() => rows.removeLast());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("2.6 Project / Consultancy Proposals"),
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
            ...rows.asMap().entries.map((e) => _tableRow(e.key, e.value)),
            const SizedBox(height: 10),
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
            const SizedBox(height: 20),
            _totalCard(),
            const SizedBox(height: 12),

            /// ===== SAVE BUTTON =====
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  projectTotalPoints = totalPoints; // GLOBAL VARIABLE
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Saved Successfully: ${projectTotalPoints.toStringAsFixed(2)} points",
                      ),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                child: const Text(
                  "SAVE",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
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
              "2.6 Project / Consultancy Proposals:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text("Shortlisted – 5 points, Sanctioned – 5 points/Lakh"),
            SizedBox(height: 6),
            Text(
              "(For PI and Co-PIs) (Other than AUS)",
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
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
          _HeaderCell("Details of Project / Consultancy", flex: 4),
          _HeaderCell("Funding Agency / Industry", flex: 3),
          _HeaderCell("Total Worth (Lakh)", flex: 2),
          _HeaderCell("Points Claimed", flex: 2),
        ],
      ),
    );
  }

  // ================= TABLE ROW =================
  Widget _tableRow(int index, ProjectRow row) {
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
              controller: row.detailsController,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: "Enter project details",
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (_) => setState(() {
                calculatePoints(row);
              }),
            ),
            4,
          ),
          // ===== FUNDING AGENCY DROPDOWN INSTEAD OF TEXTFIELD =====
          _cell(
            DropdownButton<String>(
              value: row.status,
              hint: const Text("Select Status"),
              items: const [
                DropdownMenuItem(
                  value: "Shortlisted",
                  child: Text("Shortlisted"),
                ),
                DropdownMenuItem(
                  value: "Sanctioned",
                  child: Text("Sanctioned"),
                ),
              ],
              onChanged: (val) {
                setState(() {
                  row.status = val;
                  calculatePoints(row);
                });
              },
            ),
            3,
          ),
          _cell(
            TextField(
              controller: row.amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (_) => setState(() {
                calculatePoints(row);
              }),
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

  // ================= TOTAL CARD =================
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
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  // ================= PDF LOGIC (OPTIONAL IF NEED) =================
  Future<void> pickPdf(ProjectRow row) async {
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

  void openPdf(ProjectRow row) {
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

// ================= ROW MODEL =================
class ProjectRow {
  TextEditingController detailsController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  String? status; // dropdown in funding agency column
  double points = 0;

  bool pdfAttached = false;
  String? pdfPath;
  Uint8List? pdfBytes;
}
