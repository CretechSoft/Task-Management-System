import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.dashboard),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.push('/notifications'),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    child: Icon(Icons.person, size: 40),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'User Name',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                  Text(
                    'user@example.com',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onPrimary.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: Text(l10n.dashboard),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.task),
              title: Text(l10n.tasks),
              onTap: () {
                Navigator.pop(context);
                context.push('/tasks');
              },
            ),
            ListTile(
              leading: const Icon(Icons.folder),
              title: Text(l10n.projects),
              onTap: () {
                Navigator.pop(context);
                context.push('/projects');
              },
            ),
            ListTile(
              leading: const Icon(Icons.business),
              title: Text(l10n.departments),
              onTap: () {
                Navigator.pop(context);
                context.push('/departments');
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: Text(l10n.employees),
              onTap: () {
                Navigator.pop(context);
                context.push('/employees');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(l10n.logout),
              onTap: () {
                context.go('/login');
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // KPI Cards
            Row(
              children: [
                Expanded(
                  child: _KPICard(
                    title: l10n.todayTasks,
                    value: '12',
                    icon: Icons.today,
                    color: AppTheme.assignedColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _KPICard(
                    title: l10n.overdueTasks,
                    value: '3',
                    icon: Icons.warning_amber,
                    color: AppTheme.urgentPriorityColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _KPICard(
                    title: 'In Progress',
                    value: '8',
                    icon: Icons.pending_actions,
                    color: AppTheme.inProgressColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _KPICard(
                    title: 'Completed',
                    value: '45',
                    icon: Icons.check_circle,
                    color: AppTheme.approvedColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Quick Actions
            Text(
              'Quick Actions',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _QuickActionButton(
                  label: l10n.createTask,
                  icon: Icons.add_task,
                  onPressed: () => context.push('/tasks/new'),
                ),
                _QuickActionButton(
                  label: l10n.tasks,
                  icon: Icons.list,
                  onPressed: () => context.push('/tasks'),
                ),
                _QuickActionButton(
                  label: l10n.projects,
                  icon: Icons.folder_open,
                  onPressed: () => context.push('/projects'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Recent Tasks
            Text(
              'Recent Tasks',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            
            // Sample tasks
            _TaskListItem(
              title: 'Implement authentication module',
              status: 'In Progress',
              priority: 'High',
              dueDate: 'Today',
              onTap: () => context.push('/tasks/1'),
            ),
            _TaskListItem(
              title: 'Design user interface mockups',
              status: 'Submitted for Review',
              priority: 'Medium',
              dueDate: 'Tomorrow',
              onTap: () => context.push('/tasks/2'),
            ),
            _TaskListItem(
              title: 'Write technical documentation',
              status: 'Assigned',
              priority: 'Low',
              dueDate: 'Next week',
              onTap: () => context.push('/tasks/3'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/tasks/new'),
        icon: const Icon(Icons.add),
        label: Text(l10n.createTask),
      ),
    );
  }
}

class _KPICard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _KPICard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const Spacer(),
                Text(
                  value,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _QuickActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}

class _TaskListItem extends StatelessWidget {
  final String title;
  final String status;
  final String priority;
  final String dueDate;
  final VoidCallback onTap;

  const _TaskListItem({
    required this.title,
    required this.status,
    required this.priority,
    required this.dueDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        title: Text(title),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              Chip(
                label: Text(status, style: const TextStyle(fontSize: 12)),
                backgroundColor: AppTheme.getStatusColor(status).withOpacity(0.2),
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
              Chip(
                label: Text(priority, style: const TextStyle(fontSize: 12)),
                backgroundColor: AppTheme.getPriorityColor(priority).withOpacity(0.2),
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Icon(Icons.schedule, size: 16, color: theme.colorScheme.onSurface.withOpacity(0.6)),
            const SizedBox(height: 4),
            Text(
              dueDate,
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
