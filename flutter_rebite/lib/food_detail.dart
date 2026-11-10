import 'package:flutter/material.dart';

import 'claim_history.dart';

const Color _kDarkBrown = Color(0xFF2E2910);
const Color _kBrunswick = Color(0xFF2C5745);
const Color _kVanilla = Color(0xFFEBE3A7);
const Color _kTangerine = Color(0xFFEB7D00);
const Color _kBgLight = Color(0xFFF7F5EB);
const Color _kMuted = Color(0xFF736E58);
const Color _kBorder = Color(0xFFD1C9A0);

class _FoodItem {
  final String badge;
  final String title;
  final String price;
  final String originalPrice;
  final String restaurant;
  final String address;
  final String pickupTime;
  final String deadline;
  final String pickupMethod;
  final List<String> tags;

  const _FoodItem({
    required this.badge,
    required this.title,
    required this.price,
    required this.originalPrice,
    required this.restaurant,
    required this.address,
    required this.pickupTime,
    required this.deadline,
    required this.pickupMethod,
    required this.tags,
  });
}

const Map<int, _FoodItem> _foodItems = {
  1: _FoodItem(
    badge: 'Free Food / Donasi',
    title: 'Surplus Meal Box: Karbohidrat & Protein',
    price: 'GRATIS',
    originalPrice: 'Rp 35.000',
    restaurant: 'Restoran Sederhana Food Bank',
    address: 'Jl. Gajah Mada No. 12 (0.4 km)',
    pickupTime: '16:00 - 18:00 WIB',
    deadline: 'Hari Ini, 18:00 WIB',
    pickupMethod: 'Self-Pickup (QR)',
    tags: ['Nasi / Karbo', 'Lauk Daging / Ayam', 'Tanpa Pengawet', 'Halal'],
  ),
  2: _FoodItem(
    badge: 'Deep Discount 70%',
    title: 'Surplus Box: Olahan Roti & Pastry',
    price: 'Rp 12.000',
    originalPrice: 'Rp 40.000',
    restaurant: 'Aroma Bakery Rescue Spot',
    address: 'Jl. Merdeka No. 45, Kesawan (0.8 km)',
    pickupTime: '18:00 - 20:30 WIB',
    deadline: 'Hari Ini, 20:30 WIB',
    pickupMethod: 'Self-Pickup (QR)',
    tags: ['Roti & Pastry', 'Tanpa Pengawet', 'Halal'],
  ),
  3: _FoodItem(
    badge: 'Free Food / Donasi',
    title: 'Makanan Siap Saji: Nasi & Lauk',
    price: 'GRATIS',
    originalPrice: 'Rp 25.000',
    restaurant: 'Warung Berkah Harmoni',
    address: 'Jl. S. Parman No. 88, Medan Baru (1.2 km)',
    pickupTime: '17:30 - 19:00 WIB',
    deadline: 'Hari Ini, 19:00 WIB',
    pickupMethod: 'Self-Pickup (QR)',
    tags: ['Nasi / Karbo', 'Lauk Lengkap', 'Tanpa Pengawet', 'Halal'],
  ),
  4: _FoodItem(
    badge: 'Pakan Ternak',
    title: 'Pakan Ternak & Sayuran Sisa Bersih',
    price: 'GRATIS',
    originalPrice: 'Peternak',
    restaurant: 'Dapur Hijau Organik',
    address: 'Jl. Gatot Subroto No. 104 (2.1 km)',
    pickupTime: '08:00 - 16:00 WIB',
    deadline: 'Hari Ini, 16:00 WIB',
    pickupMethod: 'Self-Pickup',
    tags: ['Sayuran Bersih', 'Pakan Ternak', 'Tanpa Pengawet'],
  ),
};

class FoodDetail extends StatelessWidget {
  final int id;

  const FoodDetail({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final item = _foodItems[id] ?? _foodItems[1]!;

    return Scaffold(
      backgroundColor: _kBgLight,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                    Stack(
                      children: [
                        _buildHero(context, item),
                        Positioned(
                          left: 16,
                          right: 16,
                          top: 14,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _circleAction(
                                icon: Icons.arrow_back,
                                onTap: () => Navigator.of(context).maybePop(),
                              ),
                              _circleAction(
                                icon: Icons.share_outlined,
                                onTap: () => ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                      const SnackBar(
                                        content: Text('Link berhasil disalin!'),
                                      ),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTitlePrice(item),
                          const SizedBox(height: 16),
                          _buildRestaurant(item),
                          const SizedBox(height: 14),
                          _buildPrivacyNotice(),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: _buildMetaCard(
                                  'Jam Pengambilan',
                                  item.pickupTime,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildMetaCard(
                                  'Metode Ambil',
                                  item.pickupMethod,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'KOMPOSISI KATEGORI',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: _kMuted,
                              letterSpacing: 0.4,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: item.tags
                                .map(
                                  (tag) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 7,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _kVanilla,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      tag,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: _kDarkBrown,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: _kBorder)),
          ),
          child: Row(
            children: [
              const Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LIMIT HARIAN KAMU',
                      style: TextStyle(
                        fontSize: 10,
                        color: _kMuted,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Sisa 2 dari 3 Klaim',
                      style: TextStyle(
                        fontSize: 13,
                        color: _kDarkBrown,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              FilledButton.icon(
                onPressed: () => _confirmClaim(context, item),
                icon: const Icon(Icons.arrow_forward, size: 18),
                label: const Text('Klaim Kuota'),
                style: FilledButton.styleFrom(
                  foregroundColor: _kVanilla,
                  backgroundColor: _kBrunswick,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHero(BuildContext context, _FoodItem item) {
    return Container(
      height: 280,
      width: double.infinity,
      color: _kVanilla,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Positioned.fill(
            child: CustomPaint(painter: _DotPatternPainter()),
          ),
          const Icon(Icons.restaurant_menu, size: 112, color: _kBrunswick),
          Positioned(
            bottom: 16,
            left: 20,
            child: _heroPill(item.badge, _kTangerine, Colors.white),
          ),
          const Positioned(
            bottom: 16,
            right: 20,
            child: Row(
              children: [
                Icon(Icons.timer_outlined, size: 15, color: _kVanilla),
                SizedBox(width: 5),
                Text(
                  'Sisa 45 Menit',
                  style: TextStyle(
                    color: _kVanilla,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _heroPill(String text, Color color, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _circleAction({required IconData icon, required VoidCallback onTap}) {
    return Material(
      color: Colors.white.withValues(alpha: 0.92),
      shape: const CircleBorder(side: BorderSide(color: _kBorder)),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(icon, size: 20, color: _kDarkBrown),
        ),
      ),
    );
  }

  Widget _buildTitlePrice(_FoodItem item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            item.title,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              height: 1.25,
              color: _kDarkBrown,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
          decoration: BoxDecoration(
            color: const Color(0x1AEB7D00),
            border: Border.all(color: _kTangerine),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.price,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: _kTangerine,
                  fontSize: 14,
                ),
              ),
              Text(
                item.originalPrice,
                style: const TextStyle(
                  fontSize: 10,
                  color: _kMuted,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRestaurant(_FoodItem item) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _kBorder),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _kVanilla,
              border: Border.all(color: _kBrunswick, width: 2),
            ),
            child: Text(
              item.restaurant[0],
              style: const TextStyle(
                color: _kBrunswick,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.restaurant,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: _kDarkBrown,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: _kMuted,
                    ),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        item.address,
                        style: const TextStyle(fontSize: 11, color: _kMuted),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyNotice() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0x142C5745),
        border: Border.all(color: _kBrunswick, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lock_outline, color: _kBrunswick, size: 21),
          SizedBox(width: 10),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Prinsip Kategori Anonim: ',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: _kBrunswick,
                    ),
                  ),
                  TextSpan(
                    text:
                        'Rincian spesifik menu dirahasiakan untuk menjaga '
                        'privasi dan menghindari pemborosan selektif. Makanan '
                        'dijamin layak konsumsi dan higienis.',
                  ),
                ],
              ),
              style: TextStyle(
                color: _kDarkBrown,
                fontSize: 11.5,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _kBorder),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 9,
              color: _kMuted,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              color: _kDarkBrown,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmClaim(BuildContext context, _FoodItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          'Konfirmasi Klaim Makanan',
          style: TextStyle(color: _kDarkBrown, fontWeight: FontWeight.w800),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Satu kuota harian Anda akan digunakan untuk mengambil makanan ini.',
              style: TextStyle(fontSize: 13, color: _kMuted),
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _kBgLight,
                border: Border.all(color: _kBorder),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.restaurant,
                    style: const TextStyle(
                      color: _kBrunswick,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.address,
                    style: const TextStyle(fontSize: 12, color: _kMuted),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Batas Ambil: ${item.deadline}',
                    style: const TextStyle(
                      color: _kTangerine,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Batal', style: TextStyle(color: _kMuted)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: _kTangerine),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Terbitkan Tiket QR'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (_) => const ClaimHistory()));
    }
  }
}

class _DotPatternPainter extends CustomPainter {
  const _DotPatternPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = _kBrunswick.withOpacity(0.12);
    for (double x = 10; x < size.width; x += 20) {
      for (double y = 10; y < size.height; y += 20) {
        canvas.drawCircle(Offset(x, y), 1.3, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DotPatternPainter oldDelegate) => false;
}
