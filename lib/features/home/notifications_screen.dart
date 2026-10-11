import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_icon.dart';
import '../../data/models/notification_item.dart';
import '../../data/repositories/notification_repository.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationRepository _repository = MockNotificationRepository();
  late Future<List<NotificationItem>> _future;

  @override
  void initState() {
    super.initState();
    _future = _repository.getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text('Notifications',
            style: TextStyle(color: Colors.black, fontSize: 16)),
      ),
      body: SafeArea(
        child: FutureBuilder<List<NotificationItem>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final items = snapshot.data ?? [];
            if (items.isEmpty) {
              return const Center(
                child: Text('No notifications yet.',
                    style: TextStyle(color: AppColors.textGrey)),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) => _notificationTile(items[index]),
            );
          },
        ),
      ),
    );
  }

  Widget _notificationTile(NotificationItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: AppColors.inputFill,
            child: AppIcon(_iconFor(item.type), color: AppColors.primaryDark, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item.title,
                        style: TextStyle(
                            fontWeight:
                                item.isRead ? FontWeight.w500 : FontWeight.w700,
                            fontSize: 14)),
                    Text(item.time,
                        style: const TextStyle(
                            color: AppColors.textGrey, fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 2),
                Text(item.message,
                    style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
              ],
            ),
          ),
          if (!item.isRead)
            Container(
              margin: const EdgeInsets.only(left: 8, top: 4),
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                  color: AppColors.accentYellow, shape: BoxShape.circle),
            ),
        ],
      ),
    );
  }

  String _iconFor(NotificationType type) {
    switch (type) {
      case NotificationType.transfer:
        return 'send';
      case NotificationType.security:
        return 'shield';
      case NotificationType.promo:
        return 'coins-alt';
      case NotificationType.system:
        return 'info-circle';
    }
  }
}