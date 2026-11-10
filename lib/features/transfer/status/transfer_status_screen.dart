import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../data/models/ongoing_transfer.dart';
import '../../../data/repositories/ongoing_transfer_repository.dart';
import '../fiat/widgets/fiat_form_widgets.dart';

/// "Transfer Status" — every transfer that has not settled yet.
class TransferStatusScreen extends StatefulWidget {
  const TransferStatusScreen({super.key});

  @override
  State<TransferStatusScreen> createState() => _TransferStatusScreenState();
}

class _TransferStatusScreenState extends State<TransferStatusScreen> {
  final OngoingTransferRepository _repo = MockOngoingTransferRepository();
  List<OngoingTransfer> _transfers = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final transfers = await _repo.getOngoingTransfers();
    if (!mounted) return;
    setState(() {
      _transfers = transfers;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final count = _transfers.length;
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('Transfer Status'),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: _transfers.isEmpty
                        ? _emptyState()
                        : SingleChildScrollView(
                            padding:
                                const EdgeInsets.fromLTRB(20, 20, 20, 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ScreenHeading(
                                  '$count ongoing transfer'
                                  '${count == 1 ? '' : 's'}',
                                  helper:
                                      'Track payments that are still underway.',
                                ),
                                const SizedBox(height: 20),
                                ..._transfers.map(_card),
                              ],
                            ),
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                    child: Column(
                      children: [
                        PrimaryButton(
                          'View transfer history',
                          onPressed: () => Navigator.pushNamed(
                              context, AppRoutes.activity),
                        ),
                        const SizedBox(height: 12),
                        SecondaryButton(
                          'Go home',
                          onPressed: () => Navigator.popUntil(
                              context, (route) => route.isFirst),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _emptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconBadge(
              icon: 'check-circle',
              halo: AppColors.successSoft,
              size: 104,
              glyphSize: 42,
              glyphColor: AppColors.success,
            ),
            SizedBox(height: 20),
            Text('Nothing in flight',
                style: TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 22,
                    fontWeight: FontWeight.w800)),
            SizedBox(height: 8),
            Text('Every transfer you have made has settled.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textGrey, fontSize: 15)),
          ],
        ),
      ),
    );
  }

  Widget _card(OngoingTransfer transfer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        onTap: () => Navigator.pushNamed(
            context, AppRoutes.transferProgress,
            arguments: transfer),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(transfer.recipient,
                        style: const TextStyle(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w700,
                            fontSize: 16)),
                  ),
                  StatusPill(transfer.stage.label),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(transfer.amount,
                        style: const TextStyle(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w800,
                            fontSize: 24)),
                  ),
                  const AppIcon('chevron-right',
                      color: AppColors.textGrey),
                ],
              ),
              const SizedBox(height: 4),
              Text(transfer.subtitle,
                  style: const TextStyle(
                      color: AppColors.textGrey, fontSize: 13)),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.pageGrey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(transfer.stage.detail,
                    style: const TextStyle(
                        color: AppColors.textGrey, fontSize: 13)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
