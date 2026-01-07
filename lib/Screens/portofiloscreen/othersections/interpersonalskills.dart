import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
int interpersonalskillstotal = 0;
/* ===================== MODEL ===================== */
class PhDRow {
  int score;
  int points;

  bool pdfAttached;
  String? pdfPath;      // mobile
  Uint8List? pdfBytes;  // web
  String? pdfName;

  PhDRow({
    this.score = 0,
    this.points = 0,
    this.pdfAttached = false,
    this.pdfPath,
    this.pdfBytes,
    this.pdfName,
  });
}

/* ===================== PAGE ===================== */
class InterpersonalSkills extends StatefulWidget {
  const InterpersonalSkills({super.key});

  @override
  State<InterpersonalSkills> createState() =>
      _InterpersonalSkillsPageState();
}

class _InterpersonalSkillsPageState extends State<InterpersonalSkills> {
  final List<String> parameters = [
    "Commitment – Dedication to student growth.",
    "Ownership – Accountability and leadership.",
    "Development – Continuous self-improvement.",
    "Initiative – Adopting new ideas independently.",
    "Responsibility – Ownership of duties.",
    "Punctuality – Respecting others’ time.",
    "Communication – Professional dialogue.",
    "Teamwork – Collaboration with colleagues.",
    "Leadership – Mentoring and guiding others.",
    "Student Mentoring – Supporting students.",
  ];

  late List<PhDRow> rows;

  @override
  void initState() {
    super.initState();
    rows = List.generate(parameters.length, (_) => PhDRow());
  }

  int get totalPoints =>
      rows.fold(0, (sum, row) => sum + row.points);
    

  /* ================= PDF PICK ================= */
  Future<void> pickPdfForRow(PhDRow row) async {
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
      row.pdfName = result.files.single.name;
    }

    row.pdfAttached = true;
  }

  /* ================= PDF OPEN ================= */
  void openPdf(PhDRow row) {
    if (kIsWeb && row.pdfBytes != null) {
      final blob = html.Blob([row.pdfBytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.window.open(url, '_blank');
    } else if (!kIsWeb && row.pdfPath != null) {
      OpenFilex.open(row.pdfPath!);
    }
  }

  /* ================= UI ================= */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Interpersonal Skills"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _header(),
            _table(),
            _totalBox(),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      color: Colors.grey.shade100,
      child: const Text(
        "II. Interpersonal Skills (5-point scale)",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _table() {
    return Table(
      border: TableBorder.all(color: Colors.black),
      columnWidths: const {
        0: FixedColumnWidth(40),
        1: FlexColumnWidth(),
        2: FixedColumnWidth(80),
        3: FixedColumnWidth(120),
        4: FixedColumnWidth(70),
      },
      children: [
        _tableHeader(),
        ...List.generate(rows.length, (index) => _tableRow(index)),
      ],
    );
  }

  TableRow _tableHeader() {
    return TableRow(
      decoration: BoxDecoration(color: Colors.grey.shade200),
      children: const [
        _Cell(text: "S.No", bold: true),
        _Cell(text: "PARAMETER", bold: true),
        _Cell(text: "Score", bold: true),
        _Cell(text: "Upload PDF", bold: true),
        _Cell(text: "Points", bold: true),
      ],
    );
  }

  TableRow _tableRow(int index) {
    final row = rows[index];

    return TableRow(
      children: [
        _Cell(text: "${index + 1}"),
        _Cell(text: parameters[index]),

        // SCORE
        Padding(
          padding: const EdgeInsets.all(6),
          child: DropdownButton<int>(
            isExpanded: true,
            value: row.score == 0 ? null : row.score,
            hint: const Text("1-5"),
            items: List.generate(
              5,
              (i) => DropdownMenuItem(
                value: i + 1,
                child: Text("${i + 1}"),
              ),
            ),
            onChanged: (val) {
              setState(() {
                row.score = val!;
                row.points = val; // same points logic
                interpersonalskillstotal = totalPoints;
              });
            },
          ),
        ),

        // PDF UPLOAD / OPEN
        Padding(
          padding: const EdgeInsets.all(6),
          child: OutlinedButton.icon(
            onPressed: () async {
              if (row.pdfAttached) {
                openPdf(row);
                return;
              }
              await pickPdfForRow(row);
              setState(() {});
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
        ),

        // POINTS
        Padding(
          padding: const EdgeInsets.all(6),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              row.points.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _totalBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: Text(
        "Total Points : $totalPoints / 50",
        textAlign: TextAlign.right,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

/* ================= CELL ================= */
class _Cell extends StatelessWidget {
  final String text;
  final bool bold;

  const _Cell({required this.text, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}