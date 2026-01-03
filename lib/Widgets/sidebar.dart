import 'package:faculty_app1/Screens/portofiloscreen/othersections/Expertise&Valueeddtion.dart';
import 'package:faculty_app1/Screens/portofiloscreen/othersections/administration.dart';
import 'package:faculty_app1/Screens/portofiloscreen/Dashboard/dashboard.dart';
import 'package:faculty_app1/Screens/portofiloscreen/Dashboard/portofilopage.dart';
import 'package:faculty_app1/Screens/portofiloscreen/researchpage.dart/2.4Patents.dart';
import 'package:faculty_app1/Screens/portofiloscreen/researchpage.dart/2.3bookschaptersConfirrence.dart';
import 'package:faculty_app1/Screens/portofiloscreen/researchpage.dart/2.2guiding%20PH.D%20Scholors.dart';
import 'package:faculty_app1/Screens/portofiloscreen/researchpage.dart/2.1paperpublications.dart';
import 'package:faculty_app1/Screens/portofiloscreen/researchpage.dart/2.6projectConsultancy.dart';
import 'package:faculty_app1/Screens/portofiloscreen/researchpage.dart/Novel%20productsTechnology.dart';
import 'package:faculty_app1/Screens/portofiloscreen/othersections/teaching.dart';
import 'package:flutter/material.dart';
class Sidebar extends StatelessWidget {
  final Function(Widget) onPageSelected;

  const Sidebar({super.key, required this.onPageSelected});

  Widget _menuItem(String title, IconData icon, Widget page) {
    return InkWell(
      onTap: () => onPageSelected(page),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFFE9D6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.deepOrange),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      color: const Color(0xFFFFF4E8),
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Faculty Portfolio",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
            const SizedBox(height: 20),

            _menuItem("Dashboard", Icons.dashboard, FacultyPortfolioPage()),
            _menuItem("Teaching", Icons.menu_book, TeachingPage()),

            // ===== Research Section =====
            ExpansionTile(
              iconColor: Colors.deepOrange,
              collapsedIconColor: Colors.deepOrange,
              title: Row(
                children: const [
                  Icon(Icons.science, color: Colors.deepOrange),
                  SizedBox(width: 10),
                  Text(
                    "Research",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              children: [
                ListTile(
                  leading:
                      const Icon(Icons.article, color: Colors.deepOrange),
                  title: const Text("Paper Publication"),
                  onTap: () =>
                      onPageSelected(PaperPublication()),
                ),
                ListTile(
                  leading:
                      const Icon(Icons.school, color: Colors.deepOrange),
                  title: const Text("Guiding Ph.D Scholars"),
                  onTap: () =>
                      onPageSelected(GuidingPhDScholar()),
                ),
                ListTile(
                  leading:
                      const Icon(Icons.menu_book, color: Colors.deepOrange),
                  title:
                      const Text("Books / Chapters / Conference"),
                  onTap: () =>
                      onPageSelected(BooksChaptersProceeding()),
                ),
                ListTile(
                  leading:
                      const Icon(Icons.workspace_premium,
                          color: Colors.deepOrange),
                  title: const Text("Patents"),
                  onTap: () =>
                      onPageSelected(PatentsPage()),
                ),
                ListTile(
                  leading:
                      const Icon(Icons.lightbulb,
                          color: Colors.deepOrange),
                  title:
                      const Text("Novel Products / Technology"),
                  onTap: () =>
                      onPageSelected(NovelProduct()),
                ),
                ListTile(
                  leading:
                      const Icon(Icons.lightbulb,
                          color: Colors.red),
                  title:
                      const Text("Project Consultancy"),
                  onTap: () =>
                      onPageSelected(ProjectConsultancy()),
                ),
              ],
            ),

            _menuItem(
              "Expertise\n/value Addition",
              Icons.trending_up,
              ExpertiseValueAddition(),
            ),
            _menuItem(
              "Administration",
              Icons.admin_panel_settings,
              AdministrationPage(),
            ),
            // _menuItem(
            //   "Interpersonal",
            //   Icons.people,
            //   InterpersonalPage(),
            // ),
          ],
        ),
      ),
    );
  }
}
