import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../services/auth_service.dart';
import '../../services/profile_service.dart';

/// Halaman login Electronic Store.
///
/// Tanggung jawab halaman ini:
/// - Menampilkan form email dan password.
/// - Melakukan validasi input.
/// - Mengirim credential ke Supabase Auth.
/// - Mengambil role user dari tabel profiles.
/// - Mengarahkan user ke halaman sesuai role.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controller untuk input email.
  final TextEditingController _emailController = TextEditingController();

  // Controller untuk input password.
  final TextEditingController _passwordController = TextEditingController();

  // Key untuk melakukan validasi form.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Menentukan apakah password sedang ditampilkan.
  bool _obscurePassword = true;

  // Status loading ketika proses login berjalan.
  bool _isLoading = false;

  // Pesan error yang ditampilkan kepada user.
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Proses login.
  Future<void> _login() async {
    // Hilangkan keyboard.
    FocusScope.of(context).unfocus();

    // Validasi form.
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // ==========================================================
      // 1. Login ke Supabase Auth
      // ==========================================================

      final response = await AuthService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Pastikan user berhasil dibuat session-nya.
      if (response.user == null) {
        throw Exception('Login gagal. User tidak ditemukan.');
      }

      // ==========================================================
      // 2. Ambil profile dari database
      // ==========================================================

      final profile = await ProfileService.getCurrentProfile();

      if (profile == null) {
        throw Exception('Profile user tidak ditemukan.');
      }

      if (!mounted) {
        return;
      }

      // ==========================================================
      // 3. Routing berdasarkan role
      // ==========================================================

      if (profile.isAdmin) {
        context.go('/admin');
      } else {
        context.go('/customer');
      }
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = _getErrorMessage(error);
      });
    } finally {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Mengubah error teknis menjadi pesan yang lebih mudah
  /// dipahami user.
  String _getErrorMessage(Object error) {
    final message = error.toString();

    if (message.contains('Invalid login credentials')) {
      return 'Email atau password salah.';
    }

    if (message.contains('Email not confirmed')) {
      return 'Email belum dikonfirmasi.';
    }

    if (message.contains('Network')) {
      return 'Tidak dapat terhubung ke server. Periksa koneksi internet.';
    }

    return 'Login gagal. Silakan coba lagi.';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ==================================================
                        // LOGO
                        // ==================================================
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.10,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            Icons.storefront_rounded,
                            size: 40,
                            color: theme.colorScheme.primary,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ==================================================
                        // TITLE
                        // ==================================================
                        Text(
                          'Electronic Store',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 8),

                        Text(
                          'Masuk ke akun Anda',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 28),

                        // ==================================================
                        // ERROR MESSAGE
                        // ==================================================
                        if (_errorMessage != null) ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.red.shade100),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.red.shade700,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _errorMessage!,
                                    style: TextStyle(
                                      color: Colors.red.shade700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // ==================================================
                        // EMAIL
                        // ==================================================
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          enabled: !_isLoading,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            hintText: 'contoh@email.com',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                          validator: (value) {
                            final email = value?.trim() ?? '';

                            if (email.isEmpty) {
                              return 'Email wajib diisi.';
                            }

                            final emailRegex = RegExp(
                              r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                            );

                            if (!emailRegex.hasMatch(email)) {
                              return 'Format email tidak valid.';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // ==================================================
                        // PASSWORD
                        // ==================================================
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          enabled: !_isLoading,
                          onFieldSubmitted: (_) {
                            if (!_isLoading) {
                              _login();
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Masukkan password',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              tooltip: _obscurePassword
                                  ? 'Tampilkan password'
                                  : 'Sembunyikan password',
                              onPressed: _isLoading
                                  ? null
                                  : () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),
                          validator: (value) {
                            final password = value ?? '';

                            if (password.isEmpty) {
                              return 'Password wajib diisi.';
                            }

                            if (password.length < 6) {
                              return 'Password minimal 6 karakter.';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 24),

                        // ==================================================
                        // LOGIN BUTTON
                        // ==================================================
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: FilledButton(
                            onPressed: _isLoading ? null : _login,
                            child: _isLoading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Login',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ==================================================
                        // REGISTER
                        // ==================================================
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Belum punya akun?',
                              style: theme.textTheme.bodyMedium,
                            ),
                            TextButton(
                              onPressed: _isLoading
                                  ? null
                                  : () {
                                      context.go('/register');
                                    },
                              child: const Text('Daftar'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
