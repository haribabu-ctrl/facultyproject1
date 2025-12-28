import 'package:flutter/material.dart';

class ExpertiseRecognitionPage extends StatefulWidget {
  const ExpertiseRecognitionPage({super.key});

  @override
  State<ExpertiseRecognitionPage> createState() =>
      _ExpertiseRecognitionPageState();
}

class _ExpertiseRecognitionPageState extends State<ExpertiseRecognitionPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final List<Map<String, dynamic>> rows = [
    {"title": "Member of BoG/BoM/BoE/etc.", "max": 5},
    {"title": "Key contributor for NBA/NAAC/NIRF", "max": 3},
    {"title": "Reviewer/Editor for Scopus journals", "max": 2},
    {"title": "Expert/Consultant outside AU", "max": 5},
    {"title": "Invited speaker (International)", "max": 3},
    {"title": "Invited speaker (National)", "max": 2},
    {"title": "Session chair (International)", "max": 2},
    {"title": "Session chair (National)", "max": 1},
    {"title": "Examiner for Ph.D viva", "max": 2},
    {"title": "Participation with certificate", "max": 1},
    {"title": "Organized International FDP", "max": 5},
    {"title": "Organized National FDP", "max": 3},
    {"title": "Professional society membership", "max": 1},
  ];

  late List<TextEditingController> controllers;

  @override
  void initState() {
    super.initState();
    controllers =
        List.generate(rows.length, (index) => TextEditingController());
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    for (var c in controllers) {
      c.dispose();
    }
    super.dispose();
  }

  int get totalPoints {
    int total = 0;
    for (var c in controllers) {
      total += int.tryParse(c.text) ?? 0;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F2),
      
      body: _content(), // ✅ ONLY RIGHT SIDE CONTENT
    );
  }

  Widget _content() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "SECTION 3: Faculty Expertise, Recognition and Contribution",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFF57C00),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: rows.length,
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _controller,
                      child: Transform.translate(
                        offset:
                            Offset(0, 30 * (1 - _controller.value)),
                        child: _rowCard(index),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          _totalBox(),
        ],
      ),
    );
  }

  Widget _rowCard(int index) {
    final max = rows[index]["max"];
    final entered = int.tryParse(controllers[index].text) ?? 0;
    final isMax = entered == max;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isMax ? Colors.green : const Color(0xFFE0E0E0),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(rows[index]["title"]),
          ),
          Expanded(
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE0B2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(max.toString()),
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controllers[index],
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: "0",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _totalBox() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE0B2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Total Points Claimed:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            totalPoints.toString(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFF57C00),
            ),
          )
        ],
      ),
    );
  }
}