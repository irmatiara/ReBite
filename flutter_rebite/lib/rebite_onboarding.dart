import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'rebite_login.dart';
import 'rebite_partner_claimer_signup.dart';

// ============================================================================
// 1. PALET WARNA RESMI REBITE (Sesuai file rebite_onboarding.html)
// ============================================================================
const Color kDarkBrown = Color(0xFF2E2910);
const Color kBrunswick = Color(0xFF2C5745);
const Color kBrunswickDark = Color(0xFF1E3F32);
const Color kVanilla = Color(0xFFEBE3A7);
const Color kVanillaSoft = Color(0xFFFAF7E8);
const Color kTangerine = Color(0xFFEB7D00);
const Color kBgLight = Color(0xFFF7F5EB);
const Color kWhite = Color(0xFFFFFFFF);
const Color kMuted = Color(0xFF736E58);
const Color kBorder = Color(0xFFD1C9A0);

// ============================================================================
// 2. HALAMAN UTAMA ONBOARDING (Single File)
// ============================================================================
class RebiteOnboarding extends StatefulWidget {
  const RebiteOnboarding({super.key});

  @override
  State<RebiteOnboarding> createState() => _RebiteOnboardingState();
}

class _RebiteOnboardingState extends State<RebiteOnboarding> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Data 3 Slide Onboarding (Sesuai rebite_onboarding.html)
  final List<OnboardingSlideItemModel> _slides = const [
    OnboardingSlideItemModel(
      stepTag: 'Langkah 01 / 03',
      badgeText: 'Food Rescue',
      titleNormal: 'Selamatkan Makanan\n',
      titleHighlight: 'Surplus Terbaik',
      description:
          'Hubungkan pencari makanan dengan restoran partner yang memiliki sisa makanan layak makan dengan diskon besar atau gratis.',
      features: [
        {'icon': Icons.rice_bowl_rounded, 'label': 'Karbo & Lauk'},
        {'icon': Icons.bakery_dining_rounded, 'label': 'Roti & Pastry'},
        {'icon': Icons.eco_rounded, 'label': 'Sayur Segar'},
        {'icon': Icons.pets_rounded, 'label': 'Pakan Ternak'},
      ],
    ),
    OnboardingSlideItemModel(
      stepTag: 'Langkah 02 / 03',
      badgeText: 'Adil & Anonim',
      titleNormal: 'Label Anonim &\n',
      titleHighlight: 'Batas Kuota',
      description:
          'Privasi kualitas terjamin dengan label kategori anonim. Sistem limit klaim harian memastikan distribusi makanan merata.',
      features: [
        {'icon': Icons.lock_rounded, 'label': 'Privasi Terjamin'},
        {'icon': Icons.timer_outlined, 'label': 'Batas 3 Klaim/Hari'},
        {'icon': Icons.verified_user_rounded, 'label': 'Standar Higienis'},
        {'icon': Icons.balance_rounded, 'label': 'Pemerataan Hak'},
      ],
    ),
    OnboardingSlideItemModel(
      stepTag: 'Langkah 03 / 03',
      badgeText: 'Delivery Sidejob',
      titleNormal: 'Bantu Antar &\n',
      titleHighlight: 'Dapatkan Reward',
      description:
          'Jadilah kurir relawan untuk mengantarkan donasi makanan ke titik panti/homeless dan dapatkan poin serta voucher diskon.',
      features: [
        {'icon': Icons.delivery_dining_rounded, 'label': 'Misi Volunteer'},
        {'icon': Icons.confirmation_num_rounded, 'label': 'Voucher Diskon'},
        {'icon': Icons.volunteer_activism_rounded, 'label': 'Donasi Tunawisma'},
        {'icon': Icons.stars_rounded, 'label': 'Poin Amal'},
      ],
    ),
  ];

  // Tombol Selanjutnya: Berpindah slide atau ke halaman login
  void _onNextPressed() {
    if (_currentPage < _slides.length - 1) {
      final nextIndex = _currentPage + 1;
      setState(() {
        _currentPage = nextIndex;
      });
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 380),
          curve: Curves.easeInOutCubic,
        );
      }
    } else {
      _navigateToLogin();
    }
  }

  // Navigasi ke Halaman Login (Navigator.push)
  void _navigateToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(
        settings: const RouteSettings(name: '/login'),
        builder: (context) => const RebiteLoginPage(),
      ),
    );
  }

  // Navigasi ke Halaman Registrasi (Navigator.push)
  void _navigateToSignup() {
    // Tampilkan pilihan jenis akun (Mitra Restoran atau Claimer)
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: kBgLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Pilih Jenis Akun',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            color: kDarkBrown,
          ),
        ),
        content: Text(
          'Silakan pilih jenis akun yang ingin Anda daftarkan.',
          style: GoogleFonts.plusJakartaSans(color: kMuted),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  settings: const RouteSettings(name: '/partner-signup'),
                  builder: (_) => const RebitePartnerClaimerSignupPage(initialRole: 'resto'),
                ),
              );
            },
            child: Text(
              'Mitra Restoran',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                color: kBrunswick,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  settings: const RouteSettings(name: '/claimer-signup'),
                  builder: (_) => const RebitePartnerClaimerSignupPage(initialRole: 'claimer'),
                ),
              );
            },
            child: Text(
              'Claimer',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                color: kTangerine,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Berpindah ke slide tertentu via klik titik (dot)
  void _goToSlide(int index) {
    setState(() {
      _currentPage = index;
    });
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 5. Responsive Design: Menggunakan MediaQuery & LayoutBuilder
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    // 1. Struktur Aplikasi: Scaffold
    return Scaffold(
      backgroundColor: const Color(0xFFE2DFD2), // Latar luar kanvas
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isLargeScreen = constraints.maxWidth > 480;

          // 3. Layout dasar: Center & Container
          return Center(
            child: Container(
              width: isLargeScreen ? 440 : double.infinity,
              height: isLargeScreen && !isLandscape ? 840 : double.infinity,
              decoration: BoxDecoration(
                color: kBgLight,
                borderRadius: isLargeScreen ? BorderRadius.circular(32) : BorderRadius.zero,
                border: isLargeScreen ? Border.all(color: kBorder, width: 1.2) : null,
                boxShadow: isLargeScreen
                    ? const [
                        BoxShadow(
                          color: Color(0x262E2910),
                          blurRadius: 40,
                          offset: Offset(0, 18),
                        ),
                      ]
                    : null,
              ),
              child: ClipRRect(
                borderRadius: isLargeScreen ? BorderRadius.circular(32) : BorderRadius.zero,
                // 3. Multi-Child Widgets: Stack
                child: Stack(
                  children: [
                    // Gradasi Ambient Lingkaran Latar Belakang (Decor Blobs)
                    const IgnorePointer(
                      child: Stack(
                        children: [
                          OnboardingDecorBlob(
                            alignment: Alignment.topRight,
                            size: 240,
                            color: Color(0x28EB7D00),
                          ),
                          OnboardingDecorBlob(
                            alignment: Alignment.bottomLeft,
                            size: 260,
                            color: Color(0x202C5745),
                          ),
                        ],
                      ),
                    ),

                    // Konten Utama Onboarding
                    SafeArea(
                      // 3. Multi-Child Widgets: Column
                      child: Column(
                        children: [
                          // 1. Top Bar Navigasi (Logo & Tombol Lewati)
                          OnboardingTopBar(onSkip: _navigateToLogin),

                          // 2. Area Tengah: PageView Carousel
                          // 3. Multi-Child Widgets: Expanded & Carousel
                          Expanded(
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: _slides.length,
                              onPageChanged: (index) {
                                if (_currentPage != index) {
                                  setState(() {
                                    _currentPage = index;
                                  });
                                }
                              },
                              itemBuilder: (context, index) {
                                return OnboardingSlideView(
                                  slide: _slides[index],
                                  slideIndex: index,
                                );
                              },
                            ),
                          ),

                          // 3. Footer Kontrol (Dots & Tombol Aksi)
                          OnboardingFooterControls(
                            currentPage: _currentPage,
                            totalPages: _slides.length,
                            onDotTap: _goToSlide,
                            onPrimaryPressed: _onNextPressed,
                            onSecondaryPressed: _navigateToSignup,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ============================================================================
// 3. MODEL DATA & REUSABLE WIDGETS (StatelessWidget)
// ============================================================================

/// Model Data Konten Slide
class OnboardingSlideItemModel {
  final String stepTag;
  final String badgeText;
  final String titleNormal;
  final String titleHighlight;
  final String description;
  final List<Map<String, dynamic>> features;

  const OnboardingSlideItemModel({
    required this.stepTag,
    required this.badgeText,
    required this.titleNormal,
    required this.titleHighlight,
    required this.description,
    required this.features,
  });
}

/// 1 & 2. Reusable Widget: Top Bar dengan CircleAvatar, Image, Text, dan Tombol Lewati
class OnboardingTopBar extends StatelessWidget {
  final VoidCallback onSkip;

  const OnboardingTopBar({super.key, required this.onSkip});

  @override
  Widget build(BuildContext context) {
    // 3. Single-Child Widget: Padding & Multi-Child: Row
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo & Nama Brand
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: kBorder, width: 2),
                ),
                // 2. Komponen Dasar: CircleAvatar & Image
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: kVanilla,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 36,
                      height: 36,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.restaurant_rounded,
                        size: 20,
                        color: kBrunswick,
                      ),
                    ),
                  ),
                ),
              ),
              // 3. Single-Child Widget: SizedBox
              const SizedBox(width: 10),
              // 2. Komponen Dasar: Text
              Text(
                'ReBite',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: kDarkBrown,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),

          // Tombol Lewati (Skip)
          TextButton(
            onPressed: onSkip,
            style: TextButton.styleFrom(
              backgroundColor: kMuted.withValues(alpha: 0.12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Text(
              'Lewati',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
                color: kDarkBrown,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 1 & 2. Reusable Widget: Tampilan Satu Slide Onboarding (Persis HTML .slide)
class OnboardingSlideView extends StatelessWidget {
  final OnboardingSlideItemModel slide;
  final int slideIndex;

  const OnboardingSlideView({
    super.key,
    required this.slide,
    required this.slideIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Column(
        children: [
          // 1. Kartu Ilustrasi Utama (Mengisi ruang proporsional, besar, dan fleksibel)
          Expanded(
            flex: 6,
            child: OnboardingIllustrationBox(
              slideIndex: slideIndex,
              badgeText: slide.badgeText,
            ),
          ),
          const SizedBox(height: 18),

          // 2. Slide Text Box (Tag, Judul, Deskripsi sesuai HTML)
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Tag Langkah (Langkah 01 / 03)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: kTangerine.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    slide.stepTag.toUpperCase(),
                    style: GoogleFonts.plusJakartaSans(
                      color: kTangerine,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // RichText: Judul Slide (Playfair Display / Serif Italic)
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: kDarkBrown,
                      height: 1.25,
                    ),
                    children: [
                      TextSpan(text: slide.titleNormal),
                      TextSpan(
                        text: slide.titleHighlight,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.italic,
                          color: kBrunswick,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Paragraf Deskripsi
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    slide.description,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: kMuted,
                      fontWeight: FontWeight.w500,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 1 & 2. Reusable Widget: GridView 2x2 Pilar Fitur
class OnboardingFeatureGrid extends StatelessWidget {
  final List<Map<String, dynamic>> features;

  const OnboardingFeatureGrid({super.key, required this.features});

  @override
  Widget build(BuildContext context) {
    // 3. Multi-Child Widget: GridView
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 6),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: features.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 3.5,
        ),
        itemBuilder: (context, index) {
          final item = features[index];
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: kBorder.withValues(alpha: 0.6)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item['icon'] as IconData,
                  size: 14,
                  color: kBrunswick,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    item['label'] as String,
                    style: GoogleFonts.plusJakartaSans(
                      color: kDarkBrown,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// 1 & 2. Reusable Widget: Kartu Ilustrasi Utama Onboarding
class OnboardingIllustrationBox extends StatelessWidget {
  final int slideIndex;
  final String badgeText;

  const OnboardingIllustrationBox({
    super.key,
    required this.slideIndex,
    required this.badgeText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: kBorder, width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x122E2910),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Pola Titik Dot Grid Background
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: CustomPaint(
                painter: _DotGridPainter(),
              ),
            ),
          ),

          // Motif Organik di Sudut
          Positioned(
            left: 14,
            top: 14,
            child: Icon(
              Icons.eco_rounded,
              size: 26,
              color: kBorder.withValues(alpha: 0.5),
            ),
          ),
          Positioned(
            right: 14,
            bottom: 14,
            child: Icon(
              Icons.spa_rounded,
              size: 30,
              color: kBorder.withValues(alpha: 0.4),
            ),
          ),

          // Badge Kategori (Kanan Atas)
          Positioned(
            top: 14,
            right: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: kTangerine,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x38EB7D00),
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                badgeText,
                style: GoogleFonts.plusJakartaSans(
                  color: kWhite,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                ),
              ),
            ),
          ),

          // Visual Vektor di Tengah Kartu (Skala Proporsional)
          Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: _buildVisual(slideIndex),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisual(int index) {
    if (index == 0) {
      // Slide 1: Tas Makanan Eco-Bag ReBite
      return SizedBox(
        width: 200,
        height: 180,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kVanilla.withValues(alpha: 0.45),
              ),
            ),
            // Makanan menyembul dari tas
            Positioned(
              top: 20,
              left: 65,
              child: Container(
                width: 22,
                height: 55,
                decoration: BoxDecoration(
                  color: const Color(0xFFD2B48C),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: kDarkBrown, width: 2),
                ),
                child: const Icon(Icons.bakery_dining_rounded, size: 14, color: Color(0xFF8B4513)),
              ),
            ),
            Positioned(
              top: 14,
              right: 60,
              child: Transform.rotate(
                angle: 0.2,
                child: Container(
                  width: 16,
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCD7F32),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: kDarkBrown, width: 2),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 32,
              right: 44,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF228B22),
                  border: Border.all(color: kDarkBrown, width: 1.5),
                ),
                child: const Icon(Icons.grass_rounded, size: 18, color: Colors.white),
              ),
            ),
            Positioned(
              top: 42,
              left: 46,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kTangerine,
                  border: Border.all(color: kDarkBrown, width: 1.5),
                ),
                child: const Icon(Icons.agriculture_rounded, size: 14, color: Colors.white),
              ),
            ),
            // Badan Tas Kanvas
            Positioned(
              bottom: 20,
              child: Container(
                width: 105,
                height: 82,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5D9B6),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                  border: Border.all(color: kDarkBrown, width: 3),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: -14,
                      child: Container(
                        width: 46,
                        height: 28,
                        decoration: BoxDecoration(
                          border: Border.all(color: kBrunswick, width: 4),
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                    const CircleAvatar(
                      radius: 18,
                      backgroundColor: kBrunswick,
                      child: Icon(Icons.restaurant_rounded, size: 18, color: kVanilla),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else if (index == 1) {
      // Slide 2: Perlindungan Privasi (Vault) & Batas Kuota 3/3
      return SizedBox(
        width: 200,
        height: 180,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kVanilla.withValues(alpha: 0.45),
              ),
            ),
            Positioned(
              bottom: 24,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: -32,
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        border: Border.all(color: kBrunswick, width: 5.5),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(26),
                          topRight: Radius.circular(26),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 104,
                    height: 80,
                    decoration: BoxDecoration(
                      color: kWhite,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: kDarkBrown, width: 3),
                    ),
                    child: Center(
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: kTangerine.withValues(alpha: 0.14),
                          border: Border.all(color: kDarkBrown, width: 2),
                        ),
                        child: const Icon(Icons.key_rounded, color: kDarkBrown, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Badge Anonim
            Positioned(
              left: 14,
              bottom: 46,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: kTangerine,
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(color: kDarkBrown, width: 1.5),
                ),
                child: Text(
                  'ANONIM',
                  style: GoogleFonts.plusJakartaSans(
                    color: kWhite,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            // Lingkaran Kuota 3/3
            Positioned(
              right: 14,
              top: 42,
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: kVanilla,
                  shape: BoxShape.circle,
                  border: Border.all(color: kDarkBrown, width: 2),
                ),
                child: Center(
                  child: Text(
                    '3/3',
                    style: GoogleFonts.plusJakartaSans(
                      color: kDarkBrown,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      // Slide 3: Truk Kurir Relawan & Voucher Poin
      return SizedBox(
        width: 200,
        height: 180,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kVanilla.withValues(alpha: 0.45),
              ),
            ),
            // Garis Lintasan Putus-Putus
            Positioned(
              bottom: 48,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  8,
                  (i) => Container(
                    width: 10,
                    height: 3,
                    decoration: BoxDecoration(
                      color: kBorder,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ),
            // Truk Pengantaran
            Positioned(
              bottom: 40,
              child: SizedBox(
                width: 135,
                height: 70,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      bottom: 10,
                      child: Container(
                        width: 74,
                        height: 50,
                        decoration: BoxDecoration(
                          color: kBrunswick,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: kDarkBrown, width: 2.5),
                        ),
                        child: const Center(
                          child: Icon(Icons.volunteer_activism_rounded, size: 22, color: kVanilla),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 12,
                      bottom: 10,
                      child: Container(
                        width: 46,
                        height: 40,
                        decoration: BoxDecoration(
                          color: kWhite,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(14),
                            bottomRight: Radius.circular(6),
                            topLeft: Radius.circular(6),
                          ),
                          border: Border.all(color: kDarkBrown, width: 2.5),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      bottom: 0,
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: kVanilla,
                          shape: BoxShape.circle,
                          border: Border.all(color: kDarkBrown, width: 2.5),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 26,
                      bottom: 0,
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: kVanilla,
                          shape: BoxShape.circle,
                          border: Border.all(color: kDarkBrown, width: 2.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Badge Reward Poin
            Positioned(
              right: 20,
              top: 24,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: kTangerine,
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(color: kDarkBrown, width: 1.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded, size: 12, color: Colors.white),
                    const SizedBox(width: 3),
                    Text(
                      '+POIN',
                      style: GoogleFonts.plusJakartaSans(
                        color: kWhite,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
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
  }
}

/// 1 & 2. Reusable Widget: Footer Kontrol (Dots & Tombol Navigasi)
class OnboardingFooterControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onDotTap;
  final VoidCallback onPrimaryPressed;
  final VoidCallback onSecondaryPressed;

  const OnboardingFooterControls({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onDotTap,
    required this.onPrimaryPressed,
    required this.onSecondaryPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isLastPage = currentPage == totalPages - 1;

    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24, top: 8),
      color: kBgLight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Titik Indikator Slider (Dots)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              totalPages,
              (index) => GestureDetector(
                onTap: () => onDotTap(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: index == currentPage ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: index == currentPage ? kBrunswick : kBorder,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Tombol Utama ("Selanjutnya" atau "Mulai Sekarang")
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPrimaryPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: kBrunswick,
                foregroundColor: kVanilla,
                elevation: 4,
                shadowColor: const Color(0x402C5745),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isLastPage ? 'Mulai Sekarang' : 'Selanjutnya',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_rounded, size: 20),
                ],
              ),
            ),
          ),

          // Tombol Sekunder ("Daftar Akun Baru" - Hanya aktif di slide terakhir)
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: isLastPage ? 54 : 0,
            margin: EdgeInsets.only(top: isLastPage ? 10 : 0),
            child: isLastPage
                ? SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: onSecondaryPressed,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: kDarkBrown,
                        side: const BorderSide(color: kBorder, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        'Daftar Akun Baru',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: kDarkBrown,
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

/// 1 & 2. Reusable Widget: Dekorasi Lingkaran Ambient Background
class OnboardingDecorBlob extends StatelessWidget {
  final Alignment alignment;
  final double size;
  final Color color;

  const OnboardingDecorBlob({
    super.key,
    required this.alignment,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color,
              color.withValues(alpha: 0.0),
            ],
            radius: 0.65,
          ),
        ),
      ),
    );
  }
}

/// 6. Halaman Placeholder Tujuan Navigasi (Single File Internal Target)
class OnboardingDestinationPlaceholder extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const OnboardingDestinationPlaceholder({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: kDarkBrown),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(28.0),
          children: [
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: kBrunswick,
                child: Icon(icon, size: 40, color: kVanilla),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.playfairDisplay(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: kDarkBrown,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: kMuted,
              ),
            ),
            const SizedBox(height: 28),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: Text(
                  'Kembali ke Onboarding',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kBrunswick,
                  foregroundColor: kVanilla,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// CustomPainter untuk Pola Dot Grid di dalam Box Ilustrasi
class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = kBorder.withValues(alpha: 0.35)
      ..style = PaintingStyle.fill;

    const double spacing = 16.0;
    const double radius = 1.2;

    for (double x = spacing / 2; x < size.width; x += spacing) {
      for (double y = spacing / 2; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
