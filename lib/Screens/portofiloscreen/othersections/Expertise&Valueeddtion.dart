import 'package:flutter/material.dart';
int expertiseTotalPoints = 0;

class ExpertiseValueAddition extends StatefulWidget {
  const ExpertiseValueAddition({super.key});

  @override
  State<ExpertiseValueAddition> createState() =>
      _ExpertiseValueAdditionPageState();
}

class _ExpertiseValueAdditionPageState
    extends State<ExpertiseValueAddition> {
  // ======================= 3.1 Dynamic =======================
  List<Map<String, dynamic>> table31 = [
    {
      'event': 'Conference',
      'role': 'Organized',
      'duration': '',
      'points': 10,
    }
  ];

  final List<String> events31 = [
    'Conference',
    'STTP / Refresher Course',
    'FDP / Symposium',
    'Guest Lecture / Workshop / Event',
  ];

  // ======================= 3.2 Dynamic =======================
  List<Map<String, dynamic>> table32 = [
    {'type': 'Member of BOG/GB/AC/BOS', 'points': 5}
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
  int get total31and32 { return total31 + total32;}
  

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);

    return Scaffold(
      
  appBar: AppBar(
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
          _card(_reference31()),
          _card(_dynamic31()),
          _total(t, total31),
          const SizedBox(height: 40),
          _title(t, "3.2 Faculty Expertise / Recognition / Contribution"),
          _card(_reference32()),
          _card(_dynamic32()),
          _total(t, total32),
        ]),
      ),
    );
  }

  // ======================= TABLES =======================

  Widget _reference31() => Table(
        border: TableBorder.all(),
        columnWidths: const {
          0: FlexColumnWidth(3),
          1: FlexColumnWidth(5),
          2: FlexColumnWidth(2),
          3: FlexColumnWidth(2),
        },
        children: const [
          TableRow(children: [
            _TH("Event"),
            _TH("Organized"),
            _TH("Resource Person"),
            _TH("Participated"),
          ]),
          TableRow(children: [
            _TC("Conference"),
            _TC(
                "10 points for Chair, Co-Chair, Finance, Publication, Registration Chair"),
            _TC("2 points/session"),
            _TC("1 point/day"),
          ]),
          TableRow(children: [
            _TC("STTP / Refresher (Min 2 Weeks)"),
            _TC("10 points for Convenor, Co-Convenor & Coordinator"),
            _TC("2 points/session"),
            _TC("1 point/day"),
          ]),
          TableRow(children: [
            _TC("FDP / Symposium (Min 1 Week)"),
            _TC("10 points for Convenor, Co-Convenor & Coordinator"),
            _TC("2 points/session"),
            _TC("1 point/day"),
          ]),
          TableRow(children: [
            _TC("Guest Lecture / Workshop / Event"),
            _TC("2 points for Coordinator"),
            _TC("2 points/session"),
            _TC("NA"),
          ]),
        ],
      );

  Widget _dynamic31() => Column(children: [
        ...List.generate(table31.length, (i) {
          final r = table31[i];
          return Row(children: [
            // EVENT
            Expanded(
              child: DropdownButtonFormField<String>(
                value: r['event'],
                items: events31
                    .map((e) =>
                        DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) =>
                    setState(() => r['event'] = v!),
                decoration: const InputDecoration(labelText: "Event"),
              ),
            ),
            const SizedBox(width: 8),

            // ROLE
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

            // DURATION
            Expanded(
              child: TextFormField(
                decoration:
                    const InputDecoration(labelText: "Duration"),
                onChanged: (v) {
                  setState(() {
                    r['duration'] = v;
                    r['points'] = calc31(r['role'], v);
                  });
                },
              ),
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
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            icon: const Icon(Icons.add),
            label: const Text("Add Row"),
            onPressed: () => setState(() => table31.add({
                  'event': 'Conference',
                  'role': 'Organized',
                  'duration': '',
                  'points': 10
                })),
          ),
        )
      ]);

  Widget _reference32() => Table(
        border: TableBorder.all(),
        columnWidths: const {
          0: FixedColumnWidth(40),
          1: FlexColumnWidth(6),
          2: FixedColumnWidth(80),
        },
        children: [
          const TableRow(children: [
            _TH("S.No"),
            _TH("Expertise / Recognition / Contribution"),
            _TH("Points"),
          ]),
          ...expertisePoints.entries.toList().asMap().entries.map((e) {
            return TableRow(children: [
              _TC("${e.key + 1}"),
              _TC(e.value.key),
              _TC(e.value.value.toString()),
            ]);
          }),
        ],
      );

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
                onChanged: (v) =>
                    setState(() => r['points'] = expertisePoints[v]!),
                decoration:
                    const InputDecoration(labelText: "Expertise Type"),
              ),
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
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            icon: const Icon(Icons.add),
            label: const Text("Add Row"),
            onPressed: () => setState(() => table32.add({
                  'type': expertisePoints.keys.first,
                  'points': expertisePoints.values.first
                })),
          ),
        )
      ]);

  // ======================= UI HELPERS =======================

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
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text("Self-Assessment Points (Max: 10)"),
          Text(v.toString(), style: t.textTheme.titleMedium),
        ]),
      );
}

// ======================= TABLE CELLS =======================

class _TH extends StatelessWidget {
  final String t;
  const _TH(this.t);
  @override
  Widget build(BuildContext c) =>
      Padding(padding: const EdgeInsets.all(8), child: Text(t));
}

class _TC extends StatelessWidget {
  final String t;
  const _TC(this.t);
  @override
  Widget build(BuildContext c) =>
      Padding(padding: const EdgeInsets.all(8), child: Text(t));
}