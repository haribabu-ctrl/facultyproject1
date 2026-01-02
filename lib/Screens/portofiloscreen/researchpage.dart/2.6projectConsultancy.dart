import 'package:flutter/material.dart';
import 'dart:math';

class ProjectConsultancy extends StatefulWidget {
  const ProjectConsultancy({super.key});

  @override
  State<ProjectConsultancy> createState() =>
      _ProjectConsultancyPage26State();
}

class _ProjectConsultancyPage26State
    extends State<ProjectConsultancy> {
  List<ProjectRow> rows = [];

  @override
  void initState() {
    super.initState();
    rows.add(ProjectRow());
  }

  double get totalPoints {
    double sum = 0;
    for (var r in rows) {
      sum += r.points;
    }
    return sum;
  }

  void calculatePoints(ProjectRow row) {
    if (row.status == null || row.status!.isEmpty) {
      row.points = 0;
      return;
    }

    if (row.status == "Shortlisted") {
      row.points = 5;
    } else if (row.status == "Sanctioned") {
      double amt = double.tryParse(row.amountController.text) ?? 0;
      row.points = (amt * 5).toDouble();
    }
  }

  void addRow() {
    setState(() {
      rows.add(ProjectRow());
    });
  }

  void removeRow() {
    if (rows.length > 1) {
      setState(() {
        rows.removeLast();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            ...rows.asMap().entries.map(
              (entry) {
                int index = entry.key;
                ProjectRow row = entry.value;
                return _tableRow(index, row);
              },
            ),
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
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red),
                  onPressed: removeRow,
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
              "2.6 Project / Consultancy Proposals:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text(
                "Shortlisted – 5 points, Sanctioned – 5 points/Lakh"),
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
      child: Row(
        children: const [
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
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
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
              onChanged: (_) {
                setState(() {
                  calculatePoints(row);
                });
              },
            ),
            4,
          ),
          _cell(
            TextField(
              controller: row.agencyController,
              maxLines: 1,
              decoration: const InputDecoration(
                hintText: "Enter agency",
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (_) {
                setState(() {
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
              onChanged: (_) {
                setState(() {
                  calculatePoints(row);
                });
              },
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
class ProjectRow {
  TextEditingController detailsController = TextEditingController();
  TextEditingController agencyController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  String? status;
  double points = 0;
}