import 'package:faculty_app1/Screens/portofiloscreen/Dashboard/portofilopage.dart';
import 'package:faculty_app1/Widgets/sidebar.dart';
import 'package:flutter/material.dart';
import '../othersections/teaching.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Widget currentPage = const FacultyPortfolioPage();

  void changePage(Widget page) {
    setState(() {
      currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(onPageSelected: changePage),

          /// PAGE TRANSITION 
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, animation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.2, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                );
              },
              child: currentPage,
            ),
          ),
        ],
      ),
    );
  }
}
