import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  Map<String, dynamic>? staffProfileData;
  bool loading = true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
    _loadUserFromPrefs();
  }

  // 🔐 LOAD LOGIN USER DATA (FROM BACKEND LOGIN RESPONSE)
  Future<void> _loadUserFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString("userData");

      if (userJson == null) {
        setState(() {
          loading = false;
          staffProfileData = null;
        });
        return;
      }

      setState(() {
        staffProfileData = jsonDecode(userJson);
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
        staffProfileData = null;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (staffProfileData == null) {
      return const Scaffold(
        body: Center(child: Text("Failed to load user profile")),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFF5EA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF57C00),
        title: const Text("User Profile"),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _profileHeader(),
                const SizedBox(height: 20),
                _infoCard(
                  title: "Personal Information",
                  children: [
                    _infoRow("Name", staffProfileData!["name"]),
                    _infoRow("Employee ID", staffProfileData!["employeeId"]),
                    _infoRow("Designation", staffProfileData!["designation"]),
                    _infoRow("Department", staffProfileData!["department"]),
                    _infoRow(
                        "Date of Joining",
                        staffProfileData!["dateOfJoining"]),
                    _infoRow(
                        "Qualification",
                        staffProfileData!["qualification"]),
                  ],
                ),
                const SizedBox(height: 16),
                _infoCard(
                  title: "Research Profiles",
                  children: [
                    _infoRow("Scopus ID", staffProfileData!["scopusId"]),
                    _infoRow("Web of Science ID",
                        staffProfileData!["webofScienceId"]),
                    _infoRow("ORCID ID", staffProfileData!["orcidId"]),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 PROFILE HEADER (UI UNTOUCHED)
  Widget _profileHeader() {
    return Column(
      children: [
        const CircleAvatar(
          radius: 45,
          backgroundColor: Color(0xFFF57C00),
          child: Icon(Icons.person, size: 50, color: Colors.white),
        ),
        const SizedBox(height: 10),
        Text(
          staffProfileData!["name"] ?? "User Name",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          staffProfileData!["designation"] ?? "",
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: Colors.grey[700],
          ),
        ),
        Text(
          staffProfileData!["department"] ?? "",
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  // 🔹 INFO CARD
  Widget _infoCard(
      {required String title, required List<Widget> children}) {
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
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFF57C00),
              ),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  // 🔹 INFO ROW
  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(value?.isNotEmpty == true ? value! : "-"),
          ),
        ],
      ),
    );
  }
}
