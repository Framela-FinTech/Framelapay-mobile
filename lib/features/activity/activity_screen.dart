import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../../core/widgets/app_icon.dart';
import '../../data/models/activity_transaction.dart';
import '../../data/repositories/activity_repository.dart';

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
        automaticallyImplyLeading: false,
        title: const Text('Transfer',
            style: TextStyle(color: AppColors.primaryDark, fontSize: 16)),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 3),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _modeTabs(),
                    const SizedBox(height: 12),
                    _searchField(),
                    const SizedBox(height: 10),
                    _filterRow(),
                    const SizedBox(height: 8),
                    _filterButton(
                      _period == 'All' ? 'Choose period' : _period,
                      _showPeriodSheet,
                    ),
                    const SizedBox(height: 14),
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
              ),
      ),
    );
  }

  Widget _modeTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          _modeTab('Send Money', false),
          _modeTab('Add Money', false),
          _modeTab('History', true),
        ],
      ),
    );
  }

  Widget _modeTab(String label, bool selected) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryDark : AppColors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (selected)
              const Padding(
                padding: EdgeInsets.only(right: 4),
                child: AppIcon('clock', size: 12, color: AppColors.white),
              ),
            Text(label,
                style: TextStyle(
                    color: selected ? AppColors.white : AppColors.primaryDark,
                    fontSize: 10,
                    fontWeight: FontWeight.w600)),
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
        Expanded(
          child: _filterButton(
              _category,
              () => _showChoiceSheet(
                  title: 'Choose category',
                  options: _categories,
                  selected: _category,
                  onSelected: (value) => setState(() => _category = value))),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: _filterButton(
              _status,
              () => _showChoiceSheet(
                  title: 'Choose status',
                  options: _statuses,
                  selected: _status,
                  onSelected: (value) => setState(() => _status = value))),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: _filterButton(
              _currency,
              () => _showChoiceSheet(
                  title: 'Choose currency',
                  options: _currencies,
                  selected: _currency,
                  onSelected: (value) => setState(() => _currency = value))),
        ),
      ],
    );
  }

  Widget _filterButton(String label, VoidCallback onTap) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        side: const BorderSide(color: AppColors.divider),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.textGrey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 9)),
          ),
          const AppIcon('chevron-down', size: 14, color: AppColors.textGrey),
        ],
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
                            fontSize: 14,
                            fontWeight: FontWeight.w700)),
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
                      child: _sheetTab('Month / Year', tab == 0,
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
                  Row(
                    children: [
                      Expanded(
                          child: _sheetDropdown(
                              month,
                              ['July', 'August', 'September', 'October'],
                              (value) => setSheetState(() => month = value))),
                      const SizedBox(width: 8),
                      Expanded(
                          child: _sheetDropdown(year, ['2025', '2026'],
                              (value) => setSheetState(() => year = value))),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('Scroll to choose a month and year.',
                      style:
                          TextStyle(color: AppColors.textGrey, fontSize: 10)),
                ] else ...[
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      'Last 3 months',
                      'Last 6 months',
                      'Custom',
                    ].map((option) {
                      final selected = timeframe == option;
                      return ChoiceChip(
                        label:
                            Text(option, style: const TextStyle(fontSize: 10)),
                        selected: selected,
                        selectedColor: AppColors.accentYellow,
                        onSelected: (_) =>
                            setSheetState(() => timeframe = option),
                      );
                    }).toList(),
                  ),
                  if (timeframe == 'Custom') ...[
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(child: _dateField('From')),
                        const SizedBox(width: 8),
                        Expanded(child: _dateField('To')),
                      ],
                    ),
                  ],
                ],
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(
                        context, tab == 0 ? '$month $year' : timeframe),
                    child: Text(tab == 0 ? 'Confirm' : 'Apply Period'),
                  ),
                ),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context, 'All'),
                  child: const Text('Reset Period'),
                ),
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
                  color: selected ? AppColors.primaryDark : AppColors.divider,
                  width: selected ? 2 : 1)),
        ),
        child: Center(
          child: Text(label,
              style: TextStyle(
                  color: selected ? AppColors.primaryDark : AppColors.textGrey,
                  fontSize: 11,
                  fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }

  Widget _sheetDropdown(
      String value, List<String> options, ValueChanged<String> onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8)),
      items: options
          .map((option) => DropdownMenuItem(value: option, child: Text(option)))
          .toList(),
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
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

  Widget _monthHeader(String month) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(month,
              style: const TextStyle(
                  color: AppColors.primaryDark,
                  fontSize: 11,
                  fontWeight: FontWeight.w700)),
          const AppIcon('chevron-down', size: 15, color: AppColors.primaryDark),
        ],
      ),
    );
  }

  Widget _transactionTile(ActivityTransaction transaction) {
    final statusColor = _statusColor(transaction.status);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.inputFill,
              borderRadius: BorderRadius.circular(7),
            ),
            child: AppIcon(transaction.icon,
                size: 16, color: AppColors.primaryDark),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(transaction.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: AppColors.primaryDark,
                        fontSize: 9,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 3),
                Text(transaction.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: AppColors.textGrey, fontSize: 8)),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(transaction.amount,
                  style: TextStyle(
                      color: transaction.incoming
                          ? AppColors.success
                          : AppColors.primaryDark,
                      fontSize: 9,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 3),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(_statusLabel(transaction.status),
                    style: TextStyle(color: statusColor, fontSize: 7)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Padding(
      padding: const EdgeInsets.only(top: 90),
      child: Center(
        child: Column(
          children: [
            const AppIcon('search', size: 42, color: AppColors.primaryDark),
            const SizedBox(height: 14),
            const Text('No matching transactions',
                style: TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            const Text('Try another search or clear your filters.',
                style: TextStyle(color: AppColors.textGrey, fontSize: 11)),
            const SizedBox(height: 18),
            OutlinedButton(
              onPressed: _resetFilters,
              child: const Text('Clear Filters'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showChoiceSheet({
    required String title,
    required List<String> options,
    required String selected,
    required ValueChanged<String> onSelected,
  }) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.white,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: AppColors.primaryDark,
                        fontSize: 14,
                        fontWeight: FontWeight.w700)),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const AppIcon('close', color: AppColors.primaryDark),
                ),
              ],
            ),
            ...options.map((option) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(option, style: const TextStyle(fontSize: 12)),
                  trailing: option == selected
                      ? const AppIcon('check-circle',
                          color: AppColors.accentYellow)
                      : null,
                  onTap: () => Navigator.pop(context, option),
                )),
          ],
        ),
      ),
    );
    if (result != null) onSelected(result);
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
      return AppColors.accentYellow;
    case ActivityTransactionStatus.failed:
      return AppColors.error;
  }
}
