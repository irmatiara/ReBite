import 'package:flutter/material.dart';

import 'sidejob_missions.dart';

const Color _kDarkBrown = Color(0xFF2E2910);
const Color _kBrunswick = Color(0xFF2C5745);
const Color _kVanilla = Color(0xFFEBE3A7);
const Color _kTangerine = Color(0xFFEB7D00);
const Color _kBgLight = Color(0xFFF7F5EB);
const Color _kMuted = Color(0xFF736E58);
const Color _kBorder = Color(0xFFD1C9A0);

class SidejobRegister extends StatefulWidget {
  const SidejobRegister({super.key});

  @override
  State<SidejobRegister> createState() => _SidejobRegisterState();
}

class _SidejobRegisterState extends State<SidejobRegister> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey _formCardKey = GlobalKey();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _whatsAppController = TextEditingController();
  final TextEditingController _plateController = TextEditingController();

  String? _transport;
  String? _area;
  bool _agreedToTerms = false;

  bool get _needsPlate => _transport == 'motor';

  @override
  void dispose() {
    _nikController.dispose();
    _whatsAppController.dispose();
    _plateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBgLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                  children: [
                    _buildNotice(),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _buildBenefit(
                            Icons.star_outline,
                            'Bonus Poin & Voucher',
                            'Tukarkan poin perjalanan dengan potongan harga makanan.',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildBenefit(
                            Icons.shield_outlined,
                            'Aksi Dampak Sosial',
                            'Bantu selamatkan makanan ke lokasi panti atau komunitas.',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'FORMULIR PENDAFTARAN KURIR',
                      style: TextStyle(
                        fontSize: 11,
                        color: _kMuted,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    KeyedSubtree(
                      key: _formCardKey,
                      child: _buildFormCard(),
                    ),
                  ],
                ),
              ),
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
          child: SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.arrow_forward, size: 18),
              label: const Text('Kirim Pendaftaran Kurir'),
              style: FilledButton.styleFrom(
                foregroundColor: _kVanilla,
                backgroundColor: _kBrunswick,
                padding: const EdgeInsets.symmetric(vertical: 15),
                textStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: _kBrunswick,
      padding: const EdgeInsets.fromLTRB(16, 16, 20, 16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            style: IconButton.styleFrom(
              backgroundColor: const Color(0x26EBE3A7),
              side: const BorderSide(color: _kVanilla),
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'VERIFIKASI TAMBAHAN',
                  style: TextStyle(
                    fontSize: 10,
                    color: _kVanilla,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Pendaftaran Kurir Sidejob',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
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

  Widget _buildNotice() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _kTangerine, width: 1.4),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: Color(0x1FEB7D00),
            child: Icon(Icons.local_shipping_outlined, color: _kTangerine),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Akses Khusus Kurir Relawan',
                  style: TextStyle(
                    fontSize: 13,
                    color: _kDarkBrown,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Fitur Misi Sidejob memerlukan pendaftaran data diri ringan '
                  'untuk memastikan keamanan makanan saat diantarkan ke titik '
                  'donasi sasaran.',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: _kMuted,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefit(IconData icon, String title, String description) {
    return Container(
      constraints: const BoxConstraints(minHeight: 128),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _kBorder),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: _kBrunswick, size: 20),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: _kDarkBrown,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(fontSize: 10, height: 1.35, color: _kMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _kBorder),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _buildTextField(
            label: 'Nomor Induk Kependudukan (NIK / KTP)',
            controller: _nikController,
            hint: 'Masukkan 16 digit NIK',
            keyboardType: TextInputType.number,
            maxLength: 16,
            validator: (value) {
              final nik = value?.trim() ?? '';
              if (!RegExp(r'^\d{16}$').hasMatch(nik)) {
                return 'NIK harus terdiri dari 16 digit angka';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          _buildTextField(
            label: 'Nomor WhatsApp Aktif',
            controller: _whatsAppController,
            hint: '08xxxxxxxxxx',
            keyboardType: TextInputType.phone,
            validator: (value) {
              final phone = value?.trim() ?? '';
              if (!RegExp(r'^\+?\d{9,15}$').hasMatch(phone)) {
                return 'Masukkan nomor WhatsApp yang valid';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          _buildSelectField<String>(
            label: 'Moda Transportasi Pengantaran',
            value: _transport,
            hint: '-- Pilih Kendaraan --',
            items: const [
              DropdownMenuItem(value: 'motor', child: Text('Sepeda Motor')),
              DropdownMenuItem(
                value: 'sepeda',
                child: Text('Sepeda Ontel / Listrik'),
              ),
              DropdownMenuItem(
                value: 'jalan',
                child: Text('Jalan Kaki (Jarak Dekat < 1km)'),
              ),
            ],
            onChanged: (value) => setState(() {
              _transport = value;
              if (!_needsPlate) _plateController.clear();
            }),
            validator: (value) =>
                value == null ? 'Pilih moda transportasi' : null,
          ),
          if (_needsPlate) ...[
            const SizedBox(height: 14),
            _buildTextField(
              label: 'Nomor Plat Kendaraan',
              controller: _plateController,
              hint: 'Contoh: BK 1234 ABC',
              textCapitalization: TextCapitalization.characters,
              validator: (value) {
                if (_needsPlate && (value?.trim().isEmpty ?? true)) {
                  return 'Nomor plat kendaraan wajib diisi';
                }
                return null;
              },
            ),
          ],
          const SizedBox(height: 14),
          _buildSelectField<String>(
            label: 'Area / Kecamatan Utama Pengantaran',
            value: _area,
            hint: '-- Pilih Wilayah Operasional --',
            items: const [
              DropdownMenuItem(
                value: 'medan_kota',
                child: Text('Medan Kota & Sekitarnya'),
              ),
              DropdownMenuItem(
                value: 'medan_petisah',
                child: Text('Medan Petisah / Gajah Mada'),
              ),
              DropdownMenuItem(
                value: 'medan_baru',
                child: Text('Medan Baru / Kampus'),
              ),
              DropdownMenuItem(
                value: 'medan_sunggal',
                child: Text('Medan Sunggal'),
              ),
            ],
            onChanged: (value) => setState(() => _area = value),
            validator: (value) =>
                value == null ? 'Pilih wilayah operasional' : null,
          ),
          const SizedBox(height: 8),
          Material(
            color: Colors.white,
            child: CheckboxListTile(
              value: _agreedToTerms,
              onChanged: (value) =>
                  setState(() => _agreedToTerms = value ?? false),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: _kBrunswick,
              title: const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text:
                          'Saya bersedia menjaga kebersihan, ketepatan waktu, '
                          'dan integritas makanan saat menjalankan ',
                    ),
                    TextSpan(
                      text: 'Misi Sidejob Delivery.',
                      style: TextStyle(
                        color: _kDarkBrown,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                style: TextStyle(fontSize: 11, color: _kMuted, height: 1.4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    int? maxLength,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel(label),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          maxLength: maxLength,
          validator:
              validator ??
              (value) =>
                  value == null || value.trim().isEmpty ? 'Wajib diisi' : null,
          decoration: _inputDecoration(hint),
        ),
      ],
    );
  }

  Widget _buildSelectField<T>({
    required String label,
    required T? value,
    required String hint,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    required String? Function(T?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel(label),
        const SizedBox(height: 6),
        DropdownButtonFormField<T>(
          initialValue: value,
          validator: validator,
          items: items,
          onChanged: onChanged,
          decoration: _inputDecoration(null),
          hint: Text(
            hint,
            style: const TextStyle(color: _kMuted, fontSize: 12),
          ),
          isExpanded: true,
        ),
      ],
    );
  }

  Widget _fieldLabel(String label) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        fontSize: 10,
        color: _kMuted,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  InputDecoration _inputDecoration(String? hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: _kMuted, fontSize: 12),
      filled: true,
      fillColor: _kBgLight,
      counterText: '',
      contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _kBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _kBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _kBrunswick),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi data pendaftaran yang wajib.')),
      );
      final formContext = _formCardKey.currentContext;
      if (formContext != null) {
        Scrollable.ensureVisible(
          formContext,
          duration: const Duration(milliseconds: 300),
          alignment: 0.1,
        );
      }
      return;
    }
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Setujui komitmen kurir sebelum melanjutkan.'),
        ),
      );
      return;
    }
    _showSuccessDialog();
  }

  Future<void> _showSuccessDialog() async {
    final startMissions = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundColor: Color(0x1A2C5745),
              child: Icon(Icons.check, color: _kBrunswick, size: 32),
            ),
            const SizedBox(height: 14),
            const Text(
              'Verifikasi Berhasil!',
              style: TextStyle(
                color: _kDarkBrown,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Selamat, akun Anda telah terverifikasi sebagai Kurir Relawan '
              'Rebite. Anda kini dapat mengambil misi pengantaran donasi makanan.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, height: 1.45, color: _kMuted),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: _kTangerine,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                ),
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: const Text('Mulai Ambil Misi Pertama'),
              ),
            ),
          ],
        ),
      ),
    );

    if (startMissions == true && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const SidejobMissions()),
      );
    }
  }
}
