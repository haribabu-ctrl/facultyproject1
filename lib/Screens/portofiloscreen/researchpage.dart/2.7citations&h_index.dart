import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// GLOBAL VARIABLE
int scopustotalPoints = 0;

class ScopusScorePage extends StatefulWidget {
  const ScopusScorePage({super.key});

  @override
  State<ScopusScorePage> createState() => _ScopusScorePageState();
}

class _ScopusScorePageState extends State<ScopusScorePage> {
  final TextEditingController citationController = TextEditingController();
  final TextEditingController h2024Controller = TextEditingController();
  final TextEditingController h2025Controller = TextEditingController();

  double citationPoints = 0.0;
  int hIndexPoints = 0;

  /// 2.7 Calculation
  void calculateCitationPoints() {
    final citations = double.tryParse(citationController.text) ?? 0;
    setState(() {
      citationPoints = citations * 0.2;
    });
  }

  /// 2.8 Calculation
  void calculateHIndexPoints() {
    final h2024 = int.tryParse(h2024Controller.text) ?? 0;
    final h2025 = int.tryParse(h2025Controller.text) ?? 0;

    final increase = h2025 - h2024;
    if (increase <= 0) {
      setState(() => hIndexPoints = 0);
      return;
    }

    int pointsPerRaise;
    if (h2025 < 5) {
      pointsPerRaise = 1;
    } else if (h2025 >= 5 && h2025 <= 10) {
      pointsPerRaise = 2;
    } else {
      pointsPerRaise = 4;
    }

    setState(() {
      hIndexPoints = increase * pointsPerRaise;
    });
  }

  @override
  Widget build(BuildContext context) {
    final int totalPoints =
        citationPoints.round() + hIndexPoints;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF5EA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF57C00),
        title: const Text("Scopus Score Details"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// ===================== 2.7 =====================
            _card(
              title:
                  "2.7 Scopus Citation Score Points\n(0.2 point / citation in 2025)",
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: citationController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Enter Citation Count For Calender Year",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => calculateCitationPoints(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    children: [
                      const Icon(Icons.check_box,
                          color: Colors.green, size: 28),
                      Text(
                        citationPoints.toStringAsFixed(2),
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 18),

            /// ===================== 2.8 =====================
            _card(
              title:
                  "2.8 Scopus h-index Score Points\n"
                  "(<5 → 1pt | 5–10 → 2pt | >10 → 4pt per raise)",
              child: Column(
                children: [
                  TextField(
                    controller: h2024Controller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "h-index in 2024",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => calculateHIndexPoints(),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: h2025Controller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "h-index in 2025",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => calculateHIndexPoints(),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_box,
                            color: Colors.green, size: 26),
                        const SizedBox(width: 6),
                        Text(
                          "Points: $hIndexPoints",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// ===================== TOTAL + SAVE =====================
            _card(
              title: "Scopus Total Points (2.7 + 2.8)",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total: $totalPoints",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      scopustotalPoints = totalPoints;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Saved Successfully: $scopustotalPoints points",
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    child: Text(
                      "SAVE",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ===================== CARD WIDGET =====================
  Widget _card({required String title, required Widget child}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFF57C00),
              ),
            ),
            const Divider(),
            child,
          ],
        ),
      ),
    );
  }
}
