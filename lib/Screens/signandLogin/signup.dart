import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'Login.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _StaffSignUpPageState();
}

class _StaffSignUpPageState extends State<SignUpScreen> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController employIDController = TextEditingController();
  final TextEditingController nameEmpIdController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController dateOfJoiningController = TextEditingController();
  final TextEditingController scopusIdController = TextEditingController();
  final TextEditingController webOfScienceIdController = TextEditingController();
  final TextEditingController orcidIdController = TextEditingController();

  String? selectedRole;
  String? selectedQualification;
  String? selectedschool;
  String? selectedDepartment;

  final List<String> qualificationOptions = ["PhD", "Non‑PhD"];
  final List<String> roleOptions = ["Admin", "HOD", "Staff"];
  final List<String> schoolOption = [
    "School Of Engineering",
    "School Of Business",
    "School Of Sience",
    "School Of Pharmacy",
  ];

  final List<String> departmentOptions = [
    "Civil Engineering",
    "Electrical and Electronics Engineering",
    "Mechanical Engineering",
    "Electronics and Communication Engineering",
    "Agricultural Engineering",
    "Mining Engineering",
    "Petroleum Technology",
  ];

  // 🔹 Backend function - modified for debugging
  Future<void> signupUser() async {
    final url = "http://localhost:4000/api/auth/register";
    // For real device, use your PC IP like: http://192.168.x.x:4000

    final data = {
      "username": usernameController.text,
      "password": passwordController.text,
      "role": selectedRole,
      "name": nameEmpIdController.text,
      "employeeId": employIDController.text,
      "designation": designationController.text,
      "department": selectedDepartment,
      "dateOfJoining": dateOfJoiningController.text,
      "qualification": selectedQualification,
      "scopusId": scopusIdController.text,
      "webofScienceId": webOfScienceIdController.text,
      "orcidId": orcidIdController.text,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      // ⚡ Debug prints
      print("REQUEST BODY: ${jsonEncode(data)}");
      print("STATUS CODE: ${response.statusCode}");
      print("RESPONSE BODY: ${response.body}");

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Signup Successful")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Signup failed: ${response.body}")),
        );
      }
    } catch (e) {
      print("ERROR: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5EA),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              width: 420,
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Center(
                      child: Text(
                        "ACCOUNT REGISTRATION",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    _buildField("User Name", usernameController),
                    _buildField("Password", passwordController, obscure: true),

                    const SizedBox(height: 10),
                    const Text("Select Role",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    _buildRoleField(),

                    const SizedBox(height: 20),
                    const Text(
                      "PART‑A : Personal Information",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const Divider(),

                    _buildField("Name", nameEmpIdController),
                    _buildField("Employ‑ID", employIDController),
                    _buildField("Designation", designationController),
                    _buildSchoolField(),
                    _buildDepartmentField(),
                    _buildField("Date of Joining", dateOfJoiningController),
                    _buildQualificationField(),
                    _buildField("Scopus ID", scopusIdController),
                    _buildField("Web of Science ID", webOfScienceIdController),
                    _buildField("ORCID ID", orcidIdController),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            signupUser(); // call backend
                          }
                        },
                        child: const Text("Sign Up"),
                      ),
                    ),

                    const SizedBox(height: 22),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => LoginScreen()),
                        );
                      },
                      child: Text(
                        "Already have an account?",
                        style: GoogleFonts.poppins(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller,
      {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        validator: (value) =>
            value == null || value.isEmpty ? "Enter $label" : null,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: const Color(0xFFFFEEDD),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildRoleField() {
    return DropdownButtonFormField<String>(
      value: selectedRole,
      items: roleOptions
          .map((r) => DropdownMenuItem(value: r, child: Text(r)))
          .toList(),
      onChanged: (v) => setState(() => selectedRole = v),
      validator: (v) => v == null ? "Please select Role" : null,
      decoration: _dropDecoration("Role"),
    );
  }

  Widget _buildSchoolField() {
    return DropdownButtonFormField<String>(
      value: selectedschool,
      items: schoolOption
          .map((s) => DropdownMenuItem(value: s, child: Text(s)))
          .toList(),
      onChanged: (v) {
        setState(() {
          selectedschool = v;
          selectedDepartment = null;
        });
      },
      validator: (v) => v == null ? "Please select School" : null,
      decoration: _dropDecoration("School"),
    );
  }

  Widget _buildDepartmentField() {
    List<String> deptList = [];
    if (selectedschool == "School Of Engineering") {
      deptList = departmentOptions;
    }

    return DropdownButtonFormField<String>(
      value: selectedDepartment,
      items: deptList
          .map((d) => DropdownMenuItem(value: d, child: Text(d)))
          .toList(),
      onChanged: deptList.isEmpty
          ? null
          : (v) => setState(() => selectedDepartment = v),
      validator: (v) {
        if (selectedschool == "School Of Engineering" && v == null) {
          return "Please select Department";
        }
        return null;
      },
      decoration: _dropDecoration("Department"),
    );
  }

  Widget _buildQualificationField() {
    return DropdownButtonFormField<String>(
      value: selectedQualification,
      items: qualificationOptions
          .map((q) => DropdownMenuItem(value: q, child: Text(q)))
          .toList(),
      onChanged: (v) => setState(() => selectedQualification = v),
      validator: (v) => v == null ? "Please select Qualification" : null,
      decoration: _dropDecoration("Qualification"),
    );
  }

  InputDecoration _dropDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: const Color(0xFFFFEEDD),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none),
    );
  }
}
