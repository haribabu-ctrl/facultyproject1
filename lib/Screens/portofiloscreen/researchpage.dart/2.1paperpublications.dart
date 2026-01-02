import 'package:flutter/material.dart';
import 'dart:math';

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
              (entry) {
                int index = entry.key;
                ResearchRow row = entry.value;
                return _tableRow(index, row);
              },
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
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
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

  // ================= TABLE HEADER =================
  Widget _tableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: Colors.indigo.shade100,
      child: Row(
        children: const [
          _HeaderCell("S.No", flex: 1),
          _HeaderCell("Article details in IEEE format", flex: 4),
          _HeaderCell("Category of the Journal", flex: 3),
          _HeaderCell("JCR Impact Factor", flex: 2),
          _HeaderCell("Points claimed", flex: 2),
        ],
      ),
    );
  }

  // ================= TABLE ROW =================
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

          // ✅ FIXED DROPDOWN (NO OVERLOAD ERROR)
          _cell(
           DropdownButtonFormField<String>(
  isExpanded: true, // 🔑 IMPORTANT
  value: row.category,
  hint: const Text(
    "Select",
    overflow: TextOverflow.ellipsis,
  ),
  items: ResearchRow.categories
      .map(
        (e) => DropdownMenuItem<String>(
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
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// ================= ROW MODEL =================
class ResearchRow {
  static const List<String> categories = [
    "IEEE / ASME / ASCE / ACM / FT-50 / Scopus Top-10%",
    "SCIE and Scopus (Q1/Q2)",
    "SCIE / Scopus (Q1/Q2)",
    "Scopus (Q3/Q4) / ESCI",
  ];

  TextEditingController articleController = TextEditingController();
  TextEditingController ifController = TextEditingController();

  String? category; // ✅ FIX
  double points = 0;

  void calculatePoints() {
    if (category == null) {
      points = 0;
      return;
    }

    double base = 0;

    switch (category) {
      case "IEEE / ASME / ASCE / ACM / FT-50 / Scopus Top-10%":
        base = 25;
        break;
      case "SCIE and Scopus (Q1/Q2)":
        base = 20;
        break;
      case "SCIE / Scopus (Q1/Q2)":
        base = 15;
        break;
      case "Scopus (Q3/Q4) / ESCI":
        base = 10;
        break;
    }

    double impactFactor = double.tryParse(ifController.text) ?? 0;
    points = base + max(0, impactFactor);
  }
}