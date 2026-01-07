import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

int administrationtotal = 0;

class AdministrationPage extends StatefulWidget {
  const AdministrationPage({super.key});

  @override
  State<AdministrationPage> createState() => _AdministrationPageState();
}

class _AdministrationPageState extends State<AdministrationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final int maxTotal = 20;

  final List<Map<String, dynamic>> rows = [
    {"title": "Dean / Assoc. Dean / CoE", "central": 15, "dept": 10},
    {"title": "HoD / Assoc. HoD", "central": 10, "dept": 5},
    {"title": "Coordinator of Central activities", "central": 10, "dept": 5},
    {"title": "In-charge of Central facilities", "central": 5, "dept": 3},
    {"title": "Central Committee Member", "central": 3, "dept": 2},
    {"title": "Warden / Assoc. Warden", "central": 5, "dept": 3},
    {"title": "Placement Coordinator", "central": 5, "dept": 3},
    {"title": "Vertical Coordinator (AR/ER/TR)", "central": 5, "dept": 3},
    {"title": "Faculty Coordinator", "central": 3, "dept": 2},
    {"title": "Departmental Coordinator", "central": 0, "dept": 2},
    {"title": "Class Coordinator", "central": 0, "dept": 1},
    {"title": "Lab In-charge", "central": 0, "dept": 1},
    {"title": "Faculty Advisor", "central": 2, "dept": 1},
    {"title": "Any other activity", "central": 3, "dept": 2},
  ];

  late List<TextEditingController> controllers;
  late List<File?> uploadedPdfs; // 🔹 PDF store per row

  @override
  void initState() {
    super.initState();
    controllers =
        List.generate(rows.length, (_) => TextEditingController(text: "0"));
    uploadedPdfs = List.generate(rows.length, (_) => null);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
  }

  int get totalPoints {
    int total = 0;
    for (var c in controllers) {
      total += int.tryParse(c.text) ?? 0;
    }
    return total > maxTotal ? maxTotal : total;
  }

  /// 🔹 FILE PICKER FUNCTION (PDF ONLY)
  Future<void> pickPdf(int index) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        uploadedPdfs[index] = File(result.files.single.path!);
      });

      debugPrint("PDF selected for row ${index + 1}: "
          "${result.files.single.name}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6EA),
      body: _content(),
    );
  }

  Widget _content() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "SECTION 4: Administrative Responsibilities",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFF57C00),
            ),
          ),
          const SizedBox(height: 10),
          _selfAssessmentBox(),
          const SizedBox(height: 12),
          _tableHeader(),
          Expanded(
            child: ListView.builder(
              itemCount: rows.length,
              itemBuilder: (context, index) {
                return FadeTransition(
                  opacity: _controller,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - _controller.value)),
                    child: _rowItem(index),
                  ),
                );
              },
            ),
          ),
          _totalBox(),
        ],
      ),
    );
  }

  Widget _selfAssessmentBox() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1DE),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFF57C00)),
      ),
      child: const Text(
        "Self-Assessment Points: Maximum 20 points",
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _tableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: const Color(0xFFFFE6C7),
      child: Row(
        children: const [
          _HeaderCell("S.No", flex: 1),
          _HeaderCell("Administrative Activity", flex: 4),
          _HeaderCell("Central\nPoints", flex: 2),
          _HeaderCell("Dept\nPoints", flex: 2),
          _HeaderCell("PDF", flex: 2),
          _HeaderCell("Points\nClaimed", flex: 2),
        ],
      ),
    );
  }

  Widget _rowItem(int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          _cell("${index + 1}", flex: 1),
          _cell(rows[index]["title"], flex: 4),
          _badge(rows[index]["central"].toString(),
              const Color(0xFFE3F2FD)),
          _badge(rows[index]["dept"].toString(),
              const Color(0xFFE8F5E9)),
          _pdfButton(index),
          _inputBox(index),
        ],
      ),
    );
  }

  Widget _cell(String text, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Text(text),
      ),
    );
  }

  Widget _badge(String text, Color color) {
    return Expanded(
      flex: 2,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
          child: Text(text),
        ),
      ),
    );
  }

  /// 🔹 PDF UPLOAD BUTTON
  Widget _pdfButton(int index) {
    final bool uploaded = uploadedPdfs[index] != null;

    return Expanded(
      flex: 2,
      child: Center(
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: uploaded ? Colors.green : Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          ),
          onPressed: () => pickPdf(index),
          icon: const Icon(Icons.picture_as_pdf, size: 16),
          label: Text(
            uploaded ? "Uploaded" : "Upload",
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ),
    );
  }

  Widget _inputBox(int index) {
    return Expanded(
      flex: 2,
      child: TextField(
        controller: controllers[index],
        keyboardType: TextInputType.number,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    );
  }

  Widget _totalBox() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE6C7),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Total Points Claimed (Max 10):",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Container(
            width: 80,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              totalPoints.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFFF57C00),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () {
              setState(() {
                administrationtotal = totalPoints;
              });
              debugPrint("Administration Points Saved Successfully");
            },
            child: const Text("Save Section"),
          ),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;
  final int flex;

  const _HeaderCell(this.text, {required this.flex});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}