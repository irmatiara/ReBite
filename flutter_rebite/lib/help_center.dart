import 'package:flutter/material.dart';

const Color _kDarkBrown = Color(0xFF2E2910);
const Color _kBrunswick = Color(0xFF2C5745);
const Color _kVanilla = Color(0xFFEBE3A7);
const Color _kTangerine = Color(0xFFEB7D00);
const Color _kBgLight = Color(0xFFF7F5EB);
const Color _kMuted = Color(0xFF736E58);
const Color _kBorder = Color(0xFFD1C9A0);

class _FaqItem {
  final String category;
  final String question;
  final String answer;

  const _FaqItem(this.category, this.question, this.answer);
}

const List<_FaqItem> _faqs = [
  _FaqItem(
    'kuota',
    'Bagaimana cara kerja limit kuota harian?',
    'Setiap akun Claimer mendapatkan batas maksimal 3 klaim makanan per hari. '
        'Limit ini bertujuan untuk menjamin keadilan distribusi agar seluruh '
        'masyarakat yang membutuhkan dapat menikmati manfaat surplus makanan. '
        'Kuota akan direset otomatis setiap pukul 00:00 WIB.',
  ),
  _FaqItem(
    'anonim',
    'Mengapa nama spesifik makanan disamarkan?',
    'Rebite menerapkan Prinsip Label Anonim (seperti Karbohidrat, Protein, '
        'Roti/Pastry) untuk menjaga privasi serta martabat penerima dan mitra '
        'restoran. Kebijakan ini juga efektif mencegah pemborosan selektif.',
  ),
  _FaqItem(
    'sidejob',
    'Bagaimana cara mendapatkan voucher dari Sidejob?',
    'Pilih Misi Sidejob Delivery di menu Sidejob, ambil makanan dari restoran, '
        'dan antarkan ke titik donasi. Setelah verifikasi lokasi selesai, poin '
        'reward dan voucher diskon akan masuk ke akunmu.',
  ),
  _FaqItem(
    'anonim',
    'Bagaimana jika makanan yang diterima kurang layak?',
    'Laporkan masalah kualitas melalui tombol Bantuan pada tiket klaim. Tim '
        'Quality Control Rebite akan meninjau laporan maksimal 1x24 jam dan '
        'memulihkan kuota klaim kamu.',
  ),
];

class HelpCenter extends StatefulWidget {
  const HelpCenter({super.key});

  @override
  State<HelpCenter> createState() => _HelpCenterState();
}

class _HelpCenterState extends State<HelpCenter> {
  static const Map<String, String> _categories = {
    'all': 'Semua Topik',
    'kuota': 'Limit Kuota',
    'anonim': 'Label Anonim',
    'sidejob': 'Sidejob Delivery',
  };

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _supportMessageController =
      TextEditingController();
  final GlobalKey<FormState> _supportFormKey = GlobalKey<FormState>();

  String _selectedCategory = 'all';
  String _supportCategory = 'Gagal Pindai QR Tiket';
  int? _expandedFaq;

  List<int> get _filteredFaqIndexes {
    final query = _searchController.text.trim().toLowerCase();
    return [
      for (var index = 0; index < _faqs.length; index++)
        if ((_selectedCategory == 'all' ||
                _faqs[index].category == _selectedCategory) &&
            (query.isEmpty ||
                _faqs[index].question.toLowerCase().contains(query) ||
                _faqs[index].answer.toLowerCase().contains(query)))
          index,
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    _supportMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredFaqIndexes;
    return Scaffold(
      backgroundColor: _kBgLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
                    children: [
                      TextField(
                        controller: _searchController,
                        onChanged: (_) => setState(() => _expandedFaq = null),
                        decoration: InputDecoration(
                          hintText: 'Cari topik bantuan atau kendala...',
                          hintStyle: const TextStyle(
                            color: _kMuted,
                            fontSize: 13,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: _kMuted,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 16,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: _kBorder),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: _kBrunswick),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _categories.entries.map((entry) {
                            final selected = _selectedCategory == entry.key;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(entry.value),
                                selected: selected,
                                onSelected: (_) => setState(() {
                                  _selectedCategory = entry.key;
                                  _expandedFaq = null;
                                }),
                                backgroundColor: Colors.white,
                                selectedColor: _kVanilla,
                                side: BorderSide(
                                  color: selected ? _kBrunswick : _kBorder,
                                ),
                                labelStyle: TextStyle(
                                  color: selected ? _kDarkBrown : _kMuted,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildPolicyCard(),
                      const SizedBox(height: 18),
                      const Text(
                        'PERTANYAAN SERING DIAJUKAN (FAQ)',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: _kMuted,
                          letterSpacing: 0.4,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (filtered.isEmpty)
                        _buildEmptyState()
                      else
                        ...filtered.map(
                          (index) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _buildFaqCard(index),
                          ),
                        ),
                      const SizedBox(height: 4),
                      _buildContactCard(),
                    ],
                  ),
                ),
              ),
            ),
          ],
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
                  'PUSAT INFORMASI',
                  style: TextStyle(
                    fontSize: 10,
                    color: _kVanilla,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Bantuan & Keamanan Pangan',
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

  Widget _buildPolicyCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _kBorder),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: Color(0x1A2C5745),
            child: Icon(Icons.shield_outlined, color: _kBrunswick),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jaminan Standar Higienis',
                  style: TextStyle(
                    fontSize: 13,
                    color: _kDarkBrown,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Setiap mitra restoran wajib mematuhi panduan Quality '
                  'Control Rebite. Makanan dikemas aman dan siap dikonsumsi.',
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

  Widget _buildFaqCard(int index) {
    final faq = _faqs[index];
    final isOpen = _expandedFaq == index;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _kBorder),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => setState(() => _expandedFaq = isOpen ? null : index),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      faq.question,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: _kDarkBrown,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isOpen ? Icons.keyboard_arrow_up : Icons.expand_more,
                    color: isOpen ? _kTangerine : _kMuted,
                  ),
                ],
              ),
            ),
          ),
          if (isOpen)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: const BoxDecoration(
                color: _kBgLight,
                border: Border(top: BorderSide(color: _kBorder)),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
              ),
              child: Text(
                faq.answer,
                style: const TextStyle(
                  fontSize: 12,
                  color: _kMuted,
                  height: 1.5,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _kBorder),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        children: [
          Icon(Icons.search_off, color: _kMuted, size: 28),
          SizedBox(height: 8),
          Text(
            'Topik bantuan tidak ditemukan.',
            style: TextStyle(
              fontSize: 13,
              color: _kMuted,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _kVanilla,
        border: Border.all(color: _kBorder),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text(
            'Masih Membutuhkan Bantuan?',
            style: TextStyle(
              fontSize: 15,
              color: _kDarkBrown,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Tim dukungan Rebite siap membantu kendala operasional, laporan '
            'makanan, atau pertanyaan seputar kemitraan.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: _kMuted, height: 1.4),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _openSupportDialog,
              icon: const Icon(Icons.chat_bubble_outline, size: 18),
              label: const Text('Hubungi Tim Kendala'),
              style: FilledButton.styleFrom(
                foregroundColor: _kVanilla,
                backgroundColor: _kBrunswick,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openSupportDialog() async {
    _supportMessageController.clear();
    final sent = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Kirim Laporan / Bantuan',
            style: TextStyle(
              color: _kDarkBrown,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Form(
            key: _supportFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _supportCategory,
                  decoration: _dialogFieldDecoration('Kategori Kendala'),
                  items: const [
                    'Gagal Pindai QR Tiket',
                    'Kualitas Makanan Tidak Sesuai',
                    'Kendala Misi Sidejob',
                    'Pertanyaan Akun / Pertanyaan Umum',
                  ]
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(
                            category,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setDialogState(() {
                    if (value != null) _supportCategory = value;
                  }),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _supportMessageController,
                  minLines: 3,
                  maxLines: 4,
                  decoration: _dialogFieldDecoration(
                    'Pesan / Laporan',
                    hint: 'Tuliskan detail kendala di sini...',
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Pesan wajib diisi'
                      : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Batal', style: TextStyle(color: _kMuted)),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: _kTangerine),
              onPressed: () {
                if (_supportFormKey.currentState?.validate() ?? false) {
                  Navigator.of(dialogContext).pop(true);
                }
              },
              child: const Text('Kirim Pesan'),
            ),
          ],
        ),
      ),
    );
    if (sent == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Laporan berhasil dikirim. Tim Rebite akan merespons melalui notifikasi/email.',
          ),
        ),
      );
    }
  }

  InputDecoration _dialogFieldDecoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(color: _kMuted, fontSize: 12),
      hintStyle: const TextStyle(color: _kMuted, fontSize: 12),
      filled: true,
      fillColor: _kBgLight,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
    );
  }
}
