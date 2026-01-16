import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:faculty_app1/Screens/portofiloscreen/Dashboard/dashboard.dart';
import 'package:faculty_app1/Screens/signandLogin/signup.dart';
import 'package:faculty_app1/Widgets/login_footer.dart';
import 'package:faculty_app1/Model/globaldata.dart';

// 🔐 SharedPreferences token save function
Future<void> saveToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString("token", token);
}

// 🔐 AuthServices backend login
class AuthServices {
  static const String baseUrl = "http://localhost:4000/api/auth"; 

  static Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse("$baseUrl/login"); // backend login endpoint
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // backend returns {"token": "..."}
    } else {
      throw Exception("Login failed: ${response.body}");
    }
  }
}

// 🔑 LoginScreen Page
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  static const double loginCardWidth = 320;
  static const double loginCardHeight = 430;

  final hodEmailController = TextEditingController();
  final hodPasswordController = TextEditingController();

  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scale = Tween(begin: 1.0, end: 0.95).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    hodEmailController.dispose();
    hodPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7EE),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            //  LOGO
            SizedBox(
              width: double.infinity,
              child: Image.network(
                'https://i.ibb.co/QGMtGdM/AUSlogo.jpg',
                fit: BoxFit.contain,
                height: 200,
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: Center(
                child: Text(
                  "FACULTY SELF APPRAISAL FORM ",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // LOGIN CARDS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                /// ADMIN LOGIN
                _sideLoginCard(
                  title: "Admin Login",
                  color: Colors.orangeAccent,
                  savedEmail: adminEmail,
                  savedPassword: adminPassword,
                ),

                /// HOD LOGIN
                _hodLogin(),

                /// STAFF LOGIN
                _sideLoginCard(
                  title: "Staff Login",
                  color: Colors.green,
                  savedEmail: staffEmail,
                  savedPassword: staffPassword,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 🔹 FOOTER LINKS
            const BottomFooter(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // HOD Login Card
  Widget _hodLogin() {
    return Column(
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
                ),
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
                _field("Password", hodPasswordController, isPassword: true),
                const SizedBox(height: 22),
                ScaleTransition(
                  scale: _scale,
                  child: GestureDetector(
                    onTapDown: (_) => _controller.forward(),
                    onTapUp: (_) {
                      _controller.reverse();
                      loginUser(
                        hodEmailController.text.trim(),
                        hodPasswordController.text.trim(),
                      );
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
              MaterialPageRoute(builder: (_) => const SignUpScreen()),
            );
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Text(
              "I don't have an account?",
              style: GoogleFonts.poppins(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }

  // Generic Field
  Widget _field(
    String label,
    TextEditingController controller, {
    bool isPassword = false,
  }) {
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

  // Admin/Staff Side Login Card
  Widget _sideLoginCard({
    required String title,
    required Color color,
    required String savedEmail,
    required String savedPassword,
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
            ),
          ],
        ),
        child: Column(
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
              ),
              onPressed: () {
                loginUser(
                  emailController.text.trim(),
                  passwordController.text.trim(),
                );
              },
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }

  // 🔐 Backend Login
  void loginUser(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter both email and password")),
      );
      return;
    }

    try {
      final res = await AuthServices.login(email, password);
      if (res['token'] != null) {
        await saveToken(res['token']); // save JWT token
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid email or password")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error occurred: ${e.toString()}")),
      );
    }
  }
}
