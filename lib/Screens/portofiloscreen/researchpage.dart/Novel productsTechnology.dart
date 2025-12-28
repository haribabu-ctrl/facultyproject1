import 'package:flutter/material.dart';

class NovelProductsPage extends StatefulWidget {
  @override
  State<NovelProductsPage> createState() => _NovelProductsPageState();
}

class _NovelProductsPageState extends State<NovelProductsPage> {
  String statusValue = "Developed";

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
                Icon(Icons.lightbulb, color: Colors.deepOrange),
                SizedBox(width: 8),
                Text(
                  "2.5 Novel Products / Technology (Developed / Implemented)",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

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
                  DataColumn(label: Text("S.\nNo")),
                  DataColumn(label: Text("Product / Technology Name")),
                  DataColumn(label: Text("Description")),
                  DataColumn(label: Text("Status")),
                  DataColumn(label: Text("Points claimed")),
                ],
                rows: [
                  DataRow(
                    cells: [
                      const DataCell(Text("1")),

                      DataCell(
                        TextField(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),

                      DataCell(
                        TextField(
                          maxLines: 2,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),

                      DataCell(
                        DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: statusValue,
                            items: const [
                              DropdownMenuItem(
                                value: "Developed",
                                child: Text("Developed"),
                              ),
                              DropdownMenuItem(
                                value: "Implemented",
                                child: Text("Implemented"),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                statusValue = value!;
                              });
                            },
                          ),
                        ),
                      ),

                      DataCell(
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
