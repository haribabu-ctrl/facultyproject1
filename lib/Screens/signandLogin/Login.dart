import 'package:faculty_app1/Screens/portofiloscreen/Dashboard/dashboard.dart';
import 'package:faculty_app1/Screens/signandLogin/signup.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:faculty_app1/Model/globaldata.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {

  /// FIXED SIZE FOR ALL 3 CARDS
  static const double loginCardWidth = 320;
  static const double loginCardHeight = 430;

  final hodEmailController = TextEditingController();
  final hodPasswordController = TextEditingController();

  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _scale = Tween(begin: 1.0, end: 0.95).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void hodLogin() {
    final email = hodEmailController.text;
    final password = hodPasswordController.text;

    if (email == hodEmail && password == hodPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("HOD Login Successful")),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DashboardPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid HOD Credentials")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7EE),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
                    width: double.infinity,
                    height: 100,
                    child: Image.network(
            'https://in8cdn.npfs.co/uploads/template/6102/1556/publish/images/au_logo.png?1737981139',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Text(
                  "Image not found",
                  style: TextStyle(color: Colors.red),
                ),
              );
            },
                    ),
                  ),
          ),
      SizedBox(height: 40,),

          Center(
            child: SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
          
                  /// ADMIN LOGIN
                  _sideLoginCard(
                    title: "Admin Login",
                    color: Colors.orangeAccent,
                    savedEmail: adminEmail,
                    savedPassword: adminPassword,
                    successText: "Admin Login Successful",
                    failText: "Invalid Admin Credentials",
                  ),
          
                  /// HOD LOGIN
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: loginCardWidth,
                        height: loginCardHeight,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 12,
                                offset: Offset(0, 6),
                              )
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "HOD Login",
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              _field("Email", hodEmailController),
                              const SizedBox(height: 16),
                              _field("Password", hodPasswordController,
                                  isPassword: true),
                              const SizedBox(height: 22),
                              ScaleTransition(
                                scale: _scale,
                                child: GestureDetector(
                                  onTapDown: (_) => _controller.forward(),
                                  onTapUp: (_) {
                                    _controller.reverse();
                                    hodLogin();
                                  },
                                  onTapCancel: () => _controller.reverse(),
                                  child: Container(
                                    height: 48,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: const LinearGradient(
                                        colors: [Colors.orange, Colors.blue],
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Login",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => SignUpScreen()),
                          );
                        },
                        child: Text(
                          "I don't have an account?",
                          style: GoogleFonts.poppins(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
          
                  /// STAFF LOGIN
                  _sideLoginCard(
                    title: "Staff Login",
                    color: Colors.green,
                    savedEmail: staffEmail,
                    savedPassword: staffPassword,
                    successText: "Staff Login Successful",
                    failText: "Invalid Staff Credentials",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(String label, TextEditingController controller,
      {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins()),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFFFF3E6),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _sideLoginCard({
    required String title,
    required Color color,
    required String savedEmail,
    required String savedPassword,
    required String successText,
    required String failText,
  }) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return SizedBox(
      width: loginCardWidth,
      height: loginCardHeight,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 5),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 14),
            _field("Email", emailController),
            const SizedBox(height: 12),
            _field("Password", passwordController, isPassword: true),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                minimumSize: const Size(double.infinity, 42),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                final email = emailController.text;
                final password = passwordController.text;

                if (email == savedEmail && password == savedPassword) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(successText)),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DashboardPage()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(failText)),
                  );
                }
              },
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}