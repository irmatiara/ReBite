import 'package:flutter/material.dart';

// Warna resmi ReBite
const Color _darkBrown = Color(0xFF2E2910);
const Color _brunswick = Color(0xFF2C5745);
const Color _vanilla = Color(0xFFEBE3A7);
const Color _vanillaSoft = Color(0xFFFAF7E8);
const Color _tangerine = Color(0xFFEB7D00);
const Color _background = Color(0xFFF7F5EB);
const Color _white = Color(0xFFFFFFFF);
const Color _muted = Color(0xFF736E58);
const Color _border = Color(0xFFD1C9A0);
const Color _red = Color(0xFFDC2626);

/// Halaman form Post Surplus Makanan.
/// Data hanya disimulasikan di sisi front-end, belum disimpan ke backend.
class FormPostSurplus extends StatefulWidget {
  const FormPostSurplus({super.key});

  @override
  State<FormPostSurplus> createState() => _FormPostSurplusState();
}

class _FormPostSurplusState extends State<FormPostSurplus> {
  final _formKey = GlobalKey<FormState>();
  final _quotaController = TextEditingController();
  final _discountController = TextEditingController();
  final _addressController = TextEditingController();
  final _rewardController = TextEditingController(
    text: 'Voucher Diskon Makanan 50%',
  );

  String _category = 'A';
  String _priceType = 'free';
  String _foodLabel = 'Karbohidrat & Protein';
  TimeOfDay _startTime = const TimeOfDay(hour: 18, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 20, minute: 0);

  final List<String> _foodLabels = const [
    'Karbohidrat & Protein',
    'Olahan Roti & Pastry',
    'Sayur & Buah Organik',
    'Makanan Siap Saji',
    'Sisa Organik / Pakan',
  ];

  String get _unit => _category == 'C'
      ? 'Kg'
      : _category == 'B'
          ? 'Box / Porsi'
          : 'Porsi';

  String get _categoryName {
    switch (_category) {
      case 'B':
        return 'Donasi Homeless + Sidejob';
      case 'C':
        return 'Pakan Ternak';
      default:
        return 'Free Food / Deep Discount';
    }
  }

  String _timeText(TimeOfDay time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  String _rupiah(String raw) {
    final amount = int.tryParse(raw) ?? 0;
    final formatted = amount.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => '.',
    );
    return 'Rp $formatted / ${_category == 'C' ? 'Kg' : 'Porsi'}';
  }

  @override
  void dispose() {
    _quotaController.dispose();
    _discountController.dispose();
    _addressController.dispose();
    _rewardController.dispose();
    super.dispose();
  }

  Future<void> _pickTime(bool isStart) async {
    final result = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: _brunswick,
            onPrimary: _vanilla,
            surface: _white,
            onSurface: _darkBrown,
          ),
        ),
        child: child!,
      ),
    );

    if (result == null || !mounted) return;
    setState(() {
      if (isStart) {
        _startTime = result;
      } else {
        _endTime = result;
      }
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final quantity = _quotaController.text.trim();
    final unit = _category == 'C' ? 'Kg' : 'Porsi';
    final price = _category == 'A' && _priceType == 'discount'
        ? _rupiah(_discountController.text.trim())
        : 'Gratis (Rp 0)';

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Dialog(
        backgroundColor: _white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: _border),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _brunswick.withValues(alpha: 0.12),
                    border: Border.all(color: _brunswick, width: 2),
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: _brunswick,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 13),
                const Text(
                  'Surplus Berhasil Diterbitkan!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _darkBrown,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Postingan berhasil dibuat dalam simulasi aplikasi.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: _muted, fontSize: 11),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _vanillaSoft,
                    border: Border.all(color: _border),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      _SummaryRow(label: 'Kategori', value: _categoryName),
                      _SummaryRow(label: 'Label Anonim', value: _foodLabel),
                      _SummaryRow(
                        label: 'Jumlah Stok',
                        value: '$quantity $unit',
                      ),
                      _SummaryRow(label: 'Harga', value: price),
                      _SummaryRow(
                        label: 'Waktu Pickup',
                        value:
                            '${_timeText(_startTime)} - ${_timeText(_endTime)} WIB',
                        isLast: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _brunswick,
                      foregroundColor: _vanilla,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Kembali ke Dashboard',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Header halaman
  Widget _header() {
    return Container(
      color: _brunswick,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.maybePop(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _white.withValues(alpha: 0.12),
                border: Border.all(color: _vanilla.withValues(alpha: 0.3)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back, color: _vanilla, size: 21),
            ),
          ),
          const SizedBox(width: 13),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Post Surplus Makanan',
                  style: TextStyle(
                    color: _white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Tambah porsi surplus untuk diselamatkan',
                  style: TextStyle(
                    color: _vanilla,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: _tangerine),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              title.toUpperCase(),
              style: const TextStyle(
                color: _darkBrown,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Kategori surplus A, B, dan C
  Widget _categoryCard({
    required String value,
    required IconData icon,
    required String title,
    required String description,
  }) {
    final active = _category == value;
    return InkWell(
      onTap: () => setState(() => _category = value),
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: active ? _vanillaSoft : _white,
          border: Border.all(
            color: active ? _tangerine : _border,
            width: active ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: active ? _tangerine : _background,
                border: Border.all(color: active ? _tangerine : _border),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: active ? _white : _brunswick,
                size: 21,
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: _darkBrown,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    description,
                    style: const TextStyle(
                      color: _muted,
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 19,
              height: 19,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: active ? _tangerine : Colors.transparent,
                border: Border.all(
                  color: active ? _tangerine : _border,
                  width: 2,
                ),
              ),
              child: active
                  ? const Icon(Icons.circle, size: 7, color: _white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  // Dekorasi semua input
  InputDecoration _decoration({
    required String hint,
    required IconData icon,
    String? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Color(0xFFA39D83),
        fontSize: 11,
        fontWeight: FontWeight.w500,
      ),
      prefixIcon: Icon(icon, color: _muted, size: 18),
      suffixText: suffix,
      suffixStyle: const TextStyle(
        color: _muted,
        fontSize: 10,
        fontWeight: FontWeight.w800,
      ),
      filled: true,
      fillColor: _white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 13,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _border, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _border, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _brunswick, width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _red, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _red, width: 1.5),
      ),
    );
  }

  Widget _categorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Pilih Kategori Surplus', Icons.layers_outlined),
        _categoryCard(
          value: 'A',
          icon: Icons.sell_outlined,
          title: 'Free Food / Deep Discount',
          description: 'Diambil langsung oleh Claimer di lokasi toko',
        ),
        const SizedBox(height: 9),
        _categoryCard(
          value: 'B',
          icon: Icons.local_shipping_outlined,
          title: 'Donasi Homeless + Sidejob',
          description: 'Diantar kurir sidejob ke titik lokasi tunawisma',
        ),
        const SizedBox(height: 9),
        _categoryCard(
          value: 'C',
          icon: Icons.eco_outlined,
          title: 'Pakan Ternak',
          description: 'Sisa bahan/organik diambil langsung Peternak',
        ),
      ],
    );
  }

  Widget _foodLabelField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Label Makanan Anonim', Icons.sell_outlined),
        DropdownButtonFormField<String>(
  initialValue: _foodLabel,
          isExpanded: true,
          decoration: _decoration(
            hint: 'Pilih label makanan',
            icon: Icons.description_outlined,
          ),
          items: _foodLabels
              .map(
                (label) => DropdownMenuItem<String>(
                  value: label,
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _darkBrown,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) setState(() => _foodLabel = value);
          },
        ),
      ],
    );
  }

  Widget _privacyNotice() {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: _vanillaSoft,
        border: const Border(
          left: BorderSide(color: _brunswick, width: 3),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lock_outline, color: _brunswick, size: 18),
          SizedBox(width: 9),
          Expanded(
            child: Text(
              'Sesuai aturan ReBite, isi spesifik makanan tidak disebutkan demi menjaga kejutan dan kerahasiaan.',
              style: TextStyle(
                color: _darkBrown,
                fontSize: 9,
                fontWeight: FontWeight.w600,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quotaField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Batas Kuota Surplus', Icons.add_circle_outline),
        TextFormField(
          controller: _quotaController,
          keyboardType: TextInputType.number,
          decoration: _decoration(
            hint: 'Masukkan jumlah stok',
            icon: Icons.inventory_2_outlined,
            suffix: _unit,
          ),
          validator: (value) {
            final amount = int.tryParse(value?.trim() ?? '');
            if (amount == null || amount < 1) {
              return 'Masukkan jumlah minimal 1.';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _priceTypeButton(String label, String value, IconData icon) {
    final active = _priceType == value;
    return Expanded(
      child: ElevatedButton(
        onPressed: () => setState(() => _priceType = value),
        style: ElevatedButton.styleFrom(
          backgroundColor: active ? _brunswick : Colors.transparent,
          foregroundColor: active ? _vanilla : _muted,
          elevation: active ? 2 : 0,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 11),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 15),
              const SizedBox(width: 5),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _priceSection() {
    if (_category != 'A') return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Tipe Harga', Icons.payments_outlined),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: _vanilla,
            border: Border.all(color: _border),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              _priceTypeButton(
                'Gratis (Rp 0)',
                'free',
                Icons.card_giftcard_outlined,
              ),
              const SizedBox(width: 4),
              _priceTypeButton(
                'Deep Discount',
                'discount',
                Icons.percent,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _discountField() {
    if (_category != 'A' || _priceType != 'discount') {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel(
          'Harga Discount per Porsi (Rp)',
          Icons.payments_outlined,
        ),
        TextFormField(
          controller: _discountController,
          keyboardType: TextInputType.number,
          decoration: _decoration(
            hint: 'Contoh: 10000',
            icon: Icons.currency_exchange,
          ),
          validator: (value) {
            if (_category != 'A' || _priceType != 'discount') return null;
            final amount = int.tryParse(value?.trim() ?? '');
            if (amount == null || amount < 1000) {
              return 'Harga discount minimal Rp 1.000.';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _timeField(String label, TimeOfDay time, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: InputDecorator(
          decoration: _decoration(
            hint: label,
            icon: Icons.access_time,
          ),
          child: Text(
            _timeText(time),
            style: const TextStyle(
              color: _darkBrown,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _pickupTimeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel(
          'Waktu Pengambilan / Pickup Window',
          Icons.access_time,
        ),
        Row(
          children: [
            _timeField(
              'Mulai',
              _startTime,
              () => _pickTime(true),
            ),
            const SizedBox(width: 10),
            _timeField(
              'Selesai',
              _endTime,
              () => _pickTime(false),
            ),
          ],
        ),
      ],
    );
  }

  Widget _sidejobSection() {
    if (_category != 'B') return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: _white,
        border: Border.all(color: _tangerine),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.local_shipping_outlined,
                color: _tangerine,
                size: 17,
              ),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Atur Detail Kurir Sidejob',
                  style: TextStyle(
                    color: _tangerine,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          _sectionLabel(
            'Target Alamat Titik Homeless',
            Icons.location_on_outlined,
          ),
          TextFormField(
            controller: _addressController,
            decoration: _decoration(
              hint: 'Panti Asuhan / Titik Tunawisma Medan Kota',
              icon: Icons.location_on_outlined,
            ),
          ),
          const SizedBox(height: 12),
          _sectionLabel('Reward Kurir Sidejob', Icons.workspace_premium_outlined),
          TextFormField(
            controller: _rewardController,
            decoration: _decoration(
              hint: 'Masukkan reward kurir',
              icon: Icons.card_giftcard_outlined,
            ),
          ),
        ],
      ),
    );
  }

  Widget _submitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _submit,
        icon: const Icon(Icons.arrow_forward, size: 18),
        label: const Text(
          'Terbitkan Surplus Makanan',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.15,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: _tangerine,
          foregroundColor: _white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  void _bottomNavTap(int index) {
    if (index == 0) {
      Navigator.maybePop(context);
    } else if (index != 1) {
      final feature = index == 2
          ? 'Sidejob'
          : index == 3
              ? 'Riwayat'
              : 'Profil';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Halaman $feature belum dihubungkan.'),
          backgroundColor: _brunswick,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _bottomNavigation() {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: _white,
        border: Border(top: BorderSide(color: _border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _NavItem(
              icon: Icons.dashboard_outlined,
              label: 'Dashboard',
              onTap: () => _bottomNavTap(0),
            ),
          ),
          Expanded(
            child: _NavItem(
              icon: Icons.add_circle_outline,
              label: 'Post Surplus',
              active: true,
              onTap: () => _bottomNavTap(1),
            ),
          ),
          Expanded(
            child: _NavItem(
              icon: Icons.work_outline,
              label: 'Sidejob',
              onTap: () => _bottomNavTap(2),
            ),
          ),
          Expanded(
            child: _NavItem(
              icon: Icons.history,
              label: 'Riwayat',
              onTap: () => _bottomNavTap(3),
            ),
          ),
          Expanded(
            child: _NavItem(
              icon: Icons.person_outline,
              label: 'Profil',
              onTap: () => _bottomNavTap(4),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final desktop = constraints.maxWidth > 440;
              final width = desktop ? 440.0 : constraints.maxWidth;
              final radius = desktop ? 28.0 : 0.0;

              return Container(
                width: width,
                height: constraints.maxHeight,
                decoration: BoxDecoration(
                  color: _background,
                  borderRadius: BorderRadius.circular(radius),
                  border: desktop ? Border.all(color: _border) : null,
                  boxShadow: desktop
                      ? [
                          BoxShadow(
                            color: _darkBrown.withValues(alpha: 0.10),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ]
                      : [],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(radius),
                  child: Column(
                    children: [
                      _header(),
                      Expanded(
                        child: Form(
                          key: _formKey,
                          child: ListView(
                            padding: const EdgeInsets.fromLTRB(18, 16, 18, 22),
                            children: [
                              _categorySection(),
                              const SizedBox(height: 18),
                              _foodLabelField(),
                              const SizedBox(height: 12),
                              _privacyNotice(),
                              const SizedBox(height: 18),
                              _quotaField(),
                              const SizedBox(height: 18),
                              _priceSection(),
                              if (_category == 'A' && _priceType == 'discount') ...[
                                const SizedBox(height: 14),
                                _discountField(),
                              ],
                              const SizedBox(height: 18),
                              _pickupTimeSection(),
                              if (_category == 'B') ...[
                                const SizedBox(height: 18),
                                _sidejobSection(),
                              ],
                              const SizedBox(height: 22),
                              _submitButton(),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                      _bottomNavigation(),
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

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: _muted,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: _darkBrown,
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

class _NavItem extends StatelessWidget {
  const _NavItem({
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
    final color = active ? _tangerine : _muted;
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 21, color: color),
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
    );
  }
}
