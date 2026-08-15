import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/responsive.dart';
import '../../services/auth_service.dart';

/// Halaman utama customer.
///
/// Untuk saat ini halaman masih berupa foundation.
/// Fitur Produk, Keranjang, Pesanan, dan Profil
/// akan kita implementasikan pada milestone berikutnya.
class CustomerHomeScreen extends StatelessWidget {
  const CustomerHomeScreen({super.key});

  /// Proses logout customer.
  static Future<void> _logout(BuildContext context) async {
    try {
      // Logout dari Supabase Auth.
      await AuthService.logout();

      // Pastikan widget/context masih aktif.
      if (!context.mounted) {
        return;
      }

      // Kembali ke halaman login.
      context.go('/login');
    } catch (error) {
      if (!context.mounted) {
        return;
      }

      // Tampilkan pesan jika logout gagal.
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Logout gagal: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      // ============================================================
      // APP BAR
      // ============================================================
      appBar: AppBar(
        title: const Text('Electronic Store'),

        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
            onPressed: () {
              _logout(context);
            },
          ),
        ],
      ),

      // ============================================================
      // BODY
      // ============================================================
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==================================================
                // TITLE
                // ==================================================
                Text(
                  'Customer Home',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text('Foundation halaman customer berhasil dibuat.'),

                const SizedBox(height: 24),

                // ==================================================
                // FEATURE CARDS
                // ==================================================
                GridView.count(
                  crossAxisCount: isDesktop ? 4 : 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.3,
                  children: const [
                    _FeatureCard(
                      icon: Icons.inventory_2_outlined,
                      title: 'Produk',
                    ),
                    _FeatureCard(
                      icon: Icons.shopping_cart_outlined,
                      title: 'Keranjang',
                    ),
                    _FeatureCard(
                      icon: Icons.receipt_long_outlined,
                      title: 'Pesanan',
                    ),
                    _FeatureCard(icon: Icons.person_outline, title: 'Profil'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Card fitur sementara.
///
/// Fitur sebenarnya akan diimplementasikan
/// pada milestone berikutnya.
class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40),

            const SizedBox(height: 12),

            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
