import 'package:flutter/material.dart';

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

  double avg(List<double> p) => p.reduce((a, b) => a + b) / p.length;

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
        /// HEADER
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

        /// 1.1 Pass Percentage
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

        /// 1.2 Feedback
        buildFeedbackSection(
          title: "1.2 Course Feedback (Theory Only)",
          note:
              "≥95% – 20 pts, ≥85 & <95 – 15 pts, ≥75 & <85 – 10 pts, ≥70 & <75 – 5 pts",
          ctrls: s2Feedback,
          points: s2Points,
          savedAvg: s2Avg,
          onSave: () => setState(() => s2Avg = avg(s2Points)),
        ),

        /// 1.3 Proctoring
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

        /// 1.4 CO Attainment
        buildABSection(
          title: "1.4 CO Attainment (Theory Only)",
          note: "100% – 20 pts, 80% – 15 pts, 60% – 10 pts, 40% – 5 pts",
          aCtrls: s4A,
          bCtrls: s4B,
          points: s4Points,
          savedAvg: s4Avg,
          onSave: () => setState(() => s4Avg = avg(s4Points)),
        ),

        /// ================= SUMMARY TABLE =================
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
    return buildContainer(
      title,
      note,
      List.generate(4, (i) {
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
          Text(savedAvg == 0 ? "-" : savedAvg.toStringAsFixed(1)),
        ];
      }),
      onSave,
    );
  }

  Widget buildFeedbackSection({
    required String title,
    required String note,
    required List<TextEditingController> ctrls,
    required List<double> points,
    required double savedAvg,
    required VoidCallback onSave,
  }) {
    return buildContainer(
      title,
      note,
      List.generate(4, (i) {
        final p = double.tryParse(ctrls[i].text) ?? 0;
        points[i] = calculatePoints(p);

        return [
          Text("${i + 1}"),
          textInput(),
          textInput(),
          numberInput(ctrls[i]),
          const Text("-"),
          Text(p == 0 ? "-" : p.toStringAsFixed(1)),
          Text(points[i] == 0 ? "-" : points[i].toString(),
              style: TextStyle(color: pointColor(points[i]))),
          Text(savedAvg == 0 ? "-" : savedAvg.toStringAsFixed(1)),
        ];
      }),
      onSave,
    );
  }

  Widget buildContainer(
    String title,
    String note,
    List<List<Widget>> rows,
    VoidCallback onSave,
  ) {
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
              DataColumn(label: Text("Course / Students")),
              DataColumn(label: Text("Sem-Branch-Sec")),
              DataColumn(label: Text("A / Feedback")),
              DataColumn(label: Text("B")),
              DataColumn(label: Text("Percentage")),
              DataColumn(label: Text("Points Claimed")),
              DataColumn(label: Text("Average Points")),
            ],
            rows: rows.map((r) => DataRow(cells: r.map(DataCell.new).toList())).toList(),
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
    final sections = ["1.1 Pass %", "1.2 Feedback", "1.3 Proctoring", "1.4 CO Attainment"];
    final averages = [s1Avg, s2Avg, s3Avg, s4Avg];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F7FA),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text("Teaching Summary",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: MaterialStateProperty.all(const Color(0xFFB2EBF2)),
            columns: const [
              DataColumn(label: Text("Section")),
              DataColumn(label: Text("Average Points")),
            ],
            rows: List.generate(
                sections.length,
                (i) => DataRow(cells: [
                      DataCell(Text(sections[i])),
                      DataCell(Text(averages[i] == 0 ? "-" : averages[i].toStringAsFixed(1))),
                    ])),
          ),
        ),
      ]),
    );
  }
}