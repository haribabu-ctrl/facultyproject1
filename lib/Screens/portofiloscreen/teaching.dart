import 'package:flutter/material.dart';

int totalTeachingAvg = 0;

class TeachingPage extends StatefulWidget {
  const TeachingPage({super.key});

  @override
  State<TeachingPage> createState() => _TeachingPageState();
}

class _TeachingPageState extends State<TeachingPage> {
  // ================= COMMON =================
  double calculatePoints(double percent) {
    if (percent >= 95) return 20;
    if (percent >= 85) return 15;
    if (percent >= 75) return 10;
    if (percent >= 70) return 5;
    return 0;
  }

  double calculateFeedbackPoints(double percent) {
    if (percent >= 80) return 20;
    if (percent >= 70) return 15;
    if (percent >= 60) return 10;
    if (percent >= 50) return 5;
    return 0;
  }

  Color pointColor(double p) {
    if (p >= 20) return Colors.green;
    if (p >= 10) return Colors.orange;
    if (p > 0) return Colors.red;
    return Colors.grey;
  }

  Widget textInput() => SizedBox(
        width: 120,
        child: TextField(
          decoration: InputDecoration(
            isDense: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
          ),
        ),
      );

  Widget numberInput(TextEditingController c) => SizedBox(
        width: 120,
        child: TextField(
          controller: c,
          keyboardType: TextInputType.number,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            isDense: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
          ),
        ),
      );

  double avg(List<double> p) {
    final valid = p.where((e) => e > 0).toList();
    if (valid.isEmpty) return 0;
    return valid.reduce((a, b) => a + b) / valid.length;
  }

  // ================= SECTION 1.1 =================
  final s1A = List.generate(4, (_) => TextEditingController());
  final s1B = List.generate(4, (_) => TextEditingController());
  final s1Points = List.filled(4, 0.0);
  double s1Avg = 0;

  // ================= SECTION 1.2 =================
  final s2Feedback = List.generate(4, (_) => TextEditingController());
  final s2Points = List.filled(4, 0.0);
  double s2Avg = 0;

  // ================= SECTION 1.3 =================
  final s3A = List.generate(4, (_) => TextEditingController());
  final s3B = List.generate(4, (_) => TextEditingController());
  final s3Points = List.filled(4, 0.0);
  double s3Avg = 0;

  // ================= SECTION 1.4 =================
  final s4A = List.generate(4, (_) => TextEditingController());
  final s4B = List.generate(4, (_) => TextEditingController());
  final s4Points = List.filled(4, 0.0);
  double s4Avg = 0;

  @override
  void dispose() {
    for (var c in s1A + s1B + s2Feedback + s3A + s3B + s4A + s4B) {
      c.dispose();
    }
    super.dispose();
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF7A18), Color(0xFFFFB347)],
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Text(
            "SECTION 1 : Teaching (80 Points)",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
        const SizedBox(height: 24),

        buildABSection(
          title: "1.1 Course Average Pass Percentage (Theory Only)",
          note:
              "≥95% – 20 pts, ≥85 & <95 – 15 pts, ≥75 & <85 – 10 pts, ≥70 & <75 – 5 pts",
          aCtrls: s1A,
          bCtrls: s1B,
          points: s1Points,
          savedAvg: s1Avg,
          onSave: () => setState(() => s1Avg = avg(s1Points)),
        ),

        buildFeedbackSection(
          title: "1.2 Course Feedback (Theory Only)",
          note:
              "≥80% – 20 pts, ≥70 & <80 – 15 pts, ≥60 & <70 – 10 pts, ≥50 & <60 – 5 pts",
          ctrls: s2Feedback,
          points: s2Points,
          savedAvg: s2Avg,
          onSave: () => setState(() => s2Avg = avg(s2Points)),
        ),

        buildABSection(
          title: "1.3 Proctoring Students Average Pass Percentage",
          note:
              "≥80% – 20 pts, ≥70 & <80 – 15 pts, ≥60 & <70 – 10 pts, ≥50 & <60 – 5 pts",
          aCtrls: s3A,
          bCtrls: s3B,
          points: s3Points,
          savedAvg: s3Avg,
          onSave: () => setState(() => s3Avg = avg(s3Points)),
        ),

        buildABSection(
          title: "1.4 CO Attainment (Theory Only)",
          note: "100% – 20 pts, 80% – 15 pts, 60% – 10 pts, 40% – 5 pts",
          aCtrls: s4A,
          bCtrls: s4B,
          points: s4Points,
          savedAvg: s4Avg,
          onSave: () => setState(() => s4Avg = avg(s4Points)),
        ),

        const SizedBox(height: 24),
        buildSummaryTable(),
      ]),
    );
  }

  // ================= BUILDERS =================

  Widget buildABSection({
    required String title,
    required String note,
    required List<TextEditingController> aCtrls,
    required List<TextEditingController> bCtrls,
    required List<double> points,
    required double savedAvg,
    required VoidCallback onSave,
  }) {
    const rowsCount = 4;

    return buildContainer(
      title,
      note,
      List.generate(rowsCount, (i) {
        final a = double.tryParse(aCtrls[i].text) ?? 0;
        final b = double.tryParse(bCtrls[i].text) ?? 0;
        final percent = a == 0 ? 0.0 : (b / a) * 100.0;
        points[i] = calculatePoints(percent);

        return [
          Text("${i + 1}"),
          textInput(),
          textInput(),
          numberInput(aCtrls[i]),
          numberInput(bCtrls[i]),
          Text(percent == 0 ? "-" : percent.toStringAsFixed(1)),
          Text(points[i] == 0 ? "-" : points[i].toString(),
              style: TextStyle(color: pointColor(points[i]))),
          Text(i == rowsCount - 1 && savedAvg != 0
              ? savedAvg.toStringAsFixed(1)
              : "-"),
        ];
      }),
      onSave,
    );
  }

Widget buildFeedbackSection({
  required String title,
  required String note,
  required List<TextEditingController> ctrls, // % controllers
  required List<double> points,
  required double savedAvg,
  required VoidCallback onSave,
}) {
  const rowsCount = 4;

  // A column controllers (user input for “No. of Students Appeared”)
  final aCtrls = List.generate(rowsCount, (_) => TextEditingController());

  return buildContainer(
    title,
    note,
    List.generate(rowsCount, (i) {
      final percent = double.tryParse(ctrls[i].text) ?? 0;
      points[i] = calculateFeedbackPoints(percent);

      return [
        Text("${i + 1}"),          // S.No
        textInput(),               // Course Name
        textInput(),               // Sem-Branch-Sec

        // ✅ A Column → TextField visible
        SizedBox(
          width: 100,
          child: TextField(
            controller: aCtrls[i],
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              isDense: true,
              border: OutlineInputBorder(),
            ),
          ),
        ),

        // ❌ B column → empty
        const SizedBox.shrink(),

        // ✅ Percentage column → user editable
        SizedBox(
          width: 100,
          child: TextField(
            controller: ctrls[i],
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              isDense: true,
              border: OutlineInputBorder(),
            ),
          ),
        ),

        // ✅ Points auto
        Text(
          points[i] == 0 ? "-" : points[i].toString(),
          style: TextStyle(color: pointColor(points[i])),
        ),

        // Average
        Text(
          i == rowsCount - 1 && savedAvg != 0
              ? savedAvg.toStringAsFixed(1)
              : "-",
        ),
      ];
    }),
    onSave,
  );
}

  Widget buildContainer(
      String title, String note, List<List<Widget>> rows, VoidCallback onSave) {
    return Container(
      margin: const EdgeInsets.only(bottom: 28),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title,
            style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(note, style: const TextStyle(fontSize: 12, color: Colors.black54)),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor:
                MaterialStateProperty.all(const Color(0xFFFFE0B2)),
            columns: const [
              DataColumn(label: Text("S.No")),
              DataColumn(label: Text("Course Name")),
              DataColumn(label: Text("Sem-Branch-Sec")),
              DataColumn(label: Text("No.of Students Appeared(A)")),
              DataColumn(label: Text("No.of Students Passed (B)")),
              DataColumn(label: Text("Pass Percentage (B/A*100)")),
              DataColumn(label: Text("Points Claimed")),
              DataColumn(label: Text("Average Points")),
            ],
            rows: rows
                .map((r) => DataRow(cells: r.map(DataCell.new).toList()))
                .toList(),
          ),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: onSave,
            child: const Text("Save Section"),
          ),
        ),
      ]),
    );
  }

  Widget buildSummaryTable() {
    final sections = [
      "1.1 Pass %",
      "1.2 Feedback",
      "1.3 Proctoring",
      "1.4 CO Attainment"
    ];

    final averages = [s1Avg, s2Avg, s3Avg, s4Avg];

    totalTeachingAvg = averages.reduce((a, b) => a + b).toInt();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F7FA),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text(
          "Teaching Summary",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        DataTable(
          headingRowColor:
              MaterialStateProperty.all(const Color(0xFFB2EBF2)),
          columns: const [
            DataColumn(label: Text("Section")),
            DataColumn(label: Text("Average Points")),
          ],
          rows: [
            ...List.generate(
              sections.length,
              (i) => DataRow(cells: [
                DataCell(Text(sections[i])),
                DataCell(Text(
                    averages[i] == 0 ? "-" : averages[i].toStringAsFixed(1))),
              ]),
            ),
            DataRow(
              color: MaterialStateProperty.all(Colors.green.shade100),
              cells: [
                const DataCell(
                  Text("TOTAL TEACHING Average Points",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                DataCell(
                  Text(
                    totalTeachingAvg == 0
                        ? "-"
                        : totalTeachingAvg.toStringAsFixed(1),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ),
              ],
            ),
          ],
        ),
      ]),
    );
  }
}