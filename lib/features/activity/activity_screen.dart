import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../../core/widgets/app_icon.dart';
import '../../data/models/activity_transaction.dart';
import '../../data/models/transaction_receipt.dart';
import '../../data/repositories/activity_repository.dart';
import '../transfer/fiat/widgets/fiat_form_widgets.dart';

/// Which History filter chip owns the open dropdown.
enum _FilterKind { category, status, currency }

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  final ActivityRepository _repository = MockActivityRepository();
  final TextEditingController _searchController = TextEditingController();
  List<ActivityTransaction> _transactions = [];
  bool _loading = true;
  String _category = 'All categories';
  String _status = 'All status';
  String _currency = 'All currencies';
  String _period = 'All';

  /// Which filter's dropdown is open, if any. The board anchors these panels
  /// under the chip row rather than presenting them as bottom sheets.
  _FilterKind? _openFilter;
  String _query = '';

  static const _categories = [
    'All categories',
    'Sent',
    'Received',
    'Exchange',
    'Wallet Funded',
    'Bank Transfer',
    'Credit/Debit card',
    'Stablecoin',
  ];
  static const _statuses = [
    'All status',
    'Completed',
    'Processing',
    'Pending',
    'Failed',
  ];
  static const _currencies = ['All currencies', 'EUR', 'USD', 'NGN'];

  @override
  void initState() {
    super.initState();
    _load();
    _searchController.addListener(() {
      setState(() => _query = _searchController.text.trim());
    });
  }

  Future<void> _load() async {
    final transactions = await _repository.getTransactions();
    if (!mounted) return;
    setState(() {
      _transactions = transactions;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ActivityTransaction> get _filteredTransactions {
    final normalizedQuery = _query.toLowerCase();
    return _transactions.where((transaction) {
      final matchesQuery = normalizedQuery.isEmpty ||
          transaction.title.toLowerCase().contains(normalizedQuery) ||
          transaction.subtitle.toLowerCase().contains(normalizedQuery);
      final matchesCategory =
          _category == 'All categories' || transaction.category == _category;
      final matchesStatus = _status == 'All status' ||
          _statusLabel(transaction.status) == _status;
      final matchesCurrency =
          _currency == 'All currencies' || transaction.currency == _currency;
      return matchesQuery &&
          matchesCategory &&
          matchesStatus &&
          matchesCurrency;
    }).toList();
  }

  bool get _hasFilters =>
      _query.isNotEmpty ||
      _category != 'All categories' ||
      _status != 'All status' ||
      _currency != 'All currencies' ||
      _period != 'All';

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _category = 'All categories';
      _status = 'All status';
      _currency = 'All currencies';
      _period = 'All';
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredTransactions;
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        // Reached both as a bottom-nav tab (nothing to pop) and by push from
        // the transfer hub, so let Flutter decide whether to show the back arrow.
        iconTheme: const IconThemeData(color: AppColors.primaryDark),
        title: const Text('History',
            style: TextStyle(
                color: AppColors.primaryDark,
                fontSize: 20,
                fontWeight: FontWeight.w700)),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 3),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fixed header so a filter panel can anchor directly beneath
                  // the chip row, with the list dimmed behind it.
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _modeTabs(),
                        const SizedBox(height: 12),
                        _searchField(),
                        const SizedBox(height: 10),
                        _filterRow(),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        _listBody(filtered),
                        if (_openFilter != null) ...[
                          Positioned.fill(
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => _openFilter = null),
                              child: Container(
                                  color: Colors.black.withValues(alpha: 0.4)),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: _filterPanel(),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
      ),
      );
  }

  Widget _listBody(List<ActivityTransaction> filtered) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
                    if (_hasFilters)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Filtered transactions',
                              style: TextStyle(
                                  color: AppColors.textGrey, fontSize: 11)),
                          TextButton(
                            onPressed: _resetFilters,
                            child: const Text('Reset'),
                          ),
                        ],
                      ),
          if (filtered.isEmpty)
            _emptyState()
          else
            _transactionGroups(filtered),
        ],
      ),
    );
  }

  /// White bar carrying the three modes; the active one is a dark pill.
  Widget _modeTabs() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _modeTab('Send Money', 'arrow-up', false),
          _modeTab('Receive Money', 'arrow-down', false),
          _modeTab('History', 'clock', true),
        ],
      ),
    );
  }

  Widget _modeTab(String label, String icon, bool selected) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryDark : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: AppIcon(icon,
                  size: 14,
                  color:
                      selected ? AppColors.white : AppColors.primaryDark),
            ),
            Flexible(
              child: Text(label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color:
                          selected ? AppColors.white : AppColors.primaryDark,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchField() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search transactions',
        prefixIcon: const AppIcon('search', color: AppColors.textGrey),
        suffixIcon: _query.isEmpty
            ? null
            : IconButton(
                onPressed: _searchController.clear,
                icon: const AppIcon('close', color: AppColors.textGrey),
              ),
      ),
    );
  }

  Widget _filterRow() {
    return Row(
      children: [
        Expanded(child: _filterButton(_FilterKind.category, _category)),
        const SizedBox(width: 6),
        Expanded(child: _filterButton(_FilterKind.status, _status)),
        const SizedBox(width: 6),
        Expanded(child: _filterButton(_FilterKind.currency, _currency)),
      ],
    );
  }

  /// Chip that opens its panel. The board gives the open chip an amber
  /// outline, a cream fill and an upward chevron.
  Widget _filterButton(_FilterKind kind, String label) {
    final open = _openFilter == kind;
    return OutlinedButton(
      onPressed: () =>
          setState(() => _openFilter = open ? null : kind),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        side: BorderSide(
            color: open ? AppColors.accentYellow : AppColors.divider),
        backgroundColor: open ? AppColors.warningSoft : AppColors.white,
        foregroundColor:
            open ? AppColors.primaryDark : AppColors.textGrey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: open ? FontWeight.w700 : FontWeight.w500)),
          ),
          const SizedBox(width: 2),
          AppIcon(open ? 'chevron-up' : 'chevron-down',
              size: 16,
              color: open ? AppColors.primaryDark : AppColors.textGrey),
        ],
      ),
    );
  }

  /// The anchored panel for whichever chip is open.
  Widget _filterPanel() {
    late final String title;
    late final List<String> options;
    late final String selected;
    late final ValueChanged<String> onSelected;

    switch (_openFilter!) {
      case _FilterKind.category:
        title = 'Choose category';
        options = _categories;
        selected = _category;
        onSelected = (v) => _category = v;
      case _FilterKind.status:
        title = 'Choose status';
        options = _statuses;
        selected = _status;
        onSelected = (v) => _status = v;
      case _FilterKind.currency:
        title = 'Choose currency';
        options = _currencies;
        selected = _currency;
        onSelected = (v) => _currency = v;
    }

    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        // Never taller than the area below the chips.
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.56,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: AppColors.primaryDark,
                          fontSize: 17,
                          fontWeight: FontWeight.w700)),
                  InkWell(
                    onTap: () => setState(() => _openFilter = null),
                    borderRadius: BorderRadius.circular(20),
                    child: const AppIcon('close',
                        color: AppColors.primaryDark),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              for (var i = 0; i < options.length; i++)
                _choiceRow(
                  option: options[i],
                  isSelected: options[i] == selected,
                  // No divider around the pill, or after the final row.
                  showDivider: i != options.length - 1 &&
                      options[i] != selected &&
                      options[i + 1] != selected,
                  onTap: () => setState(() {
                    onSelected(options[i]);
                    _openFilter = null;
                  }),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showPeriodSheet() async {
    var tab = 0;
    var month = 'September';
    var year = '2026';
    var timeframe = 'Last 3 months';
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      showDragHandle: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Choose period',
                        style: TextStyle(
                            color: AppColors.primaryDark,
                            fontSize: 22,
                            fontWeight: FontWeight.w800)),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon:
                          const AppIcon('close', color: AppColors.primaryDark),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: _sheetTab('Month', tab == 0,
                          () => setSheetState(() => tab = 0)),
                    ),
                    Expanded(
                      child: _sheetTab('Time frame', tab == 1,
                          () => setSheetState(() => tab = 1)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (tab == 0) ...[
                  const Row(
                    children: [
                      Expanded(child: _WheelHeader('Month')),
                      SizedBox(width: 12),
                      Expanded(child: _WheelHeader('Year')),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _pickerWheel(
                          options: _monthNames,
                          selected: month,
                          onChanged: (v) => setSheetState(() => month = v),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _pickerWheel(
                          options: _yearNames,
                          selected: year,
                          onChanged: (v) => setSheetState(() => year = v),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text('Scroll to choose a month and year.',
                      style:
                          TextStyle(color: AppColors.textGrey, fontSize: 14)),
                ] else ...[
                  Row(
                    children: [
                      for (final option in const [
                        'Last 3 months',
                        'Last 6 months',
                        'Custom',
                      ]) ...[
                        Expanded(
                          child: _timeframeChip(
                            option,
                            timeframe == option,
                            () => setSheetState(() => timeframe = option),
                          ),
                        ),
                        if (option != 'Custom') const SizedBox(width: 10),
                      ],
                    ],
                  ),
                  if (timeframe == 'Custom') ...[
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(child: _dateField('From')),
                        const SizedBox(width: 12),
                        Expanded(child: _dateField('To')),
                      ],
                    ),
                  ],
                ],
                const SizedBox(height: 24),
                PrimaryButton(
                  tab == 0 ? 'Confirm' : 'Apply Period',
                  onPressed: () => Navigator.pop(
                      context, tab == 0 ? '$month $year' : timeframe),
                ),
                // The board offers the reset only on the Time frame tab.
                if (tab == 1) ...[
                  const SizedBox(height: 12),
                  SecondaryButton(
                    'Reset Period',
                    onPressed: () => Navigator.pop(context, 'All'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
    if (result != null) setState(() => _period = result);
  }

  Widget _sheetTab(String label, bool selected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  // The board underlines the active tab in amber.
                  color: selected ? AppColors.accentYellow : AppColors.divider,
                  width: selected ? 3 : 1)),
        ),
        child: Center(
          child: Text(label,
              style: TextStyle(
                  color: selected ? AppColors.primaryDark : AppColors.textGrey,
                  fontSize: 16,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500)),
        ),
      ),
    );
  }

  static const _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
  static const _yearNames = ['2024', '2025', '2026'];

  /// Scroll wheel with a cream band across the centre row, as the board draws
  /// it, on a grey rounded column.
  Widget _pickerWheel({
    required List<String> options,
    required String selected,
    required ValueChanged<String> onChanged,
  }) {
    const itemExtent = 46.0;
    final index = options.indexOf(selected).clamp(0, options.length - 1);
    return Container(
      height: itemExtent * 5,
      decoration: BoxDecoration(
        color: AppColors.pageGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Center(
            child: Container(height: itemExtent, color: AppColors.warningSoft),
          ),
          ListWheelScrollView.useDelegate(
            itemExtent: itemExtent,
            diameterRatio: 2.2,
            physics: const FixedExtentScrollPhysics(),
            controller: FixedExtentScrollController(initialItem: index),
            onSelectedItemChanged: (i) => onChanged(options[i]),
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: options.length,
              builder: (context, i) {
                final isSelected = options[i] == selected;
                return Center(
                  child: Text(
                    options[i],
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.primaryDark
                          : AppColors.textGrey,
                      fontSize: 16,
                      fontWeight:
                          isSelected ? FontWeight.w800 : FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// White chip with a hairline border; cream fill and amber outline when
  /// chosen.
  Widget _timeframeChip(String label, bool selected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? AppColors.warningSoft : AppColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: selected ? AppColors.accentYellow : AppColors.divider),
        ),
        alignment: Alignment.center,
        child: Text(label,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: AppColors.primaryDark,
                fontSize: 13,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500)),
      ),
    );
  }

  Widget _dateField(String label) {
    return TextField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: const AppIcon('calendar', size: 17),
      ),
      onTap: () async {
        await showDatePicker(
          context: context,
          firstDate: DateTime(2025),
          lastDate: DateTime(2026, 12, 31),
          initialDate: DateTime(2026, 9),
        );
      },
    );
  }

  Widget _transactionGroups(List<ActivityTransaction> transactions) {
    final groups = <String, List<ActivityTransaction>>{};
    for (final transaction in transactions) {
      groups.putIfAbsent(transaction.month, () => []).add(transaction);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: groups.entries
          .map((entry) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _monthHeader(entry.key),
                  ...entry.value.map(_transactionTile),
                  const SizedBox(height: 8),
                ],
              ))
          .toList(),
    );
  }

  /// The month header doubles as the period picker's trigger — its chevron is
  /// what opens "Choose period".
  Widget _monthHeader(String month) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: InkWell(
        onTap: _showPeriodSheet,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_period == 'All' ? month : _period,
                style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w700)),
            const AppIcon('chevron-down',
                size: 18, color: AppColors.primaryDark),
          ],
        ),
      ),
    );
  }

  Widget _transactionTile(ActivityTransaction transaction) {
    final statusColor = _statusColor(transaction.status);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.pushNamed(
          context,
          AppRoutes.receiptDetail,
          arguments: TransactionReceipt.fromActivity(transaction),
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: AppShadows.card,
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.inputFill,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: AppIcon(transaction.icon,
                    size: 20, color: AppColors.primaryDark),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(transaction.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: AppColors.primaryDark,
                            fontSize: 14,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 3),
                    Text(transaction.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: AppColors.textGrey, fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Figma keeps every amount navy — direction is carried by the
                  // leading +/- sign, not by colour.
                  Text(transaction.amount,
                      style: const TextStyle(
                          color: AppColors.primaryDark,
                          fontSize: 14,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 9, vertical: 3),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(_statusLabel(transaction.status),
                        style: TextStyle(
                            color: statusColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              const AppIcon('chevron-right',
                  size: 20, color: AppColors.primaryDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Padding(
      padding: const EdgeInsets.only(top: 90),
      child: Center(
        child: Column(
          children: [
            const IconBadge(
              icon: 'search',
              halo: AppColors.infoHalo,
              size: 104,
              glyphSize: 42,
              glyphColor: AppColors.primary50,
            ),
            const SizedBox(height: 20),
            const Text('No matching transactions',
                style: TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 22,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            const Text('Try another search or clear your filters.',
                style: TextStyle(color: AppColors.textGrey, fontSize: 14)),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.white,
                  minimumSize: const Size.fromHeight(56),
                  side: const BorderSide(color: AppColors.divider),
                  foregroundColor: AppColors.primaryDark,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _resetFilters,
                child: const Text('Clear Filters',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _choiceRow({
    required String option,
    required bool isSelected,
    required bool showDivider,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: isSelected
                ? BoxDecoration(
                    color: AppColors.accentYellow.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.accentYellow),
                  )
                : null,
            child: Row(
              children: [
                Expanded(
                  child: Text(option,
                      style: const TextStyle(
                          color: AppColors.primaryDark, fontSize: 14)),
                ),
                if (isSelected)
                  const Icon(Icons.check,
                      size: 22, color: AppColors.accentYellow),
              ],
            ),
          ),
        ),
        if (showDivider)
          const Divider(height: 1, color: AppColors.divider),
      ],
    );
  }
}

String _statusLabel(ActivityTransactionStatus status) {
  switch (status) {
    case ActivityTransactionStatus.completed:
      return 'Completed';
    case ActivityTransactionStatus.pending:
      return 'Pending';
    case ActivityTransactionStatus.failed:
      return 'Failed';
  }
}

Color _statusColor(ActivityTransactionStatus status) {
  switch (status) {
    case ActivityTransactionStatus.completed:
      return AppColors.success;
    case ActivityTransactionStatus.pending:
      return AppColors.warning;
    case ActivityTransactionStatus.failed:
      return AppColors.error;
  }
}

/// Centred column heading above a picker wheel.
class _WheelHeader extends StatelessWidget {
  final String label;
  const _WheelHeader(this.label);

  @override
  Widget build(BuildContext context) => Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(
            color: AppColors.primaryDark,
            fontSize: 15,
            fontWeight: FontWeight.w700),
      );
}
