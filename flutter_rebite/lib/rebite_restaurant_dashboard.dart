
import 'package:flutter/material.dart';

// ============================================================
// WARNA REBITE
// ============================================================

const Color _rDarkBrown = Color(0xFF2E2910);
const Color _rBrunswick = Color(0xFF2C5745);
const Color _rVanilla = Color(0xFFEBE3A7);
const Color _rVanillaSoft = Color(0xFFFAF7E8);
const Color _rTangerine = Color(0xFFEB7D00);
const Color _rBackground = Color(0xFFF7F5EB);
const Color _rWhite = Color(0xFFFFFFFF);
const Color _rMuted = Color(0xFF736E58);
const Color _rBorder = Color(0xFFD1C9A0);
const Color _rGreenStatus = Color(0xFF16A34A);
const Color _rRed = Color(0xFFDC2626);

// ============================================================
// DASHBOARD RESTO
// ============================================================

class RebiteRestaurantDashboard extends StatefulWidget {
  const RebiteRestaurantDashboard({
    super.key,
    this.onPostSurplus,
    this.onOpenProfile,
    this.onOpenSidejob,
    this.onOpenHistory,
  });

  // Callback untuk halaman yang akan dihubungkan nanti.
  final VoidCallback? onPostSurplus;
  final VoidCallback? onOpenProfile;
  final VoidCallback? onOpenSidejob;
  final VoidCallback? onOpenHistory;

  @override
  State<RebiteRestaurantDashboard> createState() =>
      _RebiteRestaurantDashboardState();
}

class _RebiteRestaurantDashboardState
    extends State<RebiteRestaurantDashboard> {
  bool _isStoreOpen = true;
  bool _isFirstPostClosed = false;
  bool _isPetPostCompleted = false;

  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  // ==========================================================
  // NOTIFIKASI
  // ==========================================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _rBrunswick,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openFeature(VoidCallback? action, String featureName) {
    if (action != null) {
      action();
    } else {
      _showMessage(
        'Halaman $featureName belum dihubungkan. '
        'Nanti kita sambungkan melalui main.dart.',
      );
    }
  }

  void _openPostSurplus() {
    _openFeature(widget.onPostSurplus, 'Post Surplus');
  }

  // ==========================================================
  // STATUS TOKO
  // ==========================================================

  void _toggleStoreStatus() {
    setState(() {
      _isStoreOpen = !_isStoreOpen;
    });

    _showMessage(
      _isStoreOpen
          ? 'Toko sekarang Buka dan menerima surplus.'
          : 'Toko sekarang Tutup dan tidak menerima surplus.',
    );
  }

  // ==========================================================
  // POSTINGAN
  // ==========================================================

  void _toggleFirstPost() {
    setState(() {
      _isFirstPostClosed = !_isFirstPostClosed;
    });

    _showMessage(
      _isFirstPostClosed
          ? 'Postingan ditutup sementara.'
          : 'Postingan dibuka kembali.',
    );
  }

  void _togglePetPost() {
    setState(() {
      _isPetPostCompleted = !_isPetPostCompleted;
    });

    _showMessage(
      _isPetPostCompleted
          ? 'Postingan pakan ternak selesai.'
          : 'Postingan pakan ternak diaktifkan kembali.',
    );
  }

  // ==========================================================
  // QR SCANNER (SIMULASI FRONT-END)
  // ==========================================================

  void _openScanner() {
    _codeController.clear();

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: _rWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: _rBorder),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Scan QR Tiket Claimer',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: _rDarkBrown,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                        },
                        icon: const Icon(
                          Icons.close,
                          color: _rMuted,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  const Text(
                    'Pindai QR code pada ponsel Claimer '
                    'atau masukkan kode secara manual.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: _rMuted,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Tampilan kamera simulasi.
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _rTangerine,
                        width: 2,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(
                          Icons.qr_code_scanner,
                          size: 90,
                          color: Color(0x66EBE3A7),
                        ),
                        Positioned(
                          left: 15,
                          right: 15,
                          top: 20,
                          child: Container(
                            height: 2,
                            color: _rTangerine,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  TextField(
                    controller: _codeController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      hintText: 'REBITE-8829-MEDAN',
                      hintStyle: const TextStyle(
                        fontSize: 12,
                        color: _rMuted,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: _rBorder,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: _rBrunswick,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final code = _codeController.text.trim().isEmpty
                            ? 'REBITE-8829-MEDAN'
                            : _codeController.text.trim().toUpperCase();

                        Navigator.pop(dialogContext);

                        _showMessage(
                          'Verifikasi berhasil! '
                          'Kode: $code. '
                          'Status: 1 porsi valid untuk diambil.',
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _rBrunswick,
                        foregroundColor: _rVanilla,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Verifikasi',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ==========================================================
  // HEADER
  // ==========================================================


Widget _buildHeader() {
  return Container(
    color: _rBrunswick,
    padding: const EdgeInsets.symmetric(
      horizontal: 18,
      vertical: 15,
    ),
    child: Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: _rVanilla,
            shape: BoxShape.circle,
            border: Border.all(
              color: _rTangerine,
              width: 2,
            ),
          ),
          alignment: Alignment.center,
          child: const Text(
            'R',
            style: TextStyle(
              color: _rBrunswick,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: InkWell(
            onTap: () {
              _openFeature(widget.onOpenProfile, 'Profil Restoran');
            },
            borderRadius: BorderRadius.circular(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: _rTangerine.withValues(alpha: 0.20),
                    border: Border.all(
                      color: _rTangerine,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.storefront_outlined,
                          size: 11,
                          color: _rVanilla,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'MITRA RESTORAN',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: _rVanilla,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                const Text(
                  'Nama Restoran',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: _rWhite,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 8),

        InkWell(
          onTap: _toggleStoreStatus,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: _rWhite.withValues(alpha: 0.12),
              border: Border.all(
                color: _rVanilla.withValues(alpha: 0.4),
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _isStoreOpen ? _rGreenStatus : _rRed,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  _isStoreOpen ? 'TOKO BUKA' : 'TOKO TUTUP',
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: _rWhite,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
  // ==========================================================
  // STATISTIK
  // ==========================================================

  Widget _buildStatistics() {
    return Row(
      children: const [
        Expanded(
          child: _RestaurantStatCard(
            icon: Icons.volunteer_activism_outlined,
            value: '142',
            label: 'Porsi Terselamatkan',
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _RestaurantStatCard(
            icon: Icons.work_outline,
            value: '18',
            label: 'Misi Sidejob Homeless',
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _RestaurantStatCard(
            icon: Icons.add_circle_outline,
            value: '5',
            label: 'Sisa Kuota Post Hari Ini',
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // TOMBOL CEPAT
  // ==========================================================

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _QuickActionButton(
            icon: Icons.add,
            label: 'Post Surplus Baru',
            backgroundColor: _rTangerine,
            foregroundColor: _rWhite,
            onTap: _openPostSurplus,
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: _QuickActionButton(
            icon: Icons.qr_code_scanner,
            label: 'Scan QR Claimer',
            backgroundColor: _rBrunswick,
            foregroundColor: _rVanilla,
            onTap: _openScanner,
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // JUDUL SECTION
  // ==========================================================

  Widget _buildSectionHeader() {
    return Row(
      children: [
        const Icon(
          Icons.description_outlined,
          size: 19,
          color: _rTangerine,
        ),
        const SizedBox(width: 7),
        const Expanded(
          child: Text(
            'Postingan Surplus Aktif',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: _rDarkBrown,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 9,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: _rVanilla,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            '3 Post Aktif',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: _rBrunswick,
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // POSTINGAN 1: FREE FOOD
  // ==========================================================

  Widget _buildFirstPost() {
    return _RestaurantPostCard(
      tag: 'FREE FOOD / DEEP DISCOUNT',
      tagBackground: _rTangerine.withValues(alpha: 0.12),
      tagForeground: _rTangerine,
      tagBorder: _rTangerine.withValues(alpha: 0.3),
      time: '16:30 - 18:00 WIB',
      title: 'Paket Nasi & Lauk Surplus Harian',
      extra: _isFirstPostClosed
          ? Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: _rRed.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Postingan ditutup sementara.',
                style: TextStyle(
                  color: _rRed,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          : _buildProgressBox(),
      actions: [
        _PostActionButton(
          label: 'Edit Kuota',
          primary: false,
          onTap: _openPostSurplus,
        ),
        _PostActionButton(
          label: _isFirstPostClosed ? 'Buka Post' : 'Tutup Post',
          primary: true,
          onTap: _toggleFirstPost,
        ),
      ],
    );
  }

  Widget _buildProgressBox() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _rVanillaSoft,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Expanded(
                child: Text(
                  'Status Klaim Kuota',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: _rDarkBrown,
                  ),
                ),
              ),
              Text(
                '12 / 15 Porsi Terklaim',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: _rBrunswick,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const LinearProgressIndicator(
              value: 0.8,
              minHeight: 7,
              backgroundColor: _rBorder,
              color: _rBrunswick,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // POSTINGAN 2: DONASI HOMELESS
  // ==========================================================

  Widget _buildSecondPost() {
    return _RestaurantPostCard(
      tag: 'DONASI HOMELESS + SIDEJOB',
      tagBackground: _rBrunswick.withValues(alpha: 0.12),
      tagForeground: _rBrunswick,
      tagBorder: _rBrunswick.withValues(alpha: 0.3),
      time: '19:00 WIB',
      title: '20 Box Makanan Siap Saji Donasi',
      details: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.location_on_outlined,
            size: 16,
            color: _rTangerine,
          ),
          SizedBox(width: 6),
          Expanded(
            child: Text(
              'Target: Titik Panti & Tunawisma Medan Kota',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: _rMuted,
              ),
            ),
          ),
        ],
      ),
      extra: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color: _rBrunswick.withValues(alpha: 0.08),
          border: Border.all(
            color: _rBrunswick.withValues(alpha: 0.2),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.local_shipping_outlined,
              size: 17,
              color: _rBrunswick,
            ),
            const SizedBox(width: 6),
            const Expanded(
              child: Text(
                'Kurir Bertugas (Driver #R-402)',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: _rBrunswick,
                ),
              ),
            ),
            Text(
              'Pickup',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: _rTangerine,
              ),
            ),
          ],
        ),
      ),
      actions: [
        _PostActionButton(
          label: 'Lacak Kurir',
          primary: false,
          onTap: () {
            _showMessage('Membuka informasi pelacakan kurir...');
          },
        ),
        _PostActionButton(
          label: 'Detail Misi',
          primary: true,
          onTap: () {
            _openFeature(widget.onOpenSidejob, 'Sidejob');
          },
        ),
      ],
    );
  }

  // ==========================================================
  // POSTINGAN 3: PAKAN TERNAK
  // ==========================================================

  Widget _buildThirdPost() {
    return _RestaurantPostCard(
      tag: 'PAKAN TERNAK',
      tagBackground: _rVanilla,
      tagForeground: _rDarkBrown,
      tagBorder: _rBorder,
      time: 'Self-Pickup',
      title: 'Sisa Sayuran & Kulit Buah Bersih',
      details: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.inventory_2_outlined,
            size: 16,
            color: _rTangerine,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              _isPetPostCompleted
                  ? 'Status: Postingan selesai.'
                  : 'Stok Tersedia: 15 Kg '
                      '(Diambil Peternak Langsung)',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: _rMuted,
              ),
            ),
          ),
        ],
      ),
      actions: [
        _PostActionButton(
          label: 'Update Stok',
          primary: false,
          onTap: _openPostSurplus,
        ),
        _PostActionButton(
          label: _isPetPostCompleted ? 'Aktifkan' : 'Selesai',
          primary: true,
          onTap: _togglePetPost,
        ),
      ],
    );
  }

  // ==========================================================
  // NAVIGASI BAWAH
  // ==========================================================

  void _onNavigationTap(int index) {
    switch (index) {
      case 0:
        break;
      case 1:
        _openFeature(widget.onPostSurplus, 'Post Surplus');
        break;
      case 2:
        _openFeature(widget.onOpenSidejob, 'Sidejob');
        break;
      case 3:
        _openFeature(widget.onOpenHistory, 'Riwayat');
        break;
      case 4:
        _openFeature(widget.onOpenProfile, 'Profil Restoran');
        break;
    }
  }

  Widget _buildBottomNavigation() {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: _rWhite,
        border: Border(
          top: BorderSide(
            color: _rBorder,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _RestaurantNavItem(
              icon: Icons.dashboard_outlined,
              label: 'Dashboard',
              active: true,
              onTap: () => _onNavigationTap(0),
            ),
          ),
          Expanded(
            child: _RestaurantNavItem(
              icon: Icons.add_circle_outline,
              label: 'Post Surplus',
              onTap: () => _onNavigationTap(1),
            ),
          ),
          Expanded(
            child: _RestaurantNavItem(
              icon: Icons.work_outline,
              label: 'Sidejob',
              onTap: () => _onNavigationTap(2),
            ),
          ),
          Expanded(
            child: _RestaurantNavItem(
              icon: Icons.history,
              label: 'Riwayat',
              onTap: () => _onNavigationTap(3),
            ),
          ),
          Expanded(
            child: _RestaurantNavItem(
              icon: Icons.person_outline,
              label: 'Profil',
              onTap: () => _onNavigationTap(4),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // BUILD UTAMA
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _rBackground,
      body: SafeArea(
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final bool isDesktop = constraints.maxWidth > 440;
              final double dashboardWidth =
                  isDesktop ? 440 : constraints.maxWidth;
              final double cornerRadius = isDesktop ? 28 : 0;

              return Container(
                width: dashboardWidth,
                height: constraints.maxHeight,
                decoration: BoxDecoration(
                  color: _rBackground,
                  borderRadius: BorderRadius.circular(cornerRadius),
                  border: isDesktop
                      ? Border.all(color: _rBorder)
                      : null,
                  boxShadow: isDesktop
                      ? [
                          BoxShadow(
                            color: _rDarkBrown.withValues(alpha: 0.10),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ]
                      : [],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(cornerRadius),
                  child: Column(
                    children: [
                      _buildHeader(),

                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.fromLTRB(
                            16,
                            14,
                            16,
                            20,
                          ),
                          children: [
                            _buildStatistics(),
                            const SizedBox(height: 14),

                            _buildQuickActions(),
                            const SizedBox(height: 20),

                            _buildSectionHeader(),
                            const SizedBox(height: 12),

                            _buildFirstPost(),
                            const SizedBox(height: 12),

                            _buildSecondPost(),
                            const SizedBox(height: 12),

                            _buildThirdPost(),
                          ],
                        ),
                      ),

                      _buildBottomNavigation(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ============================================================
// KOMPONEN KARTU STATISTIK
// ============================================================

class _RestaurantStatCard extends StatelessWidget {
  const _RestaurantStatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 116),
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: _rWhite,
        border: Border.all(color: _rBorder),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _rDarkBrown.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: _rVanillaSoft,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(
              icon,
              color: _rBrunswick,
              size: 17,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: _rDarkBrown,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: _rMuted,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// KOMPONEN TOMBOL CEPAT
// ============================================================

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        elevation: 2,
        padding: const EdgeInsets.symmetric(
          horizontal: 7,
          vertical: 13,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 17),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// KOMPONEN KARTU POSTINGAN
// ============================================================

class _RestaurantPostCard extends StatelessWidget {
  const _RestaurantPostCard({
    required this.tag,
    required this.tagBackground,
    required this.tagForeground,
    required this.tagBorder,
    required this.time,
    required this.title,
    required this.actions,
    this.details,
    this.extra,
  });

  final String tag;
  final Color tagBackground;
  final Color tagForeground;
  final Color tagBorder;
  final String time;
  final String title;
  final Widget? details;
  final Widget? extra;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _rWhite,
        border: Border.all(color: _rBorder),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _rDarkBrown.withValues(alpha: 0.05),
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
            runSpacing: 7,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: tagBackground,
                  border: Border.all(color: tagBorder),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: tagForeground,
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 13,
                    color: _rMuted,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: _rMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: _rDarkBrown,
              height: 1.3,
            ),
          ),

          if (details != null) ...[
            const SizedBox(height: 10),
            details!,
          ],

          if (extra != null) ...[
            const SizedBox(height: 10),
            extra!,
          ],

          const SizedBox(height: 12),

          Row(
            children: [
              for (int i = 0; i < actions.length; i++) ...[
                if (i > 0) const SizedBox(width: 8),
                Expanded(child: actions[i]),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================
// KOMPONEN TOMBOL DI KARTU POSTINGAN
// ============================================================

class _PostActionButton extends StatelessWidget {
  const _PostActionButton({
    required this.label,
    required this.primary,
    required this.onTap,
  });

  final String label;
  final bool primary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: primary ? _rBrunswick : _rBackground,
          foregroundColor: primary ? _rVanilla : _rDarkBrown,
          side: primary ? null : const BorderSide(color: _rBorder),
          padding: const EdgeInsets.symmetric(horizontal: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// KOMPONEN NAVIGASI BAWAH
// ============================================================

class _RestaurantNavItem extends StatelessWidget {
  const _RestaurantNavItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.active = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final Color itemColor = active ? _rTangerine : _rMuted;

    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 21,
              color: itemColor,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: itemColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
