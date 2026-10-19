import 'package:flutter/material.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../data/models/support_models.dart';
import '../../../data/repositories/support_repository.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _SupportScaffold(
      title: 'Help & Support',
      child: Column(
        children: [
          _SupportTile(
            icon: 'search',
            title: 'Search Help Articles',
            subtitle: 'Find answers and useful tips.',
            onTap: () => Navigator.pushNamed(context, AppRoutes.helpCentre),
          ),
          _SupportTile(
            icon: 'call',
            title: 'Live Support',
            subtitle: 'Start a conversation.',
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.startLiveSupport),
          ),
          _SupportTile(
            icon: 'receipt',
            title: 'My Support Requests',
            subtitle: 'Track open and resolved cases.',
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.supportRequests),
          ),
          _SupportTile(
            icon: 'info-triangle',
            title: 'Report a Problem',
            subtitle: 'Describe an issue or dispute.',
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.reportProblem),
          ),
          const SizedBox(height: 8),
          _Notice(
            icon: 'lock',
            text:
                'Never share your password, passcode, PIN or verification codes with support.',
          ),
        ],
      ),
    );
  }
}

class HelpCentreScreen extends StatefulWidget {
  const HelpCentreScreen({super.key});

  @override
  State<HelpCentreScreen> createState() => _HelpCentreScreenState();
}

class _HelpCentreScreenState extends State<HelpCentreScreen> {
  final _repository = MockSupportRepository();
  final _search = TextEditingController();
  List<HelpArticle> _articles = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final articles = await _repository.getArticles();
    if (mounted) setState(() => _articles = articles);
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _SupportScaffold(
      title: 'Help Centre',
      child: AnimatedBuilder(
        animation: _search,
        builder: (context, _) {
          final query = _search.text.toLowerCase();
          final articles = _articles
              .where((article) => article.title.toLowerCase().contains(query))
              .toList();
          return Column(
            children: [
              TextField(
                controller: _search,
                decoration: const InputDecoration(
                  hintText: 'Search help articles',
                  prefixIcon: AppIcon('search', color: AppColors.textGrey),
                ),
              ),
              const SizedBox(height: 14),
              ...articles.map((article) => _ArticleTile(article: article)),
              const SizedBox(height: 10),
              _OutlineButton(
                label: 'Contact Live Support',
                onPressed: () => Navigator.pushNamed(
                    context, AppRoutes.startLiveSupport),
              ),
            ],
          );
        },
      ),
    );
  }
}

class HelpArticleScreen extends StatelessWidget {
  final HelpArticle article;
  const HelpArticleScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return _SupportScaffold(
      title: 'Help Article',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(article.category,
              style: const TextStyle(color: AppColors.textGrey, fontSize: 10)),
          const SizedBox(height: 12),
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(article.title,
                    style: const TextStyle(
                        color: AppColors.primaryDark,
                        fontSize: 15,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                Text(article.body,
                    style: const TextStyle(
                        color: AppColors.primaryDark, fontSize: 11, height: 1.5)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _OutlineButton(
            label: 'Open ${article.category}',
            onPressed: () => Navigator.pop(context),
          ),
          _OutlineButton(
            label: 'Still need help? Live Support',
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.startLiveSupport),
          ),
          _OutlineButton(
            label: 'Back to Help Centre',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

class LiveSupportScreen extends StatefulWidget {
  const LiveSupportScreen({super.key});

  @override
  State<LiveSupportScreen> createState() => _LiveSupportScreenState();
}

class _LiveSupportScreenState extends State<LiveSupportScreen> {
  final _message = TextEditingController();

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _SupportScaffold(
      title: 'Live Support',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Case FRM-10429 · Typically replies in 2 minutes',
              style: TextStyle(color: AppColors.textGrey, fontSize: 10)),
          const SizedBox(height: 14),
          _ChatBubble(
              text:
                  'Hello Cynthia, I’m Ada from FramelaPay Support. How can we help today?',
              mine: false),
          _ChatBubble(
              text: 'I need help understanding a restricted transfer.',
              mine: true),
          _ChatBubble(
              text:
                  'I can help you check the transaction status. Please don’t share your PIN or OTP here.',
              mine: false),
          const SizedBox(height: 28),
          _Notice(
            icon: 'lock',
            text: 'Never share your PIN or OTP in chat.',
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _message,
            decoration: const InputDecoration(hintText: 'Type a message'),
          ),
          const SizedBox(height: 10),
          _PrimaryButton(
            label: 'Open Live Chat',
            onPressed: () => _message.clear(),
          ),
          _OutlineButton(
            label: 'Back to Settings',
            onPressed: () => Navigator.popUntil(
                context, ModalRoute.withName(AppRoutes.profile)),
          ),
        ],
      ),
    );
  }
}

class SupportRequestsScreen extends StatefulWidget {
  const SupportRequestsScreen({super.key});

  @override
  State<SupportRequestsScreen> createState() => _SupportRequestsScreenState();
}

class _SupportRequestsScreenState extends State<SupportRequestsScreen> {
  final _repository = MockSupportRepository();
  List<SupportRequest> _requests = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final requests = await _repository.getRequests();
    if (mounted) setState(() => _requests = requests);
  }

  @override
  Widget build(BuildContext context) {
    return _SupportScaffold(
      title: 'Support Requests',
      child: Column(
        children: [
          ..._requests.map((request) => _Card(
                child: Row(
                  children: [
                    const AppIcon('info-circle',
                        size: 18, color: AppColors.primaryDark),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text('${request.reference} · ${request.subject}',
                          style: const TextStyle(fontSize: 11)),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 14),
          _PrimaryButton(
            label: 'Open Live Chat',
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.liveSupport),
          ),
          _OutlineButton(
            label: 'Back to Settings',
            onPressed: () => Navigator.popUntil(
                context, ModalRoute.withName(AppRoutes.profile)),
          ),
        ],
      ),
    );
  }
}

class ReportProblemScreen extends StatefulWidget {
  const ReportProblemScreen({super.key});

  @override
  State<ReportProblemScreen> createState() => _ReportProblemScreenState();
}

class _ReportProblemScreenState extends State<ReportProblemScreen> {
  String _issue = 'Transfer delay';
  final _description = TextEditingController();

  @override
  void dispose() {
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _SupportScaffold(
      title: 'Report A Problem',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _FieldLabel('Issue'),
          _Dropdown(
            value: _issue,
            items: const ['Transfer delay', 'Wrong exchange rate', 'Other'],
            onChanged: (value) => setState(() => _issue = value),
          ),
          const SizedBox(height: 14),
          const _FieldLabel('Describe the problem'),
          TextField(
            controller: _description,
            maxLines: 5,
            decoration: const InputDecoration(hintText: 'Tell us what happened'),
          ),
          const SizedBox(height: 16),
          _PrimaryButton(
            label: 'Submit Request',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.liveSupport),
          ),
        ],
      ),
    );
  }
}

class StartLiveSupportScreen extends StatefulWidget {
  const StartLiveSupportScreen({super.key});

  @override
  State<StartLiveSupportScreen> createState() => _StartLiveSupportScreenState();
}

class _StartLiveSupportScreenState extends State<StartLiveSupportScreen> {
  String _topic = 'Transfer issue';

  @override
  Widget build(BuildContext context) {
    return _SupportScaffold(
      title: 'Start Live Support',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _FieldLabel('Support topic'),
          _Dropdown(
            value: _topic,
            items: const ['Transfer issue', 'Wallet question', 'Account enquiry'],
            onChanged: (value) => setState(() => _topic = value),
          ),
          const SizedBox(height: 14),
          const _FieldLabel('How can we help?'),
          const TextField(
            maxLines: 4,
            decoration: InputDecoration(hintText: 'Describe your question'),
          ),
          const SizedBox(height: 10),
          const _Notice(
            icon: 'info-circle',
            text: 'This is a simulated support conversation.',
          ),
          const SizedBox(height: 14),
          _PrimaryButton(
            label: 'Start Conversation',
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.liveSupport),
          ),
        ],
      ),
    );
  }
}

class _SupportScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  const _SupportScaffold({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(title,
            style: const TextStyle(
                color: AppColors.primaryDark,
                fontSize: 16,
                fontWeight: FontWeight.w600)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 480),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _SupportTile extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _SupportTile(
      {required this.icon,
      required this.title,
      required this.subtitle,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return _Card(
      onTap: onTap,
      child: Row(
        children: [
          AppIcon(icon, size: 18, color: AppColors.primaryDark),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 3),
                Text(subtitle,
                    style: const TextStyle(
                        color: AppColors.textGrey, fontSize: 10)),
              ],
            ),
          ),
          const AppIcon('chevron-right', size: 18, color: AppColors.textGrey),
        ],
      ),
    );
  }
}

class _ArticleTile extends StatelessWidget {
  final HelpArticle article;
  const _ArticleTile({required this.article});

  @override
  Widget build(BuildContext context) {
    return _Card(
      onTap: () => Navigator.pushNamed(context, AppRoutes.helpArticle,
          arguments: article),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(article.title,
                    style: const TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w600)),
                const SizedBox(height: 3),
                Text(article.category,
                    style: const TextStyle(
                        color: AppColors.textGrey, fontSize: 9)),
              ],
            ),
          ),
          const AppIcon('chevron-right', size: 18, color: AppColors.textGrey),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  const _Card({required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    final card = Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.divider),
      ),
      child: child,
    );
    return onTap == null
        ? card
        : InkWell(onTap: onTap, borderRadius: BorderRadius.circular(10), child: card);
  }
}

class _Notice extends StatelessWidget {
  final String icon;
  final String text;
  const _Notice({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.iconBlue.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          AppIcon(icon, size: 16, color: AppColors.primaryDark),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 10))),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String text;
  final bool mine;
  const _ChatBubble({required this.text, required this.mine});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 280),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: mine ? AppColors.iconBlue.withValues(alpha: 0.12) : AppColors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(text, style: const TextStyle(fontSize: 10, height: 1.4)),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(
          color: AppColors.primaryDark,
          fontSize: 11,
          fontWeight: FontWeight.w600));
}

class _Dropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;
  const _Dropdown(
      {required this.value, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );
  }
}

class _OutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const _OutlineButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(onPressed: onPressed, child: Text(label)),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const _PrimaryButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(onPressed: onPressed, child: Text(label)),
    );
  }
}
