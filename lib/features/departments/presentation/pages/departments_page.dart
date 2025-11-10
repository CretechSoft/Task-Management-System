import 'package:flutter/material.dart';
import '../../../../core/l10n/app_localizations.dart';

class DepartmentsPage extends StatelessWidget {
  const DepartmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.departments),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: 6,
        itemBuilder: (context, index) {
          final departments = [
            {'name': 'Engineering', 'code': 'ENG', 'count': 45},
            {'name': 'Design', 'code': 'DES', 'count': 12},
            {'name': 'Quality Assurance', 'code': 'QA', 'count': 18},
            {'name': 'Marketing', 'code': 'MKT', 'count': 8},
            {'name': 'Sales', 'code': 'SAL', 'count': 15},
            {'name': 'Human Resources', 'code': 'HR', 'count': 6},
          ];
          
          final dept = departments[index];
          
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(dept['code'] as String),
              ),
              title: Text(dept['name'] as String),
              subtitle: Text('Code: ${dept['code']}'),
              trailing: Chip(
                label: Text('${dept['count']} employees'),
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
              onTap: () {
                // Navigate to department details
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Create new department
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
