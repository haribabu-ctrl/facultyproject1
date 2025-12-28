import 'package:flutter/material.dart';

class BooksChapters extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Row(
              children: const [
                Icon(Icons.menu_book, color: Colors.deepOrange),
                SizedBox(width: 8),
                Text(
                  "2.3 Books / Chapters / Scopus Conference Proceedings",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            const Text(
              "Note: (Maximum 10 points)",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 16),

            // Table
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(
                  Colors.orange.shade100,
                ),
                border: TableBorder.all(
                  color: Colors.orange.shade200,
                ),
                columns: const [
                  DataColumn(
                    label: Text(
                      "Metric",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Research Item",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Points claimed",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                rows: [
                  buildRow("Book"),
                  buildRow("Chapter"),
                  buildRow("Scopus Conference"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static DataRow buildRow(String metric) {
    return DataRow(
      cells: [
        DataCell(Text(metric)),
        DataCell(
          TextField(
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "",
            ),
          ),
        ),
        DataCell(
          TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "",
            ),
          ),
        ),
      ],
    );
  }
}
