import 'package:flutter/material.dart';

class BooksChaptersProceeding extends StatefulWidget {
  const BooksChaptersProceeding({super.key});

  @override
  State<BooksChaptersProceeding> createState() =>
      _BooksChaptersProceedingsPageState();
}

class _BooksChaptersProceedingsPageState
    extends State<BooksChaptersProceeding> {
  List<BookRow> rows = [BookRow()];

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
        title: const Text("2.3 Books / Chapters / Conference Proceedings"),
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
            ...rows.asMap().entries.map((e) {
              return _tableRow(e.key, e.value);
            }),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      rows.add(BookRow());
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
      child: const Padding(
        padding: EdgeInsets.all(12),
        child: Text(
          "2.3 Books / Chapters / Scopus Conference Proceedings\n"
          "ISBN Book – 10 Points\n"
          "ISBN Book Chapter – 5 Points\n"
          "Scopus Conference Proceedings – 5 Points",
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
          _HeaderCell(
              "Details of Books / Chapter / Conference Proceedings\n"
              "published along with ISBN / ISSN number",
              flex: 5),
          _HeaderCell(
              "Category\n(Book / Chapter / Proceedings)",
              flex: 3),
          _HeaderCell("Publisher", flex: 3),
          _HeaderCell("Upload PDF", flex: 2),
          _HeaderCell("Points claimed", flex: 2),
        ],
      ),
    );
  }

  // ================= TABLE ROW =================
  Widget _tableRow(int index, BookRow row) {
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
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            5,
          ),

          _cell(
            DropdownButtonFormField<String>(
              isExpanded: true,
              value: row.category,
              hint: const Text("Select"),
              items: const [
                DropdownMenuItem(
                    value: "ISBN Book", child: Text("ISBN Book")),
                DropdownMenuItem(
                    value: "ISBN Book Chapter",
                    child: Text("ISBN Book Chapter")),
                DropdownMenuItem(
                    value: "Scopus Conference Proceedings",
                    child: Text("Scopus Conference Proceedings")),
              ],
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
              controller: row.publisherController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            3,
          ),

          // ✅ REAL PDF PICKER
          // _cell(
          //   OutlinedButton.icon(
          //     onPressed: () async {
          //       FilePickerResult? result =
          //           await FilePicker.platform.pickFiles(
          //         type: FileType.custom,
          //         allowedExtensions: ['pdf'],
          //       );

          //       if (result != null) {
          //         setState(() {
          //           row.pdfName = result.files.single.name;
          //         });
          //       }
          //     },
          //     icon: Icon(
          //       row.pdfName != null
          //           ? Icons.check_circle
          //           : Icons.upload_file,
          //       color:
          //           row.pdfName != null ? Colors.green : Colors.indigo,
          //     ),
          //     label: Text(
          //       row.pdfName != null ? "Attached" : "Upload",
          //       overflow: TextOverflow.ellipsis,
          //     ),
          //   ),
          //   2,
          // ),

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
          "Self-Assessment Points (Max: 10) : ${totalPoints.toStringAsFixed(0)}",
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

// ================= ROW MODEL =================
class BookRow {
  TextEditingController detailsController = TextEditingController();
  TextEditingController publisherController = TextEditingController();

  String? category;
  double points = 0;
  String? pdfName;

  void calculatePoints() {
    if (category == "ISBN Book") {
      points = 10;
    } else if (category == "ISBN Book Chapter" ||
        category == "Scopus Conference Proceedings") {
      points = 5;
    } else {
      points = 0;
    }
  }
}