import 'package:faculty_app1/Screens/signandLogin/Login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:faculty_app1/Screens/portofiloscreen/Dashboard/globaldata.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _StaffSignUpPageState();
}

class _StaffSignUpPageState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController employIDController = TextEditingController();
  final TextEditingController nameEmpIdController = TextEditingController();
  final TextEditingController designationDeptController =
      TextEditingController();
  final TextEditingController dateOfJoiningController =
      TextEditingController();
  final TextEditingController qualificationController =
      TextEditingController();
  final TextEditingController scopusIdController = TextEditingController();
  final TextEditingController webOfScienceIdController =
      TextEditingController();
  final TextEditingController orcidIdController = TextEditingController();

  // 🔹 Qualification dropdown data
  String? selectedQualification;
  final List<String> qualificationOptions = ["PhD", "Non-PhD"];

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
                        "Staff Sign Up",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildField("User Name", usernameController),
                    _buildField("Password", passwordController,
                        obscure: true),

                    const SizedBox(height: 15),
                    const Text(
                      "PART-A : Personal Information",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const Divider(),

                    _buildField("Name", nameEmpIdController),
                    _buildField("Employ-ID", employIDController),
                    _buildField("Designation & Department",
                        designationDeptController),
                    _buildField("Date of Joining",
                        dateOfJoiningController),

                    /// 🔹 QUALIFICATION DROPDOWN (FIXED)
                    _buildQualificationField(),

                    _buildField("Scopus ID", scopusIdController),
                    _buildField("Web of Science ID",
                        webOfScienceIdController),
                    _buildField("ORCID ID", orcidIdController),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () {
  if (_formKey.currentState!.validate()) {

    savedEmail = usernameController.text;
    savedPassword = passwordController.text;

    staffProfileData = {
      "username": usernameController.text,
      "password": passwordController.text,
      "name": nameEmpIdController.text,
      "employeeId": employIDController.text,
      "designationDept": designationDeptController.text,
      "dateOfJoining": dateOfJoiningController.text,
      "qualification": selectedQualification, // ✅ FIX
      "scopusId": scopusIdController.text,
      "webOfScienceId": webOfScienceIdController.text,
      "orcidId": orcidIdController.text,
    };

    debugPrint(staffProfileData.toString());

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  }
},
                        child: const Text("Sign Up"),
                      ),
                    ),

                    const SizedBox(height: 22),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => LoginScreen()),
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

  // 🔹 NORMAL TEXT FIELD
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
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // 🔹 QUALIFICATION DROPDOWN 
  Widget _buildQualificationField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: selectedQualification,
        items: qualificationOptions
            .map(
              (q) => DropdownMenuItem(
                value: q,
                child: Text(q),
              ),
            )
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedQualification = value;
            
          });
        },
        validator: (value) =>
            value == null ? "Please select Qualification" : null,
        decoration: InputDecoration(
          labelText: "Qualification",
          filled: true,
          fillColor: const Color(0xFFFFEEDD),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}