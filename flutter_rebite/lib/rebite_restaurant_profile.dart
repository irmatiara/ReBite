import 'package:flutter/material.dart';

// ReBite Restaurant Profile
// Halaman profil restoran berdasarkan rebite_restaurant_profile.html.
// Seluruh data pada halaman ini masih berupa data contoh (front-end only).

const Color _rProfileDarkBrown = Color(0xFF2E2910);
const Color _rProfileBrunswick = Color(0xFF2C5745);
const Color _rProfileBrunswickDark = Color(0xFF1E3F32);
const Color _rProfileVanilla = Color(0xFFEBE3A7);
const Color _rProfileVanillaSoft = Color(0xFFFAF7E8);
const Color _rProfileTangerine = Color(0xFFEB7D00);
const Color _rProfileBackground = Color(0xFFF7F5EB);
const Color _rProfileWhite = Color(0xFFFFFFFF);
const Color _rProfileMuted = Color(0xFF736E58);
const Color _rProfileBorder = Color(0xFFD1C9A0);
const Color _rProfileRed = Color(0xFFDC2626);
const Color _rProfileGreen = Color(0xFF16A34A);

class RebiteRestaurantProfile extends StatefulWidget {
  final String storeName;
  final String storeEmail;

  // Callback navigasi dapat dihubungkan dari main.dart/dashboard nanti.
  final VoidCallback? onDashboard;
  final VoidCallback? onPostSurplus;
  final VoidCallback? onSidejob;
  final VoidCallback? onHistory;
  final VoidCallback? onManageStore;
  final VoidCallback? onPickupTime;
  final VoidCallback? onReports;
  final VoidCallback? onHelpCenter;
  final VoidCallback? onLogout;

  const RebiteRestaurantProfile({
    super.key,
    this.storeName = 'Nama Restoran',
    this.storeEmail = 'mitra.resto@medan.id',
    this.onDashboard,
    this.onPostSurplus,
    this.onSidejob,
    this.onHistory,
    this.onManageStore,
    this.onPickupTime,
    this.onReports,
    this.onHelpCenter,
    this.onLogout,
  });

  @override
  State<RebiteRestaurantProfile> createState() =>
      _RebiteRestaurantProfileState();
}

class _RebiteRestaurantProfileState extends State<RebiteRestaurantProfile> {
  bool _isStoreOpen = true;

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: _rProfileBrunswickDark,
        ),
      );
  }

  void _runAction(VoidCallback? action, String label) {
    if (action != null) {
      action();
    } else {
      _showMessage('$label belum dihubungkan ke halaman tujuan.');
    }
  }

  void _showInfoDialog(String title, String description) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: _rProfileWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: const BorderSide(color: _rProfileBorder),
          ),
          icon: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _rProfileBrunswick.withOpacity(0.10),
              shape: BoxShape.circle,
              border: Border.all(color: _rProfileBrunswick),
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              color: _rProfileBrunswick,
              size: 25,
            ),
          ),
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _rProfileDarkBrown,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _rProfileMuted,
              fontSize: 13,
              height: 1.45,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: _rProfileBrunswick,
                  foregroundColor: _rProfileVanilla,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text(
                  'Tutup',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showQualityControlDialog() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: _rProfileWhite,
          scrollable: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: const BorderSide(color: _rProfileBorder),
          ),
          icon: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _rProfileBrunswick.withOpacity(0.10),
              shape: BoxShape.circle,
              border: Border.all(color: _rProfileBrunswick),
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: _rProfileBrunswick,
              size: 25,
            ),
          ),
          title: const Text(
            'Quality Control & Anonimitas',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _rProfileDarkBrown,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Standar keselamatan dan privasi posting surplus restoran:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _rProfileMuted,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: _rProfileVanillaSoft,
                  border: Border.all(color: _rProfileBorder),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Column(
                  children: [
                    _PolicyItem(
                      text:
                          'Gunakan label anonim gizi umum (Karbohidrat, Roti, Siap Saji) untuk menjaga kejutan.',
                    ),
                    SizedBox(height: 10),
                    _PolicyItem(
                      text:
                          'Pastikan makanan masih layak konsumsi (maksimal 24 jam dari waktu pembuatan) dan dikemas secara higienis.',
                    ),
                    SizedBox(height: 10),
                    _PolicyItem(
                      text:
                          'Verifikasi QR Code atau PIN Klaim dari Claimer/Kurir Sidejob saat penjemputan.',
                    ),
                  ],
                ),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: _rProfileBrunswick,
                  foregroundColor: _rProfileVanilla,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text(
                  'Paham & Patuhi Standar',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: _rProfileWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: const BorderSide(color: _rProfileBorder),
          ),
          icon: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: _rProfileRed.withOpacity(0.10),
              shape: BoxShape.circle,
              border: Border.all(color: _rProfileRed),
            ),
            child: const Icon(
              Icons.logout_rounded,
              color: _rProfileRed,
              size: 25,
            ),
          ),
          title: const Text(
            'Keluar dari Akun Restoran?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _rProfileDarkBrown,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: const Text(
            'Sesi toko Anda akan diakhiri. Postingan surplus yang sedang aktif tetap dapat diklaim oleh pengguna.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _rProfileMuted,
              fontSize: 13,
              height: 1.45,
            ),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _rProfileDarkBrown,
                      side: const BorderSide(color: _rProfileBorder),
                      backgroundColor: _rProfileBackground,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text(
                      'Batal',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: _rProfileRed,
                      foregroundColor: _rProfileWhite,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      _runAction(widget.onLogout, 'Logout');
                    },
                    child: const Text(
                      'Ya, Keluar',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _rProfileBackground,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double pageWidth =
                constraints.maxWidth > 440 ? 440 : constraints.maxWidth;

            return Center(
              child: Container(
                width: pageWidth,
                height: constraints.maxHeight,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: _rProfileBackground,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: _rProfileBorder),
                  boxShadow: [
                    BoxShadow(
                      color: _rProfileDarkBrown.withOpacity(0.08),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildHeader(),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 22),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildQuotaCard(),
                            const SizedBox(height: 15),
                            _buildStatistics(),
                            const SizedBox(height: 18),
                            _buildMenuSection(
                              title: 'Kelola Toko & Operasional',
                              items: [
                                _MenuData(
                                  icon: Icons.storefront_outlined,
                                  title: 'Kelola Toko & Profil Alamat',
                                  onTap: () {
                                    if (widget.onManageStore != null) {
                                      _runAction(
                                        widget.onManageStore,
                                        'Kelola Toko',
                                      );
                                    } else {
                                      _showInfoDialog(
                                        'Kelola Toko',
                                        'Perbarui alamat toko, titik koordinat peta, dan kontak operasional WhatsApp.',
                                      );
                                    }
                                  },
                                ),
                                _MenuData(
                                  icon: Icons.access_time_rounded,
                                  title: 'Atur Jam Pickup Regular',
                                  badge: '18:00 WIB',
                                  onTap: () {
                                    if (widget.onPickupTime != null) {
                                      _runAction(
                                        widget.onPickupTime,
                                        'Jam Pickup',
                                      );
                                    } else {
                                      _showInfoDialog(
                                        'Jam Pickup Regular',
                                        'Atur jendela jam pengambilan default harian (contoh 18:00–20:00 WIB) agar otomatis terisi saat posting surplus.',
                                      );
                                    }
                                  },
                                ),
                                _MenuData(
                                  icon: Icons.bar_chart_rounded,
                                  title: 'Laporan & Rekap Surplus',
                                  onTap: () {
                                    if (widget.onReports != null) {
                                      _runAction(
                                        widget.onReports,
                                        'Laporan & Rekap Surplus',
                                      );
                                    } else {
                                      _showInfoDialog(
                                        'Laporan & Rekap Surplus',
                                        'Lihat rekap bulanan porsi surplus yang terselamatkan dan dampak pengurangan sampah organik.',
                                      );
                                    }
                                  },
                                ),
                                _MenuData(
                                  icon: Icons.shield_outlined,
                                  title:
                                      'Kebijakan Anonim & Quality Control',
                                  onTap: _showQualityControlDialog,
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            _buildMenuSection(
                              title: 'Layanan Partner & Keamanan',
                              items: [
                                _MenuData(
                                  icon: Icons.help_outline_rounded,
                                  title: 'Pusat Bantuan Partner',
                                  onTap: () {
                                    if (widget.onHelpCenter != null) {
                                      _runAction(
                                        widget.onHelpCenter,
                                        'Pusat Bantuan Partner',
                                      );
                                    } else {
                                      _showInfoDialog(
                                        'Pusat Bantuan Partner',
                                        'Halaman bantuan partner belum dihubungkan.',
                                      );
                                    }
                                  },
                                ),
                                _MenuData(
                                  icon: Icons.logout_rounded,
                                  title: 'Keluar / Logout',
                                  isLogout: true,
                                  onTap: _showLogoutDialog,
                                ),
                              ],
                            ),
                          ],
                        ),
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
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 17, 20, 16),
      decoration: BoxDecoration(
        color: _rProfileBrunswick,
        boxShadow: [
          BoxShadow(
            color: _rProfileBrunswickDark.withOpacity(0.18),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Profil Restoran',
                  style: TextStyle(
                    color: _rProfileWhite,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: _rProfileVanilla.withOpacity(0.16),
                  border: Border.all(color: _rProfileVanilla),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.restaurant_rounded,
                      size: 13,
                      color: _rProfileVanilla,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'MITRA RESTO',
                      style: TextStyle(
                        color: _rProfileVanilla,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: _rProfileVanilla,
                  border: Border.all(
                    color: _rProfileTangerine,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.14),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.restaurant_menu_rounded,
                  size: 29,
                  color: _rProfileBrunswick,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.storeName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _rProfileWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.storeEmail,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _rProfileVanilla,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: _rProfileWhite.withOpacity(0.12),
                        border: Border.all(
                          color: _rProfileVanilla.withOpacity(0.4),
                        ),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified_outlined,
                            size: 12,
                            color: _rProfileTangerine,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Mitra Verifikasi ReBite',
                            style: TextStyle(
                              color: _rProfileVanilla,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.20),
              border: Border.all(
                color: _rProfileVanilla.withOpacity(0.25),
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: _isStoreOpen ? _rProfileGreen : _rProfileRed,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (_isStoreOpen
                                ? _rProfileGreen
                                : _rProfileRed)
                            .withOpacity(0.55),
                        blurRadius: 7,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isStoreOpen
                            ? 'Toko Buka (Menerima Surplus)'
                            : 'Toko Tutup (Posting Nonaktif)',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _rProfileWhite,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _isStoreOpen
                            ? 'Siap menerbitkan & melayani pickup'
                            : 'Surplus baru tidak dapat ditambahkan',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _rProfileVanilla,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Switch.adaptive(
                  value: _isStoreOpen,
                  activeColor: _rProfileTangerine,
                  onChanged: (value) {
                    setState(() {
                      _isStoreOpen = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuotaCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _rProfileWhite,
        border: Border.all(color: _rProfileBorder),
        borderRadius: BorderRadius.circular(19),
        boxShadow: [
          BoxShadow(
            color: _rProfileDarkBrown.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool isNarrow = constraints.maxWidth < 330;

          final title = Row(
            children: [
              const Icon(
                Icons.description_outlined,
                color: _rProfileTangerine,
                size: 17,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Kuota Posting Surplus Harian',
                  style: const TextStyle(
                    color: _rProfileDarkBrown,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          );

          final badge = Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: _rProfileVanilla,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              '3 / 5 Postingan',
              style: TextStyle(
                color: _rProfileBrunswick,
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isNarrow) ...[
                title,
                const SizedBox(height: 7),
                Align(alignment: Alignment.centerRight, child: badge),
              ] else
                Row(
                  children: [
                    Expanded(child: title),
                    const SizedBox(width: 8),
                    badge,
                  ],
                ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: 0.6,
                  minHeight: 9,
                  backgroundColor: _rProfileBackground,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    _rProfileTangerine,
                  ),
                ),
              ),
              const SizedBox(height: 9),
              const Wrap(
                alignment: WrapAlignment.spaceBetween,
                runSpacing: 4,
                children: [
                  Text(
                    'Tersisa 2 postingan lagi hari ini',
                    style: TextStyle(
                      color: _rProfileMuted,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Reset Pukul 00:00 WIB',
                    style: TextStyle(
                      color: _rProfileBrunswick,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatistics() {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: const [
      Expanded(
        child: _RestaurantStatCard(
          icon: Icons.inventory_2_outlined,
          value: '142',
          label: 'Total Porsi Terselamatkan',
        ),
      ),
      SizedBox(width: 8),
      Expanded(
        child: _RestaurantStatCard(
          icon: Icons.local_shipping_outlined,
          value: '18',
          label: 'Misi Sidejob Selesai',
        ),
      ),
      SizedBox(width: 8),
      Expanded(
        child: _RestaurantStatCard(
          icon: Icons.star_outline_rounded,
          value: '4.9 â˜…',
          label: 'Rating & Dampak 71 kg COâ‚‚e',
        ),
      ),
    ],
  );
}

  Widget _buildMenuSection({
    required String title,
    required List<_MenuData> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: _rProfileMuted,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: _rProfileWhite,
            border: Border.all(color: _rProfileBorder),
            borderRadius: BorderRadius.circular(17),
            boxShadow: [
              BoxShadow(
                color: _rProfileDarkBrown.withOpacity(0.025),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              children: List.generate(items.length, (index) {
                final item = items[index];

                return Column(
                  children: [
                    _buildMenuItem(item),
                    if (index != items.length - 1)
                      const Padding(
                        padding: EdgeInsets.only(left: 56),
                        child: Divider(
                          height: 1,
                          thickness: 1,
                          color: _rProfileBorder,
                        ),
                      ),
                  ],
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(_MenuData item) {
    final Color itemColor =
        item.isLogout ? _rProfileRed : _rProfileDarkBrown;
    final Color iconColor =
        item.isLogout ? _rProfileRed : _rProfileBrunswick;

    return Material(
      color: _rProfileWhite,
      child: InkWell(
        onTap: item.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: item.isLogout
                      ? _rProfileRed.withOpacity(0.09)
                      : _rProfileBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  item.icon,
                  size: 17,
                  color: iconColor,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: itemColor,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
              ),
              if (item.badge != null) ...[
                const SizedBox(width: 5),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _rProfileTangerine.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    item.badge!,
                    style: const TextStyle(
                      color: _rProfileTangerine,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
              const SizedBox(width: 3),
              const Icon(
                Icons.chevron_right_rounded,
                color: _rProfileMuted,
                size: 19,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: _rProfileWhite,
        border: Border(
          top: BorderSide(color: _rProfileBorder, width: 1),
        ),
      ),
      child: Row(
        children: [
          _buildNavItem(
            icon: Icons.dashboard_outlined,
            label: 'Dashboard',
            onTap: () => _runAction(widget.onDashboard, 'Dashboard'),
          ),
          _buildNavItem(
            icon: Icons.add_circle_outline_rounded,
            label: 'Post Surplus',
            onTap: () => _runAction(widget.onPostSurplus, 'Post Surplus'),
          ),
          _buildNavItem(
            icon: Icons.work_outline_rounded,
            label: 'Sidejob',
            onTap: () => _runAction(widget.onSidejob, 'Sidejob'),
          ),
          _buildNavItem(
            icon: Icons.history_rounded,
            label: 'Riwayat',
            onTap: () => _runAction(widget.onHistory, 'Riwayat'),
          ),
          _buildNavItem(
            icon: Icons.person_outline_rounded,
            label: 'Profil',
            isSelected: true,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    final Color color =
        isSelected ? _rProfileTangerine : _rProfileMuted;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(height: 3),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RestaurantStatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _RestaurantStatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 112),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 11),
      decoration: BoxDecoration(
        color: _rProfileWhite,
        border: Border.all(color: _rProfileBorder),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: _rProfileDarkBrown.withOpacity(0.035),
            blurRadius: 7,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 31,
            height: 31,
            decoration: BoxDecoration(
              color: _rProfileVanillaSoft,
              border: Border.all(color: _rProfileBorder),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(
              icon,
              color: _rProfileBrunswick,
              size: 17,
            ),
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              maxLines: 1,
              style: const TextStyle(
                color: _rProfileDarkBrown,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _rProfileMuted,
              fontSize: 9,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _PolicyItem extends StatelessWidget {
  final String text;

  const _PolicyItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 1),
          child: Icon(
            Icons.check_circle_outline_rounded,
            color: _rProfileBrunswick,
            size: 15,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: _rProfileDarkBrown,
              fontSize: 11,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}

class _MenuData {
  final IconData icon;
  final String title;
  final String? badge;
  final VoidCallback onTap;
  final bool isLogout;

  const _MenuData({
    required this.icon,
    required this.title,
    required this.onTap,
    this.badge,
    this.isLogout = false,
  });
}
