import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'dart:html' as html;

int expertiseTotalPoints = 0;

class ExpertiseValueAddition extends StatefulWidget {
  const ExpertiseValueAddition({super.key});

  @override
  State<ExpertiseValueAddition> createState() =>
      _ExpertiseValueAdditionPageState();
}

class _ExpertiseValueAdditionPageState
    extends State<ExpertiseValueAddition> {

  // ======================= 3.1 =======================
  List<Map<String, dynamic>> table31 = [
    {
      'event': 'Conference',
      'role': 'Organized',
      'duration': '',
      'points': 10,
      'pdfAttached': false,
      'pdfBytes': null,
      'pdfPath': null,
    }
  ];

  final List<String> events31 = [
    'Conference',
    'STTP / Refresher Course',
    'FDP / Symposium',
    'Guest Lecture / Workshop / Event',
  ];

  // ======================= 3.2 =======================
  List<Map<String, dynamic>> table32 = [
    {
      'type': 'Member of BOG/GB/AC/BOS',
      'points': 5,
      'pdfAttached': false,
      'pdfBytes': null,
      'pdfPath': null,
    }
  ];

  final Map<String, int> expertisePoints = {
    'Member of BOG/GB/AC/BOS': 5,
    'Editorial Board (SCIE/Q1/Q2)': 5,
    'Editorial Board (ESCI/Q3/Q4)': 3,
    'Awards (Govt/Top 2%)': 5,
    'Awards (NGO/Others)': 3,
    'Developed e-content': 10,
    'Certification (40 hrs)': 5,
    'Trained Students (Finals)': 5,
    'Articles (Magazine/Newspaper)': 3,
    'Research Facility': 3,
    'NPTEL 12 Weeks': 6,
    'NPTEL 8 Weeks': 4,
    'NPTEL 4 Weeks': 2,
    'Coursera (40 hrs)': 5,
    'FDP/Seminar Grant': 5,
  };

  int calc31(String role, String d) {
    final v = int.tryParse(d) ?? 0;
    if (role == 'Organized') return 10;
    if (role == 'Resource Person') return v * 2;
    if (role == 'Participated') return v;
    return 0;
  }

  int get total31 =>
      table31.fold(0, (s, r) => s + r['points'] as int).clamp(0, 10);

  int get total32 =>
      table32.fold(0, (s, r) => s + r['points'] as int).clamp(0, 10);

  int get total31and32 => total31 + total32;

  // ======================= PDF =======================

  Future<void> pickPdf(Map<String, dynamic> row) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: kIsWeb,
    );

    if (result == null) return;

    if (kIsWeb) {
      row['pdfBytes'] = result.files.single.bytes;
    } else {
      row['pdfPath'] = result.files.single.path;
    }

    row['pdfAttached'] = true;
    setState(() {});
  }

  void openPdf(Map<String, dynamic> row) {
    if (kIsWeb && row['pdfBytes'] != null) {
      final blob = html.Blob([row['pdfBytes']], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.window.open(url, '_blank');
    }
  }

  // ======================= UI =======================

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Expertise Value Addition"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              expertiseTotalPoints = total31and32;
            },
          )
        ],
      ),
      backgroundColor: t.colorScheme.primary.withOpacity(.05),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _title(t, "3.1 Faculty Resource Utilization"),
          _card(_dynamic31()),
          _total(t, total31),
          const SizedBox(height: 40),
          _title(t, "3.2 Faculty Expertise / Recognition / Contribution"),
          _card(_dynamic32()),
          _total(t, total32),
        ]),
      ),
    );
  }

  // ======================= 3.1 =======================

  Widget _dynamic31() => Column(children: [
        ...List.generate(table31.length, (i) {
          final r = table31[i];
          return Row(children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: r['event'],
                items: events31
                    .map((e) =>
                        DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => r['event'] = v!),
                decoration: const InputDecoration(labelText: "Event"),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: r['role'],
                items: ['Organized', 'Resource Person', 'Participated']
                    .map((e) =>
                        DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    r['role'] = v!;
                    r['points'] = calc31(v, r['duration']);
                  });
                },
                decoration: const InputDecoration(labelText: "Role"),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(labelText: "Duration"),
                onChanged: (v) {
                  setState(() {
                    r['duration'] = v;
                    r['points'] = calc31(r['role'], v);
                  });
                },
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: () =>
                  r['pdfAttached'] == true ? openPdf(r) : pickPdf(r),
              icon: Icon(
                r['pdfAttached'] == true
                    ? Icons.check_circle
                    : Icons.upload_file,
                color:
                    r['pdfAttached'] == true ? Colors.green : Colors.indigo,
              ),
              label:
                  Text(r['pdfAttached'] == true ? "Attached" : "Upload"),
            ),
            const SizedBox(width: 8),
            _badge(r['points']),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: table31.length == 1
                  ? null
                  : () => setState(() => table31.removeAt(i)),
            )
          ]);
        }),

        /// ➕ ADD ROW (3.1)
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            icon: const Icon(Icons.add),
            label: const Text("Add Row"),
            onPressed: () => setState(() => table31.add({
                  'event': 'Conference',
                  'role': 'Organized',
                  'duration': '',
                  'points': 10,
                  'pdfAttached': false,
                  'pdfBytes': null,
                  'pdfPath': null,
                })),
          ),
        ),
      ]);

  // ======================= 3.2 =======================

  Widget _dynamic32() => Column(children: [
        ...List.generate(table32.length, (i) {
          final r = table32[i];
          return Row(children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: r['type'],
                items: expertisePoints.keys
                    .map((e) =>
                        DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    r['type'] = v!;
                    r['points'] = expertisePoints[v]!;
                  });
                },
                decoration:
                    const InputDecoration(labelText: "Expertise Type"),
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: () =>
                  r['pdfAttached'] == true ? openPdf(r) : pickPdf(r),
              icon: Icon(
                r['pdfAttached'] == true
                    ? Icons.check_circle
                    : Icons.upload_file,
                color:
                    r['pdfAttached'] == true ? Colors.green : Colors.indigo,
              ),
              label:
                  Text(r['pdfAttached'] == true ? "Attached" : "Upload"),
            ),
            const SizedBox(width: 8),
            _badge(r['points']),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: table32.length == 1
                  ? null
                  : () => setState(() => table32.removeAt(i)),
            )
          ]);
        }),

        /// ➕ ADD ROW (3.2)
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            icon: const Icon(Icons.add),
            label: const Text("Add Row"),
            onPressed: () => setState(() => table32.add({
                  'type': expertisePoints.keys.first,
                  'points': expertisePoints.values.first,
                  'pdfAttached': false,
                  'pdfBytes': null,
                  'pdfPath': null,
                })),
          ),
        ),
      ]);

  // ======================= COMMON =======================

  Widget _title(ThemeData t, String s) =>
      Text(s, style: t.textTheme.titleLarge);

  Widget _card(Widget c) => Card(
        margin: const EdgeInsets.only(top: 12),
        child: Padding(padding: const EdgeInsets.all(12), child: c),
      );

  Widget _badge(int p) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(.25),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text("$p"),
      );

  Widget _total(ThemeData t, int v) => Container(
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: t.colorScheme.primary.withOpacity(.15),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Self-Assessment Points (Max: 10)"),
            Text(v.toString(), style: t.textTheme.titleMedium),
          ],
        ),
      );
}