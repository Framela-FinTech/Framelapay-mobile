import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/theme/app_colors.dart';
import '../../core/routes/app_routes.dart';

class OnboardingData {
  final String title;
  final String subtitle;
  final String image;
  const OnboardingData(this.title, this.subtitle, this.image);
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<OnboardingData> _pages = const [
    OnboardingData(
      'Connect with the people who matter.',
      'Send and receive across borders, wherever life takes you.',
      'assets/images/onboarding_1.png',
    ),
    OnboardingData(
      'For the people who matter most.',
      'Support your loved ones, build memories, and be there no matter the distance.',
      'assets/images/onboarding_2.png',
    ),
    OnboardingData(
      'One World One connection.',
      'Send and manage your money across countries with real exchange rates, low fees and total confidence.',
      'assets/images/onboarding_3.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoAdvance();
  }

  void _startAutoAdvance() {
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      final nextPage = (_currentPage + 1) % _pages.length;
      _controller.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  void _resetAutoAdvance() {
    _timer?.cancel();
    _startAutoAdvance();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: Stack(
        children: [
          // ---- Layer 1: full-bleed background image per slide ----
          Positioned.fill(
            child: PageView.builder(
              controller: _controller,
              itemCount: _pages.length,
              onPageChanged: (i) {
                setState(() => _currentPage = i);
                _resetAutoAdvance();
              },
              itemBuilder: (context, index) {
                return Image.asset(
                  _pages[index].image,
                  fit: BoxFit.cover,
                  // If an image is missing, show the dark bg instead of crashing
                  errorBuilder: (_, __, ___) =>
                      Container(color: AppColors.primaryDark),
                );
              },
            ),
          ),

          // ---- Layer 2: gradient scrim for text readability ----
          // Delete this whole Positioned.fill if your design needs no darkening.
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.primaryDark.withOpacity(0.4),
                      AppColors.primaryDark.withOpacity(0.92),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // ---- Layer 3: text + indicator + button on top ----
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const Spacer(),
                  // Text block sits in the lower portion, over the scrim
                  Text(
                    _pages[_currentPage].title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _pages[_currentPage].subtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SmoothPageIndicator(
                    controller: _controller,
                    count: _pages.length,
                    effect: const ExpandingDotsEffect(
                      activeDotColor: AppColors.accentYellow,
                      dotColor: Colors.white24,
                      dotHeight: 6,
                      dotWidth: 6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _currentPage == _pages.length - 1
                      ? SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pushReplacementNamed(
                                context, AppRoutes.welcome),
                            child: const Text('Get Started'),
                          ),
                        )
                      : Align(
                          alignment: Alignment.center,
                          child: TextButton(
                            onPressed: () => Navigator.pushReplacementNamed(
                                context, AppRoutes.welcome),
                            child: const Text('Skip',
                                style: TextStyle(color: AppColors.white)),
                          ),
                        ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
