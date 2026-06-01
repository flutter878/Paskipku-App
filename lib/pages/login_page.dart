import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthService authService = AuthService();

  bool isLoading = false;
  bool obscurePassword = true;

  Future<void> handleLogin() async {
  if (loginController.text.isEmpty || passwordController.text.isEmpty) {
    showMessage('NIK/Email dan password wajib diisi.');
    return;
  }

  setState(() {
    isLoading = true;
  });

  try {
    final response = await authService.login(
      login: loginController.text.trim(),
      password: passwordController.text.trim(),
    );

    if (!mounted) return;

    if (response['token'] != null) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      showMessage(response['message'] ?? 'Login gagal.');
    }
  } catch (e) {
    if (!mounted) return;
    showMessage('Terjadi kesalahan: $e');
  } finally {
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }
}

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    loginController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.flag,
                      size: 70,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Login Peserta',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Pendaftaran Paskibraka',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),

                    TextField(
                      controller: loginController,
                      decoration: const InputDecoration(
                        labelText: 'NIK / Email',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: passwordController,
                      obscureText: obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'Login',
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: const Text('Belum punya akun? Daftar di sini'),
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
}