import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? selectedRole = "Student";
  bool isConsent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome Back"),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Login to continue",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      const TextField(
                        decoration: InputDecoration(
                          labelText: "Email",
                          hintText: "Enter your email",
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                      ),
                      const SizedBox(height: 15),
                      const TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          hintText: "Enter your password",
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text("Select Role:", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                      RadioListTile(
                        value: "Admin",
                        groupValue: selectedRole,
                        title: const Text("Admin"),
                        activeColor: const Color(0xFF14B8A6),
                        onChanged: (value) => setState(() => selectedRole = value),
                      ),
                      RadioListTile(
                        value: "Faculty",
                        groupValue: selectedRole,
                        title: const Text("Faculty"),
                        activeColor: const Color(0xFF14B8A6),
                        onChanged: (value) => setState(() => selectedRole = value),
                      ),
                      RadioListTile(
                        value: "Student",
                        groupValue: selectedRole,
                        title: const Text("Student"),
                        activeColor: const Color(0xFF14B8A6),
                        onChanged: (value) => setState(() => selectedRole = value),
                      ),
                      CheckboxListTile(
                        onChanged: (value) => setState(() => isConsent = value!),
                        value: isConsent,
                        title: const Text("Remember me"),
                        activeColor: const Color(0xFF14B8A6),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text("Login"),
                      ),
                      const Spacer(),
                      const SizedBox(height: 20),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: "Don't have an account? ",
                            style: const TextStyle(color: Colors.black87, fontSize: 14),
                            children: [
                              TextSpan(
                                text: "Sign Up",
                                style: const TextStyle(
                                  color: Color(0xFF14B8A6),
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const SignupPage()),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
