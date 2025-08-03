import 'package:flutter/material.dart';
import 'health_info_screen.dart';
import 'login_screen.dart'; // Login ekranı importu

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            const Text(
              'Medecai',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your AI-powered medication companion for safer, smarter healthcare',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 40),
            _FeatureItem(
              checked: false,
              title: 'AI Side Effect Analysis',
              subtitle: 'Get instant insights about drug interactions',
            ),
            _FeatureItem(
              checked: true,
              title: 'Smart Reminders',
              subtitle: 'Never miss a dose with personalized alerts',
            ),
            _FeatureItem(
              checked: true,
              title: 'Instant Drug Lookup',
              subtitle: 'Search comprehensive medication database',
            ),
            const Spacer(),
            const Divider(),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()),
                  );
                },
                child: const Text(
                  'Get Started',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: const Text(
                'I already have an account',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final bool checked;
  final String title;
  final String subtitle;

  const _FeatureItem({
    required this.checked,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            checked ? Icons.check_circle : Icons.radio_button_unchecked,
            color: checked ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- BURASI YENİ VE KONTROLLÜ SIGNUP ---

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  void _handleSignUp() {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    // Email format kontrolü
    bool emailValid = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email);

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showDialog("Missing Information", "Please fill in all fields.");
      return;
    }
    if (!emailValid) {
      _showDialog("Invalid Email", "Please enter a valid email address.");
      return;
    }
    if (password.length < 6) {
      _showDialog("Weak Password", "Password must be at least 6 characters.");
      return;
    }
    if (password != confirmPassword) {
      _showDialog("Password Mismatch", "Passwords do not match.");
      return;
    }

    // Tüm kontroller geçerse ilerle
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HealthInfoScreen()),
    );
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create Account',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Join Medecai to start managing your medications safely with AI',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),

            // Full Name
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                hintText: 'Enter your full name',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            const SizedBox(height: 16),

            // Email
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            // Password
            TextField(
              controller: passwordController,
              obscureText: obscurePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                suffixIcon: IconButton(
                  icon: Icon(obscurePassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => obscurePassword = !obscurePassword),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Confirm Password
            TextField(
              controller: confirmPasswordController,
              obscureText: obscureConfirmPassword,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                hintText: 'Confirm your password',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                suffixIcon: IconButton(
                  icon: Icon(obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => obscureConfirmPassword = !obscureConfirmPassword),
                ),
              ),
            ),
            const Spacer(),
            const Divider(),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _handleSignUp,
                child: const Text(
                  'Create Account',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Already have an account? Sign In',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}