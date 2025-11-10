import 'package:flutter/material.dart';
import '../../../../core/l10n/app_localizations.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool _showUnreadOnly = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notifications),
        actions: [
          FilterChip(
            label: const Text('Unread only'),
            selected: _showUnreadOnly,
            onSelected: (value) {
              setState(() {
                _showUnreadOnly = value;
              });
            },
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.done_all),
            tooltip: 'Mark all as read',
            onPressed: () {
              // Mark all as read
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index) {
          final isRead = index % 3 == 0;
          final notificationTypes = [
            {'icon': Icons.assignment, 'title': 'Task Assigned', 'message': 'You have been assigned to task #${index + 1}'},
            {'icon': Icons.comment, 'title': 'New Comment', 'message': 'Someone commented on your task'},
            {'icon': Icons.check_circle, 'title': 'Task Approved', 'message': 'Task #${index + 1} has been approved'},
            {'icon': Icons.warning, 'title': 'SLA Warning', 'message': 'Task #${index + 1} is approaching deadline'},
            {'icon': Icons.person_add, 'title': 'Mention', 'message': 'You were mentioned in a comment'},
          ];
          
          final notification = notificationTypes[index % notificationTypes.length];
          
          return Container(
            color: isRead ? null : theme.colorScheme.primaryContainer.withOpacity(0.1),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: isRead
                    ? theme.colorScheme.surfaceVariant
                    : theme.colorScheme.primaryContainer,
                child: Icon(
                  notification['icon'] as IconData,
                  color: isRead
                      ? theme.colorScheme.onSurfaceVariant
                      : theme.colorScheme.onPrimaryContainer,
                ),
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      notification['title'] as String,
                      style: TextStyle(
                        fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                      ),
                    ),
                  ),
                  if (!isRead)
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(notification['message'] as String),
                  const SizedBox(height: 4),
                  Text(
                    '${index + 1} hour${index + 1 > 1 ? 's' : ''} ago',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
              isThreeLine: true,
              onTap: () {
                // Handle notification tap
              },
            ),
          );
        },
      ),
    );
  }
}
