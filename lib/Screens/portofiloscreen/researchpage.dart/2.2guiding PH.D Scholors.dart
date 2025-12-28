import 'package:flutter/material.dart';

class PhdGuiding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("2.2 Guiding Ph.D Scholars",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            DataTable(columns: const [
              DataColumn(label: Text("S.No")),
              DataColumn(label: Text("Scholar Name")),
              DataColumn(label: Text("University")),
              DataColumn(label: Text("Month & Year")),
              DataColumn(label: Text("Status")),
              DataColumn(label: Text("Points")),
            ], rows: [
              DataRow(cells: [
                DataCell(Text("1")),
                DataCell(Text("")),
                DataCell(Text("")),
                DataCell(Text("")),
                DataCell(
                  DropdownButton(
                    items: [
                      DropdownMenuItem(value: "Pursuing", child: Text("Pursuing")),
                      DropdownMenuItem(value: "Awarded", child: Text("Awarded")),
                    ],
                    onChanged: (_) {},
                  ),
                ),
                DataCell(Text("")),
              ]),
            ])
          ],
        ),
      ),
    );
  }
}
