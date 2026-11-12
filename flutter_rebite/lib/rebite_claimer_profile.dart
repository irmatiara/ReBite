import 'rebite_route_tracker.dart';
import 'session_storage.dart';

import 'package:flutter/material.dart';

import 'claim_history.dart';
import 'rebite_claimer_dashboard_map.dart';
import 'sidejob_missions.dart';
import 'sidejob_register.dart';

class RebiteClaimerProfile extends StatelessWidget {
  const RebiteClaimerProfile({super.key});

  // ============================================================
  // NAVIGASI
  // ============================================================

  void _openPage(BuildContext context, Widget page) {
    RebiteRouteTracker.push(context, page);
  }

  // ============================================================
  // DIALOG INFORMASI
  // ============================================================

  void _showInfoDialog(
    BuildContext context,
    String title,
    String message,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        icon: const Icon(
          Icons.info_outline,
          size: 38,
          color: kBrunswick,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: kDarkBrown,
          ),
        ),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            height: 1.5,
            color: kMuted,
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kBrunswick,
              foregroundColor: kVanilla,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // VOUCHER
  // ============================================================

  void _showVoucherDialog(BuildContext context) {
    _showInfoDialog(
      context,
      'Voucher Saya',
      'Anda memiliki 3 Voucher Diskon Kurir Sidejob aktif:\n\n'
          '1. Diskon 50% Makanan (Misi #R-102)\n'
          '2. Diskon 30% Makanan (Misi #R-108)\n'
          '3. Potongan Rp15.000 (Bonus Eco-Rescuer)',
    );
  }

  // ============================================================
  // KEBIJAKAN ANONIMITAS
  // ============================================================

  void _showAnonymityDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        icon: const Icon(
          Icons.lock_outline,
          size: 38,
          color: kBrunswick,
        ),
        title: const Text(
          'Anonimitas Makanan',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: kDarkBrown,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Prinsip ReBite dalam menjaga martabat Claimer '
              'dan mencegah komersialisasi berlebih:',
              style: TextStyle(
                fontSize: 12,
                height: 1.5,
                color: kMuted,
              ),
            ),
            const SizedBox(height: 14),
            _policyItem(
              'Label makanan ditampilkan berdasarkan kategori '
              'gizi umum, seperti Karbohidrat dan Protein.',
            ),
            _policyItem(
              'Nama spesifik menu dirahasiakan hingga saat '
              'pengambilan di lokasi mitra.',
            ),
            _policyItem(
              'Setiap Claimer diperlakukan setara tanpa stigma '
              'latar belakang sosial.',
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kBrunswick,
              foregroundColor: kVanilla,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Mengerti & Tutup'),
          ),
        ],
      ),
    );
  }

  Widget _policyItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle,
            color: kBrunswick,
            size: 17,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                height: 1.4,
                color: kDarkBrown,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Future<void> _showLogoutDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        icon: const Icon(
          Icons.logout,
          size: 38,
          color: kRedAlert,
        ),
        title: const Text(
          'Keluar dari Akun?',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: kDarkBrown,
          ),
        ),
        content: const Text(
          'Anda perlu masuk kembali untuk melakukan klaim '
          'surplus dan melihat QR tiket aktif Anda.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            height: 1.5,
            color: kMuted,
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text(
              'Batal',
              style: TextStyle(color: kMuted),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kRedAlert,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Ya, Keluar'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      // Kembali ke halaman onboarding dan reset kunci halaman.
      RebiteRouteTracker.clearLockedRoute();
      SessionStorage.removeItem('current_logged_user');
      Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.onboarding, (route) => false);
    }
  }

  // ============================================================
  // BUILD UTAMA
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 600,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        16, 16, 16, 24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildQuotaCard(),
                          const SizedBox(height: 16),

                          _buildStatistics(),
                          const SizedBox(height: 22),

                          _buildMenuSection(
                            'Akun & Kemitraan',
                            [
                              _ProfileMenuItem(
                                icon: Icons.person_outline,
                                title: 'Edit Profil',
                                onTap: () => _showInfoDialog(
                                  context,
                                  'Edit Profil',
                                  'Fitur pembaruan profil sedang '
                                      'disiapkan. Anda dapat mengganti '
                                      'nomor WhatsApp dan preferensi '
                                      'makanan Anda.',
                                ),
                              ),
                              _ProfileMenuItem(
                                icon: Icons.confirmation_num_outlined,
                                title: 'Voucher Saya',
                                badge: '3 Aktif',
                                onTap: () =>
                                    _showVoucherDialog(context),
                              ),
                              _ProfileMenuItem(
                                icon: Icons.local_shipping_outlined,
                                title: 'Registrasi Kurir Sidejob',
                                onTap: () => _openPage(
                                  context,
                                  SidejobRegister(),
                                ),
                              ),
                              _ProfileMenuItem(
                                icon: Icons.lock_outline,
                                title: 'Kebijakan Anonimitas Makanan',
                                onTap: () =>
                                    _showAnonymityDialog(context),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          _buildMenuSection(
                            'Layanan & Keamanan',
                            [
                              _ProfileMenuItem(
                                icon: Icons.help_outline,
                                title: 'Pusat Bantuan',
                                onTap: () => _showInfoDialog(
                                  context,
                                  'Pusat Bantuan',
                                  'Halaman pusat bantuan sedang '
                                      'disiapkan.',
                                ),
                              ),
                              _ProfileMenuItem(
                                icon: Icons.logout,
                                title: 'Keluar / Logout',
                                isLogout: true,
                                onTap: () =>
                                    _showLogoutDialog(context),
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

            _buildBottomNav(context),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER PROFIL
  // ============================================================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: kBrunswick,
        boxShadow: [
          BoxShadow(
            color: kBrunswick.withOpacity(0.18),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Profil Saya',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: kVanilla.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: kVanilla),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 13,
                            color: kVanilla,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'CLAIMER',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: kVanilla,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: kTangerine,
                          width: 2,
                        ),
                      ),
                      child: const CircleAvatar(
                        radius: 27,
                        backgroundColor: kVanilla,
                        child: Text(
                          'N',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: kBrunswick,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 14),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nama Pengguna',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'claimer.rebite@medan.id',
                            style: TextStyle(
                              fontSize: 11,
                              color: kVanilla,
                            ),
                          ),
                          SizedBox(height: 7),
                          _LevelBadge(),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // LEVEL BADGE
  // ============================================================

  // ============================================================
  // KUOTA KLAIM
  // ============================================================

  Widget _buildQuotaCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kBorder),
        boxShadow: [
          BoxShadow(
            color: kDarkBrown.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.access_time,
                    size: 17,
                    color: kTangerine,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Kuota Klaim Harian',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: kDarkBrown,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: kVanilla,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '2 / 3 Porsi Digunakan',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: kBrunswick,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Container(
            height: 9,
            decoration: BoxDecoration(
              color: kBgLight,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: kBorder),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: 2 / 3,
                heightFactor: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: kTangerine,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          const Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 8,
            runSpacing: 5,
            children: [
              Text.rich(
                TextSpan(
                  text: 'Sisa ',
                  children: [
                    TextSpan(
                      text: '1 porsi lagi',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: kBrunswick,
                      ),
                    ),
                    TextSpan(text: ' hari ini'),
                  ],
                ),
                style: TextStyle(
                  fontSize: 11,
                  color: kMuted,
                ),
              ),
              Text(
                'Reset Pukul 00:00 WIB',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: kBrunswick,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STATISTIK DAMPAK
  // ============================================================

  Widget _buildStatistics() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            Icons.savings_outlined,
            '28',
            'Makanan Diselamatkan',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatCard(
            Icons.star_outline,
            '350',
            'Poin Reward',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatCard(
            Icons.eco_outlined,
            '14.2 kg',
            'Jejak Karbon Dihemat',
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    IconData icon,
    String value,
    String label,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kBorder),
        boxShadow: [
          BoxShadow(
            color: kDarkBrown.withOpacity(0.04),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: kVanillaSoft,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: kBorder),
            ),
            child: Icon(
              icon,
              size: 17,
              color: kBrunswick,
            ),
          ),
          const SizedBox(height: 7),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: kDarkBrown,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 9,
              height: 1.3,
              fontWeight: FontWeight.w700,
              color: kMuted,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MENU SECTION
  // ============================================================

  Widget _buildMenuSection(
    String title,
    List<_ProfileMenuItem> items,
  ) {
    final List<Widget> menuChildren = [];

    for (int i = 0; i < items.length; i++) {
      menuChildren.add(_buildMenuItem(items[i]));

      if (i < items.length - 1) {
        menuChildren.add(
          const Divider(
            height: 1,
            thickness: 1,
            color: kBorder,
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
              color: kMuted,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: kBorder),
            boxShadow: [
              BoxShadow(
                color: kDarkBrown.withOpacity(0.03),
                blurRadius: 8,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Column(
              children: menuChildren,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(_ProfileMenuItem item) {
    final Color itemColor = item.isLogout ? kRedAlert : kBrunswick;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 13,
          ),
          child: Row(
            children: [
              Container(
                width: 29,
                height: 29,
                decoration: BoxDecoration(
                  color: item.isLogout
                      ? const Color(0x1ADC2626)
                      : kBgLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  item.icon,
                  size: 16,
                  color: itemColor,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: item.isLogout ? kRedAlert : kDarkBrown,
                  ),
                ),
              ),

              if (item.badge != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0x1FEB7D00),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    item.badge!,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: kTangerine,
                    ),
                  ),
                ),
                const SizedBox(width: 7),
              ],

              const Icon(
                Icons.chevron_right,
                size: 18,
                color: kMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // BOTTOM NAVIGATION
  // ============================================================

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: kBorder),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Row(
            children: [
              _buildNavItem(
                context,
                Icons.map_outlined,
                'Peta Food',
                false,
                () => _openPage(
                  context,
                  const RebiteClaimerDashboardMap(),
                ),
              ),
              _buildNavItem(
                context,
                Icons.work_outline,
                'Sidejob',
                false,
                () => _openPage(
                  context,
                  const SidejobMissions(),
                ),
              ),
              _buildNavItem(
                context,
                Icons.history,
                'Riwayat',
                false,
                () => _openPage(
                  context,
                  const ClaimHistory(),
                ),
              ),
              _buildNavItem(
                context,
                Icons.person_outline,
                'Profil',
                true,
                null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String label,
    bool active,
    VoidCallback? onTap,
  ) {
    final Color color = active ? kTangerine : kMuted;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 64,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: color,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// LEVEL BADGE
// ============================================================

class _LevelBadge extends StatelessWidget {
  const _LevelBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: kTangerine,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: kTangerine.withOpacity(0.25),
            blurRadius: 8,
          ),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star_outline,
            size: 13,
            color: Colors.white,
          ),
          SizedBox(width: 5),
          Text(
            'Eco-Rescuer',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// MODEL MENU PROFIL
// ============================================================

class _ProfileMenuItem {
  final IconData icon;
  final String title;
  final String? badge;
  final bool isLogout;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.badge,
    this.isLogout = false,
  });
}
