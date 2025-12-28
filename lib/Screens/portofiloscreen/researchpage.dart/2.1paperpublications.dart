import 'package:flutter/material.dart';

class PaperPublication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("2.1 Paper Publication",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            DataTable(columns: const [
              DataColumn(label: Text("S.No")),
              DataColumn(label: Text("Article Details")),
              DataColumn(label: Text("Category")),
              DataColumn(label: Text("Impact Factor")),
              DataColumn(label: Text("Points")),
            ], rows: [
              DataRow(cells: [
                DataCell(Text("1")),
                DataCell(Text("")),
                DataCell(Text("")),
                DataCell(Text("")),
                DataCell(Text("")),
              ]),
              DataRow(cells: [
                DataCell(Text("2")),
                DataCell(Text("")),
                DataCell(Text("")),
                DataCell(Text("")),
                DataCell(Text("")),
              ]),
            ])
          ],
        ),
      ),
    );
  }
}
