// File: lib/sidejob_missions.dart
// Halaman Misi Sidejob & Delivery — Front-End only.
// Responsif: mobile (<900px) single column, web/desktop (>=900px) dua kolom.

import 'package:flutter/material.dart';

import 'claim_history.dart';
import 'rebite_claimer_dashboard_map.dart';
import 'rebite_claimer_profile.dart';
import 'sidejob_register.dart';

// ============================================================
// 1. PALET WARNA
// ============================================================
const Color _kDarkBrown = Color(0xFF2E2910);
const Color _kBrunswick = Color(0xFF2C5745);
const Color _kVanilla = Color(0xFFEBE3A7);
const Color _kTangerine = Color(0xFFEB7D00);
const Color _kBgLight = Color(0xFFF7F5EB);
const Color _kMuted = Color(0xFF736E58);
const Color _kBorder = Color(0xFFD1C9A0);

// ============================================================
// 2. MODEL DATA
// ============================================================
class _RouteStep {
  final String label;
  final String name;
  final String address;
  final bool isDestination;
  const _RouteStep({
    required this.label,
    required this.name,
    required this.address,
    this.isDestination = false,
  });
}

class _Mission {
  final String typeBadge;
  final String rewardLabel;
  final IconData rewardIcon;
  final List<_RouteStep> steps;
  final String packages;
  final String distance;
  final String buttonLabel;
  final IconData buttonIcon;
  final String modalPickup;
  final String modalDropoff;
  final String modalReward;

  const _Mission({
    required this.typeBadge,
    required this.rewardLabel,
    required this.rewardIcon,
    required this.steps,
    required this.packages,
    required this.distance,
    required this.buttonLabel,
    required this.buttonIcon,
    required this.modalPickup,
    required this.modalDropoff,
    required this.modalReward,
  });
}

const List<_Mission> _missions = [
  _Mission(
    typeBadge: 'Antar Makanan Homeless',
    rewardLabel: 'Voucher Diskon 50%',
    rewardIcon: Icons.check_circle_outline,
    steps: [
      _RouteStep(
        label: 'Jemput (Restoran)',
        name: 'Restoran Sederhana',
        address: 'Jl. Gajah Mada No. 12',
      ),
      _RouteStep(
        label: 'Antar (Titik Homeless)',
        name: 'Posko Peduli Sesama',
        address: 'Jl. Pemuda No. 4 (Komunitas)',
        isDestination: true,
      ),
    ],
    packages: '15 Porsi Nasi Bungkus',
    distance: '1.8 km (Estimasi 12 min)',
    buttonLabel: 'Ambil Misi Delivery',
    buttonIcon: Icons.local_shipping_outlined,
    modalPickup: 'Restoran Sederhana',
    modalDropoff: 'Posko Peduli Sesama',
    modalReward: 'Voucher Diskon 50% + 150 Poin',
  ),
  _Mission(
    typeBadge: 'Pakan Ternak (Self-Pickup)',
    rewardLabel: '80 Poin Rebite',
    rewardIcon: Icons.star_border,
    steps: [
      _RouteStep(
        label: 'Ambil Langsung',
        name: 'Mitra Tani Organik',
        address: 'Jl. Sudirman No. 88',
      ),
    ],
    packages: '25 kg Sisa Sayur Ternak',
    distance: '2.4 km',
    buttonLabel: 'Ambil Misi Pakan',
    buttonIcon: Icons.location_on_outlined,
    modalPickup: 'Mitra Tani Organik',
    modalDropoff: 'Kandang Peternak Mandiri',
    modalReward: '80 Poin Rebite',
  ),
];

// ============================================================
// 3. WIDGET UTAMA
// ============================================================
class SidejobMissions extends StatefulWidget {
  const SidejobMissions({super.key});

  @override
  State<SidejobMissions> createState() => _SidejobMissionsState();
}

class _SidejobMissionsState extends State<SidejobMissions> {
  /// 0 = Misi Tersedia, 1 = Dalam Proses, 2 = Selesai.
  int _selectedTab = 0;

  void _push(Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  /// Setara openMissionModal() + closeMissionModal() di HTML:
  /// dialog konfirmasi → alert sukses.
  Future<void> _openMissionModal(_Mission mission) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierColor: const Color(0xA62E2910), // dark brown 65%
      builder: (ctx) => Dialog(
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: _kBorder),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Konfirmasi Ambil Misi',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: _kDarkBrown,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Anda berjanji mengambil dan mengantarkan makanan tepat waktu.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.5, color: _kMuted),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _kBgLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _kBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jemput: ${mission.modalPickup}',
                        style: const TextStyle(
                          fontSize: 12.8,
                          fontWeight: FontWeight.w800,
                          color: _kBrunswick,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Antar: ${mission.modalDropoff}',
                        style: const TextStyle(
                          fontSize: 12.8,
                          fontWeight: FontWeight.w800,
                          color: _kTangerine,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Reward: ${mission.modalReward}',
                        style: const TextStyle(
                          fontSize: 12.8,
                          fontWeight: FontWeight.w700,
                          color: _kDarkBrown,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => Navigator.of(ctx).pop(true),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _kTangerine,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Text(
                      'Mulai Pengantaran Sekarang',
                      style: TextStyle(
                        fontSize: 14.4,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (confirmed == true && mounted) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          content: const Text(
            'Misi berhasil diambil! Silakan menuju lokasi penjemputan.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBgLight,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isWide = constraints.maxWidth >= 900;
            return Column(
              children: [
                _buildHeader(),
                _buildTabsBar(),
                Expanded(
                  child: _selectedTab != 0
                      ? _buildEmptyState()
                      : (isWide ? _buildWideContent() : _buildMobileContent()),
                ),
                _buildBottomNav(),
              ],
            );
          },
        ),
      ),
    );
  }

  // ==========================================================
  // HEADER
  // ==========================================================
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
      color: _kBrunswick,
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MITRA KURIR / CLAIMER',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _kVanilla,
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Misi Sidejob Delivery',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0x26EBE3A7),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _kVanilla),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star, size: 16, color: _kTangerine),
                SizedBox(width: 6),
                Text(
                  '350 Poin',
                  style: TextStyle(
                    fontSize: 13.1,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // TABS
  // ==========================================================
  Widget _buildTabsBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(child: _buildTabButton(0, 'Misi Tersedia (3)')),
          const SizedBox(width: 8),
          Expanded(child: _buildTabButton(1, 'Dalam Proses (1)')),
          const SizedBox(width: 8),
          Expanded(child: _buildTabButton(2, 'Selesai')),
        ],
      ),
    );
  }

  Widget _buildTabButton(int index, String label) {
    final bool active = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? _kVanilla : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: active ? _kDarkBrown : _kMuted,
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // KONTEN MOBILE / WIDE
  // ==========================================================
  Widget _buildMobileContent() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildRegisterBanner(),
            const SizedBox(height: 14),
            ..._missions.map(
              (m) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _buildMissionCard(m),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWideContent() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildRegisterBanner(),
            const SizedBox(height: 14),
            LayoutBuilder(
              builder: (ctx, c) {
                // 2 kolom bila cukup lebar, 1 kolom bila sempit.
                final int columns = c.maxWidth >= 720 ? 2 : 1;
                final double gap = 14;
                final double cardWidth =
                    (c.maxWidth - gap * (columns - 1)) / columns;
                return Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children: _missions
                      .map(
                        (m) => SizedBox(
                          width: cardWidth,
                          child: _buildMissionCard(m),
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: _kMuted.withOpacity(0.5),
            ),
            const SizedBox(height: 12),
            Text(
              _selectedTab == 1
                  ? 'Belum ada misi dalam proses'
                  : 'Belum ada misi selesai',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _kMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // BANNER REGISTRASI → SidejobRegister
  // ==========================================================
  Widget _buildRegisterBanner() {
    return GestureDetector(
      onTap: () => _push(const SidejobRegister()),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: _kVanilla,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _kBorder),
        ),
        child: Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Belum Terdaftar Kurir Relawan?',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: _kDarkBrown,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Verifikasi akun untuk mengaktifkan pengantaran',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _kMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _kBrunswick,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Daftar Kurir',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  color: _kVanilla,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // KARTU MISI
  // ==========================================================
  Widget _buildMissionCard(_Mission mission) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _kBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D2E2910),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Baris atas: badge tipe + badge reward ---
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _kVanilla,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      mission.typeBadge.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: _kDarkBrown,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0x1FEB7D00),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(mission.rewardIcon, size: 14, color: _kTangerine),
                    const SizedBox(width: 4),
                    Text(
                      mission.rewardLabel,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        color: _kTangerine,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // --- Route steps ---
          _buildRoute(mission.steps),
          const SizedBox(height: 12),

          // --- Meta (jumlah & jarak) ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _kBgLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.inventory_2_outlined,
                    size: 14, color: _kDarkBrown),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    mission.packages,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: _kDarkBrown,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.location_on_outlined,
                    size: 14, color: _kDarkBrown),
                const SizedBox(width: 4),
                Text(
                  mission.distance,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: _kDarkBrown,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // --- Tombol aksi ---
          GestureDetector(
            onTap: () => _openMissionModal(mission),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: _kBrunswick,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(mission.buttonIcon, size: 18, color: _kVanilla),
                  const SizedBox(width: 8),
                  Text(
                    mission.buttonLabel,
                    style: const TextStyle(
                      fontSize: 13.6,
                      fontWeight: FontWeight.w800,
                      color: _kVanilla,
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

  // ------------------------------------------------------------
  // ROUTE VISUAL: dot → garis penghubung → dot
  // ------------------------------------------------------------
  Widget _buildRoute(List<_RouteStep> steps) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < steps.length; i++) ...[
          _buildStepRow(steps[i]),
          if (i < steps.length - 1) _buildConnectorRow(),
        ],
      ],
    );
  }

  Widget _buildStepRow(_RouteStep step) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 16,
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: step.isDestination ? _kTangerine : _kBrunswick,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step.label.toUpperCase(),
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: _kMuted,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                step.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: _kDarkBrown,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                step.address,
                style: const TextStyle(
                  fontSize: 12,
                  color: _kMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConnectorRow() {
    return Row(
      children: [
        SizedBox(
          width: 16,
          child: Center(
            child: Container(
              width: 2,
              height: 12,
              color: _kBorder,
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // BOTTOM NAV
  // ==========================================================
  Widget _buildBottomNav() {
    return Container(
      height: 65,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _kBorder)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(
                icon: Icons.map_outlined,
                label: 'Peta Food',
                active: false,
                onTap: () => _push(const RebiteClaimerDashboardMap()),
              ),
              _navItem(
                icon: Icons.work_outline,
                label: 'Sidejob',
                active: true,
              ),
              _navItem(
                icon: Icons.history,
                label: 'Riwayat',
                active: false,
                onTap: () => _push(const ClaimHistory()),
              ),
              _navItem(
                icon: Icons.person_outline,
                label: 'Profil',
                active: false,
                onTap: () => _push(const RebiteClaimerProfile()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    required bool active,
    VoidCallback? onTap,
  }) {
    final color = active ? _kTangerine : _kMuted;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}