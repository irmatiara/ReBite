// File: lib/claim_history.dart
// Halaman Riwayat Klaim & Tiket QR — Front-End only.
// Responsif: mobile (<900px) single column dengan tab filter,
// desktop (>=900px) dua panel (tiket aktif kiri, riwayat kanan).

import 'package:flutter/material.dart';

import 'food_detail.dart';
import 'rebite_claimer_dashboard_map.dart';
import 'rebite_claimer_profile.dart';
import 'sidejob_missions.dart';

// ============================================================
// 1. PALET WARNA (private, tidak konflik dengan file lain)
// ============================================================
const Color _kDarkBrown = Color(0xFF2E2910);
const Color _kBrunswick = Color(0xFF2C5745);
const Color _kVanilla = Color(0xFFEBE3A7);
const Color _kTangerine = Color(0xFFEB7D00);
const Color _kBgLight = Color(0xFFF7F5EB);
const Color _kMuted = Color(0xFF736E58);
const Color _kBorder = Color(0xFFD1C9A0);
const Color _kRed = Color(0xFFDC2626);
const Color _kGreen = Color(0xFF16A34A);

// ============================================================
// 2. WIDGET
// ============================================================
class ClaimHistory extends StatefulWidget {
  const ClaimHistory({super.key});

  @override
  State<ClaimHistory> createState() => _ClaimHistoryState();
}

class _ClaimHistoryState extends State<ClaimHistory> {
  /// 0 = Tiket Aktif, 1 = Riwayat Selesai (hanya dipakai di mobile).
  int _selectedTab = 0;

  // ------------------------------------------------------------
  // Navigasi & dialog
  // ------------------------------------------------------------
  void _push(Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  /// Setara cancelClaim() di HTML: confirm → alert.
  Future<void> _confirmCancelClaim() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Batalkan Klaim?'),
        content: const Text(
          'Apakah Anda yakin ingin membatalkan klaim ini? '
          'Kuota harian Anda akan dikembalikan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Ya, Batalkan'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          content: const Text(
            'Klaim berhasil dibatalkan. Limit klaim Anda telah diperbarui.',
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
                if (!isWide) _buildTabsBar(),
                Expanded(
                  child: isWide ? _buildWideLayout() : _buildMobileLayout(),
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
                  'FITUR VERIFIKASI',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _kVanilla,
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Tiket & Riwayat Klaim',
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
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'SISA LIMIT',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: _kVanilla,
                  ),
                ),
                Text(
                  '2 / 3 Hari Ini',
                  style: TextStyle(
                    fontSize: 13.6,
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
  // TABS (hanya mobile)
  // ==========================================================
  Widget _buildTabsBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(child: _buildTabButton(index: 0, label: 'Tiket Aktif (1)')),
          const SizedBox(width: 8),
          Expanded(
            child: _buildTabButton(
              index: 1,
              label: 'Riwayat Selesai (2)',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({required int index, required String label}) {
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
  // LAYOUT MOBILE
  // ==========================================================
  Widget _buildMobileLayout() {
    final bool isShort = MediaQuery.of(context).size.height < 700;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: ListView(
          padding: EdgeInsets.fromLTRB(16, isShort ? 10 : 16, 16, 16),
          children: _selectedTab == 0
              ? _buildTicketContent()
              : _buildHistoryContent(),
        ),
      ),
    );
  }

  // ==========================================================
  // LAYOUT WIDE (dua panel)
  // ==========================================================
  Widget _buildWideLayout() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildTicketContent(),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildHistoryContent(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // KONTEN — TIKET AKTIF
  // ==========================================================
  List<Widget> _buildTicketContent() {
    return [
      _buildSectionLabel('Tiket Pengambilan Aktif'),
      const SizedBox(height: 10),
      _buildActiveTicketCard(),
    ];
  }

  Widget _buildActiveTicketCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _kTangerine, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1FEB7D00),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ----- Status + Timer -----
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0x1FEB7D00),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.access_time, size: 14, color: _kTangerine),
                    SizedBox(width: 6),
                    Text(
                      'Siap Diambil',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        color: _kTangerine,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.timer_outlined, size: 14, color: _kRed),
                  SizedBox(width: 4),
                  Text(
                    '34 : 12 Menit',
                    style: TextStyle(
                      fontSize: 12.8,
                      fontWeight: FontWeight.w800,
                      color: _kRed,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ----- QR + PIN -----
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _kBgLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _kBorder),
            ),
            child: const Column(
              children: [
                Icon(Icons.qr_code_2, size: 100, color: _kBrunswick),
                SizedBox(height: 8),
                Text(
                  'PIN: REBITE-CLAIM-882',
                  style: TextStyle(
                    fontSize: 13.6,
                    fontWeight: FontWeight.w800,
                    color: _kDarkBrown,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ----- Detail Resto (tap → FoodDetail) -----
          GestureDetector(
            onTap: () => _push(const FoodDetail(id: 1)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Restoran Sederhana Food Bank',
                  style: TextStyle(
                    fontSize: 15.2,
                    fontWeight: FontWeight.w800,
                    color: _kDarkBrown,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: const [
                    Icon(Icons.location_on_outlined,
                        size: 14, color: _kMuted),
                    SizedBox(width: 4),
                    Text(
                      'Jl. Gajah Mada No. 12 (0.4 km)',
                      style: TextStyle(fontSize: 12.5, color: _kMuted),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _kVanilla,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'KARBOHIDRAT & PROTEIN',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: _kDarkBrown,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ----- Batalkan Klaim -----
          GestureDetector(
            onTap: _confirmCancelClaim,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _kBorder),
              ),
              child: const Text(
                'Batalkan Klaim (Kembalikan Kuota)',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: _kMuted,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // KONTEN — RIWAYAT
  // ==========================================================
  List<Widget> _buildHistoryContent() {
    return [
      _buildSectionLabel('Riwayat Klaim Lampau'),
      const SizedBox(height: 10),
      _buildHistoryCard(
        resto: 'Bakery Aroma Rescue Spot',
        detail: '12 Oktober 2026 • Roti & Pastry',
        statusLabel: 'Selesai',
        statusColor: _kGreen,
        statusBg: const Color(0x1F16A34A),
      ),
      const SizedBox(height: 10),
      _buildHistoryCard(
        resto: 'Warung Berkah Suropati',
        detail: '10 Oktober 2026 • Makanan Siap Saji',
        statusLabel: 'Kadaluarsa',
        statusColor: _kRed,
        statusBg: const Color(0x1FDC2626),
      ),
    ];
  }

  Widget _buildHistoryCard({
    required String resto,
    required String detail,
    required String statusLabel,
    required Color statusColor,
    required Color statusBg,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _kBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  resto,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: _kDarkBrown,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  detail,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: _kMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusBg,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              statusLabel,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // HELPER — SECTION LABEL
  // ==========================================================
  Widget _buildSectionLabel(String text) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        color: _kMuted,
        letterSpacing: 0.5,
      ),
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
                active: false,
                onTap: () => _push(const SidejobMissions()),
              ),
              _navItem(
                icon: Icons.history,
                label: 'Riwayat',
                active: true,
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