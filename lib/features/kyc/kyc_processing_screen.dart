import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class KycProcessingScreen extends StatefulWidget {
  final String title;
  final String subtitle;
  final String nextRoute;
  final Object? nextRouteArguments;

  const KycProcessingScreen({
    super.key,
    this.title = "We're reviewing your document.",
    this.subtitle =
        'Making sure your photo is clear and visible.\nThis usually takes a few seconds',
    required this.nextRoute,
    this.nextRouteArguments,
  });

  @override
  State<KycProcessingScreen> createState() => _KycProcessingScreenState();
}

class _KycProcessingScreenState extends State<KycProcessingScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          widget.nextRoute,
          arguments: widget.nextRouteArguments,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 56,
                height: 56,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  color: AppColors.accentYellow,
                ),
              ),
              const SizedBox(height: 28),
              Text(widget.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              Text(widget.subtitle,
                  textAlign: TextAlign.center,
                  style:
                      const TextStyle(color: AppColors.textGrey, fontSize: 13)),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () {},
                child: const Text('Having trouble? Retake photo',
                    style: TextStyle(color: AppColors.accentYellow)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}