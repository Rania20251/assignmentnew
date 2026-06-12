import 'package:flutter/material.dart';
import '../services/notification_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState
    extends State<NotificationsScreen> {
  late Future<List<Map<String, dynamic>>> notificationsFuture;

  @override
  void initState() {
    super.initState();
    loadNotifications();
  }

  void loadNotifications() {
    notificationsFuture =
        NotificationService.getNotifications();
  }

  Future<void> clearAll() async {
    await NotificationService.clearNotifications();

    setState(() {
      loadNotifications();
    });
  }

  IconData getIcon(String type) {
    switch (type) {
      case 'appointment':
        return Icons.calendar_month;

      case 'upload':
        return Icons.description;

      case 'delete':
        return Icons.delete;

      default:
        return Icons.notifications;
    }
  }

  Color getColor(String type) {
    switch (type) {
      case 'appointment':
        return const Color(0xff5B2EFF);

      case 'upload':
        return Colors.green;

      case 'delete':
        return Colors.red;

      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),

      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,

        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: clearAll,
          ),
        ],
      ),

      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: notificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final notifications =
              snapshot.data ?? [];

          if (notifications.isEmpty) {
            return const Center(
              child: Text(
                'No notifications yet',
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(18),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final item = notifications[index];

              final type =
                  item['type']?.toString() ?? '';

              return notificationCard(
                icon: getIcon(type),
                color: getColor(type),
                title:
                item['title']?.toString() ?? '',
                subtitle:
                item['message']?.toString() ?? '',
              );
            },
          );
        },
      ),
    );
  }

  Widget notificationCard({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        children: [
          CircleAvatar(
            backgroundColor:
            color.withOpacity(.15),

            child: Icon(
              icon,
              color: color,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight:
                    FontWeight.bold,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.grey,
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