import 'package:faculty_app1/Screens/portofiloscreen/Dashboard/userdata.dart';
import 'package:faculty_app1/Screens/portofiloscreen/othersections/Expertise&Valueeddtion.dart';
import 'package:faculty_app1/Screens/portofiloscreen/othersections/administration.dart';
import 'package:faculty_app1/Screens/portofiloscreen/researchpage.dart/2.1paperpublications.dart';
import 'package:faculty_app1/Screens/portofiloscreen/researchpage.dart/2.6projectConsultancy.dart';
import 'package:faculty_app1/Screens/portofiloscreen/othersections/teaching.dart';
import 'package:flutter/material.dart';

class FacultyPortfolioPage extends StatefulWidget {
  const FacultyPortfolioPage({super.key});

  @override
  State<FacultyPortfolioPage> createState() => _FacultyPortfolioPageState();
}

class _FacultyPortfolioPageState extends State<FacultyPortfolioPage> {
  final Map<String, double> maxScores = {
    "Teaching": 80,
    "Research": 50,
    "Value Addition": 30,
    "Administration": 10,
    "Interpersonal Skills": 30,
  };

  final Map<String, IconData> icons = {
    "Teaching": Icons.menu_book,
    "Research": Icons.description,
    "Value Addition": Icons.trending_up,
    "Administration": Icons.groups,
    "Interpersonal Skills": Icons.star,
  };

  final Map<String, double> scores = {
    "Teaching": totalTeachingAvg.toDouble(),
    "Research": 0,
    "Value Addition": expertiseTotalPoints.toDouble(),
    "Administration": administrationtotal.toDouble(),
    "Interpersonal Skills": 0,
  };

  Color indicatorColor(double value, double max) {
    final p = (value / max) * 100;
    if (p >= 75) return Colors.green;
    if (p >= 40) return Colors.orange;
    return Colors.red;
  }

  double get totalWithoutInterpersonal =>
      scores.entries
          .where((e) => e.key != "Interpersonal Skills")
          .fold(0, (sum, e) => sum + e.value);

  double get grandTotal =>
      scores.values.fold(0, (sum, e) => sum + e);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Faculty Portfolio"),
        centerTitle: true,
        backgroundColor: const Color(0xffFF7A18),
         actions: [
      Padding(
        padding: const EdgeInsets.only(right: 12),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const UserProfilePage(),
              ),
            );
          },
          child: const CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              color: Color(0xFFF57C00),
            ),
          ),
        ),
      ),
],

      ),
      backgroundColor: const Color(0xffF6F6F6),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xffFF7A18), Color(0xffFF9F1C)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Faculty Performance Portfolio",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Annual Review (2025–26)",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// SCORE CARDS
            Wrap(
              spacing: 20,
              runSpacing: 20,
              children: scores.keys.map((k) {
                return _scoreCard(k);
              }).toList(),
            ),

            const SizedBox(height: 30),

            /// PERFORMANCE SUMMARY
            _summary(),

            const SizedBox(height: 30),

            /// DETAILS TABLE
            _detailsTable(),
          ],
        ),
      ),
    );
  }

  Widget _scoreCard(String title) {
    final max = maxScores[title]!;
    final value = scores[title]!;

    return GestureDetector(
      onTap: () => navigateToPage(context, title),
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor:
                      indicatorColor(value, max).withOpacity(0.15),
                  child: Icon(
                    icons[title],
                    color: indicatorColor(value, max),
                  ),
                ),
                const Spacer(),
                Text(
                  "Max ${max.toInt()}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
      
            /// SCORE DISPLAY 
            Text(
              "Score: ${value.toInt()}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
      
            const SizedBox(height: 14),
            LinearProgressIndicator(
              value: value / max,
              minHeight: 6,
              color: indicatorColor(value, max),
              backgroundColor: Colors.grey.shade300,
            ),
          ],
        ),
      ),
    );
  }

  Widget _summary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Performance Summary",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _summaryRow("Total Score", totalWithoutInterpersonal, 200),
          _summaryRow("Grand Total", grandTotal, 250),
        ],
      ),
    );
  }

  Widget _summaryRow(String title, double value, double max) {
    final color = indicatorColor(value, max);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$title : ${value.toInt()} / ${max.toInt()}"),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: value / max,
          color: color,
          backgroundColor: color.withOpacity(0.2),
          minHeight: 8,
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  Widget _detailsTable() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Detailed Performance Breakdown",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Table(
            border: TableBorder.all(color: Colors.grey.shade300),
            children: [
              _row("Category", "Max", "Score", "%", header: true),
              ...scores.keys.map((k) {
                final percent =
                    (scores[k]! / maxScores[k]!) * 100;
                return _row(
                  k,
                  maxScores[k]!.toInt().toString(),
                  scores[k]!.toInt().toString(),
                  "${percent.toStringAsFixed(0)}%",
                );
              }),
              _row(
                "Total (without Interpersonal)",
                "200",
                totalWithoutInterpersonal.toInt().toString(),
                "${(totalWithoutInterpersonal / 200 * 100).toStringAsFixed(0)}%",
              ),
              _row(
                "Grand Total",
                "250",
                grandTotal.toInt().toString(),
                "${(grandTotal / 250 * 100).toStringAsFixed(0)}%",
              ),
            ],
          ),
        ],
      ),
    );
  }

  TableRow _row(
    String a,
    String b,
    String c,
    String d, {
    bool header = false,
  }) {
    return TableRow(
      decoration: BoxDecoration(
        color: header ? Colors.orange.shade100 : null,
      ),
      children: [a, b, c, d]
          .map(
            (e) => Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                e,
                style: TextStyle(
                  fontWeight:
                      header ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
void navigateToPage(BuildContext context ,String title){
  Widget page;

  switch(title) {
    case "Teaching":
      page = const TeachingPage();
      break;
    case "Research" :
      page = const PaperPublication();
      break;
    case "Value Addition":
      page = const ExpertiseValueAddition();
      break;
      case "Administration":
      page = const AdministrationPage();
      break;
    case "Interpersonal Skills":
      page = const ProjectConsultancy();
      break;
    default :
      return;

  }
  Navigator.push(context,MaterialPageRoute(builder: (_)=>page),);
}