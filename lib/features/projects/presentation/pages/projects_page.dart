import 'package:flutter/material.dart';
import '../../../../core/l10n/app_localizations.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.projects),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                child: Text('P${index + 1}'),
              ),
              title: Text('Project ${index + 1}'),
              subtitle: Text('Code: PRJ-${(index + 1).toString().padLeft(3, '0')}'),
              trailing: Chip(
                label: Text('${(index + 5) * 3} tasks'),
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
              onTap: () {
                // Navigate to project details
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Create new project
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
