import 'package:flutter/material.dart';

import 'claim_history.dart';
import 'food_detail.dart';
import 'rebite_claimer_profile.dart';
import 'sidejob_missions.dart';
import 'sidejob_register.dart';
// ============================================================
// 1. PALET WARNA
// ============================================================
const Color kDarkBrown = Color(0xFF2E2910);
const Color kBrunswick = Color(0xFF2C5745);
const Color kBrunswickDark = Color(0xFF1E3F32);
const Color kVanilla = Color(0xFFEBE3A7);
const Color kVanillaSoft = Color(0xFFFAF7E8);
const Color kTangerine = Color(0xFFEB7D00);
const Color kBgLight = Color(0xFFF7F5EB);
const Color kMuted = Color(0xFF736E58);
const Color kBorder = Color(0xFFD1C9A0);
const Color kRedAlert = Color(0xFFDC2626);

// ============================================================
// 2. MODEL DATA
// ============================================================
class FoodSpot {
  final int id;
  final String category;
  final String labelType;
  final String badgeText;
  final String badgeType;
  final String name;
  final String address;
  final String hint;
  final String time;
  final String stock;
  final Color stockColor;
  final String actionLabel;
  final double x;
  final double y;

  const FoodSpot({
    required this.id,
    required this.category,
    required this.labelType,
    required this.badgeText,
    required this.badgeType,
    required this.name,
    required this.address,
    required this.hint,
    required this.time,
    required this.stock,
    required this.stockColor,
    required this.actionLabel,
    required this.x,
    required this.y,
  });
}

class _CategoryItem {
  final String key;
  final String label;
  final IconData icon;
  const _CategoryItem(this.key, this.label, this.icon);
}

// ============================================================
// 3. DATA STATIS
// ============================================================
const List<_CategoryItem> _categories = [
  _CategoryItem('all', 'Semua', Icons.grid_view_rounded),
  _CategoryItem('free', 'Free Food', Icons.sell_outlined),
  _CategoryItem('discount', 'Deep Discount', Icons.local_offer_outlined),
  _CategoryItem('sidejob', 'Sidejob Pickup', Icons.work_outline),
  _CategoryItem('pet', 'Pakan Ternak', Icons.pets),
];

const List<FoodSpot> _spots = [
  FoodSpot(
    id: 1,
    category: 'free',
    labelType: 'Karbohidrat & Protein',
    badgeText: 'GRATIS',
    badgeType: 'free',
    name: 'Restoran Sederhana Food Bank',
    address: 'Jl. Gajah Mada No. 12, Petisah Tengah, Medan',
    hint: 'Surprise Box (Isi makanan tidak disebutkan)',
    time: '16:00 - 18:00 WIB',
    stock: 'Tersisa 4 Porsi',
    stockColor: kTangerine,
    actionLabel: 'Klaim Kuota',
    x: 0.36,
    y: 0.42,
  ),
  FoodSpot(
    id: 2,
    category: 'discount',
    labelType: 'Olahan Roti & Pastry',
    badgeText: 'Diskon 70% (Rp 12.000)',
    badgeType: 'discount',
    name: 'Aroma Bakery Rescue Spot',
    address: 'Jl. Merdeka No. 45, Kesawan, Medan',
    hint: 'Paket Aneka Roti Manis & Gurih',
    time: '18:00 - 20:30 WIB',
    stock: 'Tersisa 2 Box',
    stockColor: kBrunswick,
    actionLabel: 'Klaim Kuota',
    x: 0.62,
    y: 0.26,
  ),
  FoodSpot(
    id: 3,
    category: 'free',
    labelType: 'Makanan Siap Saji (Nasi & Lauk)',
    badgeText: 'GRATIS',
    badgeType: 'free',
    name: 'Warung Berkah Harmoni',
    address: 'Jl. S. Parman No. 88, Medan Baru, Medan',
    hint: 'Nasi Bungkus Lauk Lengkap',
    time: '17:30 - 19:00 WIB',
    stock: 'Tersisa 5 Porsi',
    stockColor: kTangerine,
    actionLabel: 'Klaim Kuota',
    x: 0.24,
    y: 0.66,
  ),
  FoodSpot(
    id: 4,
    category: 'pet',
    labelType: 'Pakan Ternak & Sayuran Sisa',
    badgeText: 'Free - Peternak',
    badgeType: 'pet',
    name: 'Dapur Hijau Organik',
    address: 'Jl. Gatot Subroto No. 104, Sei Sikambing, Medan',
    hint: 'Sisa Sayuran Bersih untuk Pakan Ternak',
    time: '08:00 - 16:00 WIB',
    stock: 'Tersisa 8 Kg',
    stockColor: kDarkBrown,
    actionLabel: 'Klaim Kuota',
    x: 0.75,
    y: 0.72,
  ),
  FoodSpot(
    id: 5,
    category: 'sidejob',
    labelType: 'Makanan Olahan & Katering',
    badgeText: 'Sidejob Pickup',
    badgeType: 'free',
    name: 'Katering Bunda & Partner',
    address: 'Jl. Diponegoro No. 29, Madras Hulu, Medan',
    hint: 'Paket Donasi Antar Ke Titik Homeless',
    time: '19:00 - 21:00 WIB',
    stock: 'Tersisa 3 Paket',
    stockColor: kBrunswick,
    actionLabel: 'Ambil Sidejob',
    x: 0.52,
    y: 0.14,
  ),
];

// ============================================================
// 4. WIDGET UTAMA
// ============================================================
class RebiteClaimerDashboardMap extends StatefulWidget {
  const RebiteClaimerDashboardMap({super.key});

  @override
  State<RebiteClaimerDashboardMap> createState() =>
      _RebiteClaimerDashboardMapState();
}

class _RebiteClaimerDashboardMapState extends State<RebiteClaimerDashboardMap> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _mapSectionKey = GlobalKey();

  String _selectedCategory = 'all';
  int? _selectedSpot;
  bool _showModal = false;

  // ------------------------------------------------------------
  // NAVIGASI — helper

void _push(Widget page) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => page),
  );
}

/// Card 1–4 → FoodDetail(id) | Card 5 (sidejob) → SidejobMissions
void _onSpotTap(FoodSpot spot) {
  if (spot.category == 'sidejob') {
    _push(const SidejobMissions());
  } else {
    _push(FoodDetail(id: spot.id));
  }
}

  // ------------------------------------------------------------
  // PETA
  // ------------------------------------------------------------
  List<FoodSpot> get _visibleSpots {
    if (_selectedCategory == 'all') return _spots;
    return _spots.where((s) => s.category == _selectedCategory).toList();
  }

  void _focusMap(int index) {
    setState(() => _selectedSpot = index);

    final bool isWide = MediaQuery.of(context).size.width >= 900;
    if (isWide) return;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted || !_scrollController.hasClients) return;
      await _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
      if (mounted && _scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  void _openModal() => setState(() => _showModal = true);
  void _closeModal() => setState(() => _showModal = false);

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ==========================================================
  // BUILD
  // ==========================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgLight,
      body: SafeArea(
        child: Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final bool isWide = constraints.maxWidth >= 900;
                return Column(
                  children: [
                    _buildHeader(),
                    _buildFilterChips(),
                    Expanded(
                      child: isWide
                          ? _buildWideLayout()
                          : _buildMobileLayout(),
                    ),
                    _buildBottomNav(),
                  ],
                );
              },
            ),
            if (_showModal) _buildClaimModal(),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // LAYOUT MOBILE
  // ==========================================================
  Widget _buildMobileLayout() {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double mapHeight =
        (screenHeight * 0.34).clamp(200.0, 320.0).toDouble();
    final bool isShort = screenHeight < 700;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: ListView(
          controller: _scrollController,
          padding: EdgeInsets.fromLTRB(16, isShort ? 10 : 14, 16, 14),
          children: [
            _buildSidejobBanner(),
            const SizedBox(height: 16),
            _buildSectionHeader(),
            const SizedBox(height: 12),
            ..._visibleSpots.map(
              (spot) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildFoodCard(spot),
              ),
            ),
            const SizedBox(height: 4),
            Column(
              key: _mapSectionKey,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMapTitle(),
                const SizedBox(height: 10),
                _buildMapCanvas(height: mapHeight),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // LAYOUT WIDE / WEB
  // ==========================================================
  Widget _buildWideLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 11,
          child: ListView(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
            children: [
              _buildSidejobBanner(),
              const SizedBox(height: 16),
              _buildSectionHeader(),
              const SizedBox(height: 12),
              ..._visibleSpots.map(
                (spot) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildFoodCard(spot),
                ),
              ),
            ],
          ),
        ),
        Container(width: 1, color: kBorder),
        Expanded(
          flex: 9,
          child: Padding(
            key: _mapSectionKey,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildMapTitle(),
                const SizedBox(height: 10),
                _selectedSpot != null
                    ? _buildSelectedSpotCard()
                    : _buildMapHint(),
                const SizedBox(height: 10),
                Expanded(child: _buildMapCanvas()),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // HEADER
  // ==========================================================
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
      color: kBrunswick,
      child: Row(
        children: [
          // === user-profile → rebite_claimer_profile.html ===
          GestureDetector(
            onTap: () => _push(const RebiteClaimerProfile()),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: kVanilla,
                    border: Border.all(color: kTangerine, width: 2),
                  ),
                  child: const Text(
                    'P',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: kBrunswick,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0x40EB7D00),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: kTangerine),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.person_outline,
                              size: 11, color: kTangerine),
                          SizedBox(width: 4),
                          Text(
                            'CLAIMER',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                              color: kVanilla,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Nama Pengguna',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          // === quota-box → claim-history.html ===
          GestureDetector(
            onTap: () => _push(const ClaimHistory()),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0x26EBE3A7),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: kVanilla),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'LIMIT KLAIM',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: kVanilla,
                    ),
                  ),
                  Text(
                    '2 / 3 Hari Ini',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
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
  // FILTER CHIPS
  // ==========================================================
  Widget _buildFilterChips() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: SizedBox(
        height: 34,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 6),
          itemBuilder: (context, index) {
            final item = _categories[index];
            final active = _selectedCategory == item.key;
            return Center(
              child: GestureDetector(
                onTap: () => setState(() => _selectedCategory = item.key),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: active ? kBrunswick : kBgLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: active ? kBrunswick : kBorder,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.icon,
                        size: 13,
                        color: active ? kVanilla : kMuted,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: active ? kVanilla : kMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ==========================================================
  // BANNER SIDEJOB  →  sidejob-register.html
  // ==========================================================
  Widget _buildSidejobBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: kBrunswick,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x262C5745),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.work_outline, size: 22, color: kTangerine),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tersedia Delivery Sidejob',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: kVanilla,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Antar makanan donasi & dapatkan poin reward.',
                  style: TextStyle(fontSize: 11, color: Color(0xD9EBE3A7)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => _push(const SidejobRegister()),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: kTangerine,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Ambil Misi',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // JUDUL SECTION
  // ==========================================================
  Widget _buildSectionHeader() {
    return Row(
      children: [
        const Icon(Icons.place_outlined, size: 16, color: kTangerine),
        const SizedBox(width: 6),
        const Expanded(
          child: Text(
            'Daftar Lokasi & Makanan Surplus',
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w800,
              color: kDarkBrown,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: kVanilla,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${_visibleSpots.length} Lokasi',
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
              color: kBrunswick,
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // KARTU MAKANAN
  // ==========================================================
  Widget _buildFoodCard(FoodSpot spot) {
    final index = _spots.indexOf(spot);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D2E2910),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: kVanilla,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      spot.labelType,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: kDarkBrown,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _buildBadge(spot),
            ],
          ),
          const SizedBox(height: 10),

          // === Nama tempat → food-detail / sidejob-missions ===
          GestureDetector(
            onTap: () => _onSpotTap(spot),
            child: Text(
              spot.name,
              style: const TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w800,
                height: 1.25,
                color: kDarkBrown,
              ),
            ),
          ),
          const SizedBox(height: 6),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 2),
                child: Icon(Icons.location_on_outlined,
                    size: 14, color: kTangerine),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  spot.address,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                    color: kMuted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 2),
                child: Icon(Icons.lock_outline, size: 12, color: kMuted),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  spot.hint,
                  style: const TextStyle(
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                    color: kMuted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: kVanillaSoft,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.access_time,
                        size: 14, color: kBrunswick),
                    const SizedBox(width: 5),
                    Text(
                      spot.time,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: kDarkBrown,
                      ),
                    ),
                  ],
                ),
                Text(
                  spot.stock,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: spot.stockColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              // === "Lihat di Peta" → scroll & highlight marker ===
              Expanded(
                flex: 10,
                child: GestureDetector(
                  onTap: () => _focusMap(index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    decoration: BoxDecoration(
                      color: kBgLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: kBorder),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.map_outlined,
                            size: 14, color: kDarkBrown),
                        SizedBox(width: 5),
                        Text(
                          'Lihat di Peta',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: kDarkBrown,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // === "Klaim Kuota"/"Ambil Sidejob"
              //     Tap  → food-detail.html?id=N / sidejob-missions.html
              //     Long-press → buka modal (bonus; di HTML modal tak terpanggil)
              Expanded(
                flex: 14,
                child: GestureDetector(
                  onTap: () => _onSpotTap(spot),
                  onLongPress: _openModal,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    decoration: BoxDecoration(
                      color: kBrunswick,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          spot.actionLabel,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: kVanilla,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Icon(Icons.arrow_forward,
                            size: 14, color: kVanilla),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(FoodSpot spot) {
    late final Color bg;
    late final Color fg;
    late final Color border;

    if (spot.badgeType == 'free') {
      bg = const Color(0x1FEB7D00);
      fg = kTangerine;
      border = const Color(0x4DEB7D00);
    } else if (spot.badgeType == 'discount') {
      bg = const Color(0x1A2C5745);
      fg = kBrunswick;
      border = const Color(0x402C5745);
    } else {
      bg = const Color(0x142E2910);
      fg = kDarkBrown;
      border = kBorder;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: border),
      ),
      child: Text(
        spot.badgeText,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w800,
          color: fg,
        ),
      ),
    );
  }

  // ==========================================================
  // PETA — bagian dalam
  // ==========================================================
  Widget _buildMapTitle() {
    return Row(
      children: [
        const Icon(Icons.map_outlined, size: 16, color: kTangerine),
        const SizedBox(width: 6),
        const Text(
          'Peta Sebaran Food Bank',
          style: TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w800,
            color: kDarkBrown,
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedSpotCard() {
    final spot = _spots[_selectedSpot!];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kTangerine, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26EB7D00),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 18, color: kTangerine),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'LOKASI DIPILIH',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: kTangerine,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  spot.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: kDarkBrown,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapHint() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: kVanillaSoft,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: const [
          Icon(Icons.info_outline, size: 14, color: kMuted),
          SizedBox(width: 6),
          Expanded(
            child: Text(
              'Klik "Lihat di Peta" pada kartu lokasi, atau langsung klik marker di peta.',
              style: TextStyle(fontSize: 11, color: kMuted),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapCanvas({double? height}) {
    final mapBody = Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x142E2910),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final h = constraints.maxHeight;

          return Stack(
            fit: StackFit.expand,
            children: [
              Container(color: const Color(0xFFE8EFE4)),
              Positioned(
                left: 0,
                right: 0,
                top: h * 0.28,
                child: Container(height: 9, color: Colors.white),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: h * 0.60,
                child: Container(height: 9, color: Colors.white),
              ),
              Positioned(
                top: 0,
                bottom: 0,
                left: w * 0.33,
                child: Container(width: 9, color: Colors.white),
              ),
              Positioned(
                top: 0,
                bottom: 0,
                left: w * 0.68,
                child: Container(width: 9, color: Colors.white),
              ),
              Positioned(
                left: w * 0.05,
                top: h * 0.68,
                child: Container(
                  width: 70,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD7E6CB),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              Positioned(
                right: w * 0.05,
                top: h * 0.08,
                child: Container(
                  width: 60,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD7E6CB),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              ...List.generate(_spots.length, (i) => _buildMarker(i, w, h)),
              if (_selectedSpot != null) _buildCallout(w, h),
              Positioned(
                right: 6,
                bottom: 4,
                child: Text(
                  '© OpenStreetMap',
                  style: TextStyle(fontSize: 8, color: kMuted),
                ),
              ),
            ],
          );
        },
      ),
    );

    return height != null ? SizedBox(height: height, child: mapBody) : mapBody;
  }

  Positioned _buildMarker(int i, double w, double h) {
    final spot = _spots[i];
    final bool selected = _selectedSpot == i;

    final double size = selected ? 42 : 30;
    final Color fill = selected ? kTangerine : _markerColor(spot.category);

    return Positioned(
      left: w * spot.x - size / 2,
      top: h * spot.y - size / 2,
      child: GestureDetector(
        onTap: () => setState(() => _selectedSpot = i),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: fill,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: selected ? 3 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: selected
                    ? const Color(0x80EB7D00)
                    : const Color(0x332E2910),
                blurRadius: selected ? 16 : 6,
                spreadRadius: selected ? 3 : 0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            Icons.restaurant,
            size: selected ? 20 : 13,
            color: selected ? kVanilla : Colors.white,
          ),
        ),
      ),
    );
  }

  Positioned _buildCallout(double w, double h) {
    final spot = _spots[_selectedSpot!];
    const double calloutWidth = 160;

    final double left = (w * spot.x - calloutWidth / 2)
        .clamp(6.0, w - calloutWidth - 6)
        .toDouble();
    final double top = (h * spot.y - 72).clamp(6.0, h - 78).toDouble();

    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: calloutWidth,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: kTangerine, width: 1.5),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33EB7D00),
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(
              children: [
                Icon(Icons.check_circle, size: 12, color: kTangerine),
                SizedBox(width: 4),
                Text(
                  'Lokasi dipilih',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    color: kTangerine,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              spot.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                height: 1.25,
                color: kDarkBrown,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _markerColor(String category) {
    switch (category) {
      case 'free':
        return kTangerine;
      case 'discount':
        return kBrunswick;
      case 'sidejob':
        return kBrunswickDark;
      case 'pet':
      default:
        return kDarkBrown;
    }
  }

  // ==========================================================
  // BOTTOM NAV
  // ==========================================================
  Widget _buildBottomNav() {
    return Container(
      height: 62,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: kBorder)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Eksplor = halaman ini (aktif, tanpa aksi)
              _navItem(
                Icons.map_outlined,
                'Peta Food',
                active: true,
              ),
              // Sidejob → sidejob-missions.html
              _navItem(
                Icons.work_outline,
                'Sidejob',
                active: false,
                onTap: () =>
                    _push(const SidejobMissions()),
              ),
              // Riwayat → claim-history.html
              _navItem(
                Icons.history,
                'Riwayat',
                active: false,
                onTap: () =>
                    _push(const ClaimHistory()),
              ),
              // Profil → rebite_claimer_profile.html
              _navItem(
                Icons.person_outline,
                'Profil',
                active: false,
                onTap: () => _push(const RebiteClaimerProfile()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(
    IconData icon,
    String label, {
    required bool active,
    VoidCallback? onTap,
  }) {
    final color = active ? kTangerine : kMuted;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 3),
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

  // ==========================================================
  // MODAL TIKET KLAIM
  // - Trigger: long-press "Klaim Kuota" (bonus).
  // ==========================================================
  Widget _buildClaimModal() {
    return Positioned.fill(
      child: GestureDetector(
        onTap: _closeModal,
        child: Container(
          color: const Color(0xAD2E2910),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          child: GestureDetector(
            onTap: () {},
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 360),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: kBorder),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x40000000),
                    blurRadius: 48,
                    offset: Offset(0, 20),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Tiket Klaim Aktif',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: kDarkBrown,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _closeModal,
                        child: const Icon(Icons.close,
                            size: 20, color: kMuted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tunjukkan QR Code ini kepada pihak restoran/mitra saat pengambilan.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: kMuted),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Container(
                      width: 170,
                      height: 170,
                      decoration: BoxDecoration(
                        color: kBgLight,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: kBrunswick, width: 2),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.qr_code_2,
                              size: 100, color: kBrunswick),
                          SizedBox(height: 2),
                          Text(
                            'REBITE-8829-MEDAN',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1,
                              color: kDarkBrown,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0x1ADC2626),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0x40DC2626)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.access_time,
                            size: 14, color: kRedAlert),
                        SizedBox(width: 6),
                        Text(
                          'Kadaluarsa dalam: 44m 58s',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: kRedAlert,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  // === Selesai → claim_history.dart ===
                  GestureDetector(
                    onTap: () {
                      _closeModal();
                      _push(const ClaimHistory());
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: kTangerine,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Selesai & Simpan Tiket',
                        style: TextStyle(
                          fontSize: 13.5,
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
      ),
    );
  }
}

// ============================================================
// 5. HALAMAN PLACEHOLDER TUJUAN
// ============================================================
/// Merepresentasikan file .html tujuan dari setiap tombol/link.
/// Hanya front-end; tidak melakukan apa pun selain menampilkan info.
class _DestinationPlaceholder extends StatelessWidget {
  final String title;
  final String htmlTarget;

  const _DestinationPlaceholder({
    required this.title,
    required this.htmlTarget,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgLight,
      appBar: AppBar(
        backgroundColor: kBrunswick,
        foregroundColor: kVanilla,
        elevation: 0,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: kVanilla,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.construction,
                  size: 48,
                  color: kTangerine,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: kDarkBrown,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tujuan: $htmlTarget',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: kMuted,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Halaman ini adalah placeholder front-end.\nHubungkan ke halaman asli saat backend siap.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: kMuted),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: kTangerine,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Kembali',
                    style: TextStyle(
                      fontSize: 13,
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
    );
  }
}