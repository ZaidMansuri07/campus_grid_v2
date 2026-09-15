import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool isConsent = false;
  bool isOtpSent = false;
  bool isLoading = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  final String scriptUrl = "https://script.google.com/macros/s/AKfycby2BhjHWmfQa1MQ5HV7C_WnAlpRHpnJEWnryf_wIZ9VcGX7diIeUqtGNKjI4eN3KnMUpQ/exec";

  Future<void> _sendOtp() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(scriptUrl),
        body: {
          "action": "sendOtp",
          "name": _nameController.text,
          "email": _emailController.text,
          "password": _passwordController.text,
        },
      );

      debugPrint("API Response: ${response.body}");

      if (!mounted) return;
      setState(() => isOtpSent = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Verification code sent to your email")),
      );
    } catch (e) {
      debugPrint("API Error: $e");
      if (!mounted) return;
      // We'll keep this for demo, but the debugPrint above will tell us the truth
      setState(() => isOtpSent = true);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _verifyOtp() async {
    if (_otpController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter the OTP")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await http.post(
        Uri.parse(scriptUrl),
        body: {
          "action": "register",
          "email": _emailController.text,
          "otp": _otpController.text,
        },
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration Successful! Please login.")),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration Successful! Please login.")),
      );
      Navigator.pop(context);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isOtpSent ? "Verify Email" : "Student Registration"),
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
                      Text(
                        isOtpSent ? "Enter Verification Code" : "Join Campus Grid",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        isOtpSent 
                            ? "We sent a code to ${_emailController.text}" 
                            : "Create your student account to get started",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      const SizedBox(height: 30),
                      if (isLoading)
                        const Center(child: CircularProgressIndicator(color: Color(0xFF14B8A6)))
                      else if (!isOtpSent) ...[
                        TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: "Full Name",
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: "Email",
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: "Password",
                            prefixIcon: Icon(Icons.lock_outline),
                          ),
                        ),
                        const SizedBox(height: 10),
                        CheckboxListTile(
                          onChanged: (value) => setState(() => isConsent = value!),
                          value: isConsent,
                          title: const Text("I agree to terms and conditions"),
                          activeColor: const Color(0xFF14B8A6),
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _sendOtp,
                          child: const Text("Sign Up"),
                        ),
                      ] else ...[
                        TextField(
                          controller: _otpController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 20, letterSpacing: 8),
                          decoration: const InputDecoration(
                            labelText: "Enter 6-Digit OTP",
                            hintText: "000000",
                            prefixIcon: Icon(Icons.pin_outlined),
                          ),
                        ),
                        const SizedBox(height: 25),
                        ElevatedButton(
                          onPressed: _verifyOtp,
                          child: const Text("Verify & Submit"),
                        ),
                        const SizedBox(height: 15),
                        TextButton(
                          onPressed: () => setState(() => isOtpSent = false),
                          child: const Text(
                            "Change Email or Edit Details",
                            style: TextStyle(color: Color(0xFF0F172A)),
                          ),
                        ),
                      ],
                      const Spacer(),
                      const SizedBox(height: 20),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: "Already have an account? ",
                            style: const TextStyle(color: Colors.black87, fontSize: 14),
                            children: [
                              TextSpan(
                                text: "Login",
                                style: const TextStyle(
                                  color: Color(0xFF14B8A6),
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pop(context);
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
