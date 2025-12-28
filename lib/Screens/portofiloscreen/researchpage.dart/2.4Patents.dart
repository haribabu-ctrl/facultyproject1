import 'package:flutter/material.dart';

class PatentsPage extends StatefulWidget {
  @override
  State<PatentsPage> createState() => _PatentsPageState();
}

class _PatentsPageState extends State<PatentsPage> {
  String statusValue = "Published";

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
                Icon(Icons.description, color: Colors.deepOrange),
                SizedBox(width: 8),
                Text(
                  "2.4 Patents (Published / Granted)",
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
                  DataColumn(label: Text("Patent Title")),
                  DataColumn(label: Text("Application Number")),
                  DataColumn(label: Text("Status")),
                  DataColumn(label: Text("Date")),
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
                                value: "Published",
                                child: Text("Published"),
                              ),
                              DropdownMenuItem(
                                value: "Granted",
                                child: Text("Granted"),
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
                        IconButton(
                          icon: const Icon(
                            Icons.calendar_month,
                            color: Colors.deepOrange,
                          ),
                          onPressed: () async {
                            await showDatePicker(
                              context: context,
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                              initialDate: DateTime.now(),
                            );
                          },
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
