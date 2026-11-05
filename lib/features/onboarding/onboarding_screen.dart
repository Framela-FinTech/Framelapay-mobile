import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/theme/app_colors.dart';
import '../../core/routes/app_routes.dart';

class OnboardingData {
  /// Title split into a dark leading part and an accent-yellow trailing part.
  final String titleDark;
  final String titleAccent;
  final String subtitle;
  final String image;
  const OnboardingData(
      this.titleDark, this.titleAccent, this.subtitle, this.image);
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
      'Connect with the ',
      'people who matter.',
      'Send and receive across borders, wherever life takes you.',
      'assets/images/onboarding_1.png',
    ),
    OnboardingData(
      'For the people who ',
      'matter most.',
      'Support your loved ones, build memories, and be there no matter the distance.',
      'assets/images/onboarding_2.png',
    ),
    OnboardingData(
      'One World One ',
      'connection.',
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

  void _next() {
    _controller.animateToPage(
      _currentPage + 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    _resetAutoAdvance();
  }

  void _goToWelcome() =>
      Navigator.pushReplacementNamed(context, AppRoutes.welcome);

  void _goToLogin() =>
      Navigator.pushReplacementNamed(context, AppRoutes.login);

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _currentPage == _pages.length - 1;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: Stack(
        children: [
          // ---- Image area per slide ----
          // The image fills the upper part of the screen, while the white
          // card overlays the lower portion.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height * 0.58,
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
                  fit: BoxFit.fill,
                  alignment: Alignment.topCenter,
                  errorBuilder: (_, __, ___) =>
                      Container(color: AppColors.primaryDark),
                );
              },
            ),
          ),

          // ---- White rounded card floating over the lower portion ----
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(minHeight: size.height * 0.47),
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 36, 24, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ---- Title (left-aligned display, dark + gold split) ----
                      RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            color: AppColors.primaryDark,
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                          children: [
                            TextSpan(text: _pages[_currentPage].titleDark),
                            TextSpan(
                              text: _pages[_currentPage].titleAccent,
                              style: const TextStyle(
                                  color: AppColors.accentYellow),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _pages[_currentPage].subtitle,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: AppColors.neutral40,
                          fontSize: 15,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 28),
                      // ---- Page indicator (centered, equal gold/grey dots) ----
                      Center(
                        child: SmoothPageIndicator(
                          controller: _controller,
                          count: _pages.length,
                          effect: const ScrollingDotsEffect(
                            activeDotColor: AppColors.accentYellow,
                            dotColor: AppColors.divider,
                            dotHeight: 8,
                            dotWidth: 8,
                            spacing: 8,
                            activeDotScale: 1.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryDark,
                            foregroundColor: AppColors.white,
                            minimumSize: const Size.fromHeight(56),
                          ),
                          onPressed: isLast ? _goToWelcome : _next,
                          child: Text(isLast ? 'Get Started' : 'Next'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // ---- Secondary CTA ----
                      // Non-last slides offer a gold "Skip"; the last slide
                      // offers the login shortcut, matching the design.
                      Center(
                        child: GestureDetector(
                          onTap: isLast ? _goToLogin : _goToWelcome,
                          child: isLast
                              ? RichText(
                                  text: const TextSpan(
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        color: AppColors.primaryDark,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                    children: [
                                      TextSpan(
                                          text: 'Already have an account? '),
                                      TextSpan(
                                        text: 'Log in',
                                        style: TextStyle(
                                            color: AppColors.accentYellow,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                )
                              : const Text(
                                  'Skip',
                                  style: TextStyle(
                                    color: AppColors.accentYellow,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
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
        ],
      ),
    );
  }
}
