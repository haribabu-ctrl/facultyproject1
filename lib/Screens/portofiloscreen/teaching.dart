import 'package:flutter/material.dart';

class TeachingPage extends StatelessWidget {
  const TeachingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: const ValueKey("Teaching"),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 24),

          _sectionCard(
            title: "1.1 Course Average Pass Percentage (Theory Only)",
            note:
                "≥95% – 20 pts, ≥85 & <95 – 15 pts, ≥75 & <85 – 10 pts, ≥70 & <75 – 5 pts",
            columns: const [
              "S.No",
              "Course Name",
              "Sem-Branch-Sec",
              "Students Appeared (A)",
              "Students Passed (B)",
              "Pass % (B/A*100)",
              "Points Claimed",
              "Average Points",
            ],
          ),

          _sectionCard(
            title: "1.2 Course Feedback (Theory Only)",
            note:
                "≥95% – 20 pts, ≥85 & <95 – 15 pts, ≥75 & <85 – 10 pts, ≥70 & <75 – 5 pts",
            columns: const [
              "S.No",
              "Course Name",
              "Sem-Branch-Sec",
              "No. of Students",
              "Feedback %",
              "Points Claimed",
              "Average Points",
            ],
          ),

          _sectionCard(
            title: "1.3 Proctoring Students Average Pass Percentage",
            note:
                "≥80% – 20 pts, ≥70 & <80 – 15 pts, ≥60 & <70 – 10 pts, ≥50 & <60 – 5 pts",
            columns: const [
              "S.No",
              "Students Allotted",
              "Sem-Branch-Sec",
              "Eligible for Exams (A)",
              "Students Passed (B)",
              "Pass % (B/A*100)",
              "Points Claimed",
              "Average Points",
            ],
          ),

          _sectionCard(
            title: "1.4 CO Attainment (Theory Only)",
            note:
                "100% – 20 pts, 80% – 15 pts, 60% – 10 pts, 40% – 5 pts",
            columns: const [
              "S.No",
              "Course Name",
              "Sem-Branch-Sec",
              "No. of COs (A)",
              "COs Attained (B)",
              "Percentage (B/A*100)",
              "Points Claimed",
              "Average Points",
            ],
          ),
        ],
      ),
    );
  }

  /// ---------- SECTION CARD ----------
  Widget _sectionCard({
    required String title,
    required String note,
    required List<String> columns,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 28),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(note,
              style: const TextStyle(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 16),

          /// TABLE
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(
                const Color(0xFFFFE0B2),
              ),
              columns: columns
                  .map(
                    (c) => DataColumn(
                      label: Text(
                        c,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  )
                  .toList(),
              rows: List.generate(
                4,
                (index) => DataRow(
                  cells: List.generate(
                    columns.length,
                    (cellIndex) => DataCell(
                      cellIndex == 0
                          ? Text("${index + 1}")
                          : SizedBox(
                              width: 120,
                              child: TextField(
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 6),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
