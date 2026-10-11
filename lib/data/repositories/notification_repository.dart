import '../models/notification_item.dart';

abstract class NotificationRepository {
  Future<List<NotificationItem>> getNotifications();
}

class MockNotificationRepository implements NotificationRepository {
  @override
  Future<List<NotificationItem>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      NotificationItem(
        title: 'Transfer completed',
        message: 'You sent 250 USDC to Cynthia Nkechi.',
        time: '2m ago',
        type: NotificationType.transfer,
        isRead: false,
      ),
      NotificationItem(
        title: 'New login detected',
        message: 'A new device just logged into your account.',
        time: '1h ago',
        type: NotificationType.security,
        isRead: false,
      ),
      NotificationItem(
        title: 'KYC Verified',
        message: 'Your identity has been successfully verified.',
        time: '1d ago',
        type: NotificationType.system,
        isRead: true,
      ),
      NotificationItem(
        title: 'Referral bonus earned',
        message: 'You earned ₦500 for inviting a friend.',
        time: '3d ago',
        type: NotificationType.promo,
        isRead: true,
      ),
    ];
  }
}