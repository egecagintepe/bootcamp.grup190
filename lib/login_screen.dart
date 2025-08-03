import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscurePassword = true;

  void _handleSignIn() {
    String email = emailController.text.trim();
    String password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      // Warning dialog in English
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Missing Information'),
          content: const Text('Please enter both email and password.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            )
          ],
        ),
      );
      return;
    }

    // Successful login -> go to home_screen
    Navigator.pushReplacementNamed(context, '/home');
  }

  void _showForgotPasswordDialog() {
    final TextEditingController forgotMailController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Reset Password"),
        content: TextField(
          controller: forgotMailController,
          decoration: const InputDecoration(
            hintText: "Enter your email address",
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              String mail = forgotMailController.text.trim();
              Navigator.pop(context); // Dialogu kapat
              if (mail.isEmpty) {
                // Eğer mail girmediyse uyarı
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Missing Information'),
                    content: const Text('Please enter your email address.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      )
                    ],
                  ),
                );
              } else {
                // Burada istersen gerçek backend'e gönderirsin (şimdi simülasyon)
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Reset Link Sent'),
                    content: const Text('A password reset link has been sent to your email address.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      )
                    ],
                  ),
                );
              }
            },
            child: const Text("Send"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: const Text('Welcome Back', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            const SizedBox(height: 16),
            const Text(
              'Sign in to continue managing your medications with AI assistance',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            const Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Enter your email',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
              ),
            ),
            const SizedBox(height: 18),
            const Text('Password', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            TextField(
              controller: passwordController,
              obscureText: obscurePassword,
              decoration: InputDecoration(
                hintText: 'Enter your password',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                suffixIcon: IconButton(
                  icon: Icon(obscurePassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => obscurePassword = !obscurePassword),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _showForgotPasswordDialog,
                child: const Text('Forgot Password?', style: TextStyle(color: Colors.blue)),
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _handleSignIn,
                child: const Text('Sign In', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account? "),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Signup'a geri döndür
                  },
                  child: const Text("Sign Up", style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}