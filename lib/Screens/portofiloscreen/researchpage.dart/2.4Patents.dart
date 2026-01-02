import 'package:flutter/material.dart';

/* ======================= MODEL ======================= */
class PatentRow {
  String title;
  String country;
  String status;
  int points;

  PatentRow({
    this.title = '',
    this.country = '',
    this.status = '',
    this.points = 0,
  });

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
  State<PatentsPage> createState() => _PatentsPage2State();
}

class _PatentsPage2State extends State<PatentsPage> {
  List<PatentRow> rows = [PatentRow()];

  int get totalPoints => rows.fold(0, (sum, r) => sum + r.points);

  void addRow() {
    setState(() {
      rows.add(PatentRow());
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
            ...rows.asMap().entries.map((entry) {
              int index = entry.key;
              PatentRow row = entry.value;
              return _tableRow(index, row);
            }),
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
              "2.4 Patents Published / Granted",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text("(Published – 5 points, Granted – 20 points)"),
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
          _HeaderCell("Patent Title along with Number and Date", flex: 4),
          _HeaderCell("Patent filed Country", flex: 3),
          _HeaderCell("Published / Granted", flex: 2),
          _HeaderCell("Points", flex: 2),
        ],
      ),
    );
  }

  // ================= TABLE ROW =================
  Widget _tableRow(int index, PatentRow row) {
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
                DropdownMenuItem(value: "Published", child: Text("Published")),
                DropdownMenuItem(value: "Granted", child: Text("Granted")),
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
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                row.points.toString(),
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
          "Self-Assessment Points : $totalPoints",
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
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}