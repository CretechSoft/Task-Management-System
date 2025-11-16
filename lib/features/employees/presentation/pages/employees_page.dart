import 'package:flutter/material.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../domain/entities/user.dart';

class EmployeesPage extends StatelessWidget {
  const EmployeesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.employees),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: 15,
        itemBuilder: (context, index) {
          final roles = UserRole.values;
          final role = roles[index % roles.length];
          
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Text(
                  'U${index + 1}',
                  style: TextStyle(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              title: Text('Employee ${index + 1}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text('employee${index + 1}@example.com'),
                  const SizedBox(height: 4),
                  Chip(
                    label: Text(
                      _getRoleLabel(role),
                      style: const TextStyle(fontSize: 12),
                    ),
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              trailing: Icon(
                Icons.circle,
                color: index % 3 == 0 ? Colors.green : Colors.grey,
                size: 12,
              ),
              isThreeLine: true,
              onTap: () {
                // Navigate to employee details
              },
            ),
          );
        },
      ),
    );
  }

  String _getRoleLabel(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.teamLead:
        return 'Team Lead';
      case UserRole.employee:
        return 'Employee';
      case UserRole.qa:
        return 'QA';
    }
  }
}
