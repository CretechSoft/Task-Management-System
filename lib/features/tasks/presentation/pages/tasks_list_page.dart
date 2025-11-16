import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/task.dart';

class TasksListPage extends StatefulWidget {
  const TasksListPage({super.key});

  @override
  State<TasksListPage> createState() => _TasksListPageState();
}

class _TasksListPageState extends State<TasksListPage> {
  final _searchController = TextEditingController();
  TaskStatus? _selectedStatus;
  TaskPriority? _selectedPriority;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tasks),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: _TaskSearchDelegate(),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilters(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Active Filters
          if (_selectedStatus != null || _selectedPriority != null)
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8,
                children: [
                  if (_selectedStatus != null)
                    Chip(
                      label: Text(_getStatusLabel(_selectedStatus!)),
                      onDeleted: () {
                        setState(() => _selectedStatus = null);
                      },
                    ),
                  if (_selectedPriority != null)
                    Chip(
                      label: Text(_getPriorityLabel(_selectedPriority!)),
                      onDeleted: () {
                        setState(() => _selectedPriority = null);
                      },
                    ),
                ],
              ),
            ),
          
          // Task List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: 10, // Sample data
              itemBuilder: (context, index) {
                return _TaskCard(
                  task: _SampleTask(
                    id: '$index',
                    title: 'Task ${index + 1}: Complete implementation',
                    description: 'This is a detailed description of task ${index + 1}',
                    status: TaskStatus.values[index % TaskStatus.values.length],
                    priority: TaskPriority.values[index % TaskPriority.values.length],
                    progress: (index * 10) % 100,
                    dueDate: DateTime.now().add(Duration(days: index)),
                  ),
                  onTap: () => context.push('/tasks/${index + 1}'),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/tasks/new'),
        icon: const Icon(Icons.add),
        label: Text(l10n.createTask),
      ),
    );
  }

  void _showFilters(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filters',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                
                // Status Filter
                Text(
                  'Status',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Wrap(
                  spacing: 8,
                  children: TaskStatus.values.map((status) {
                    return FilterChip(
                      label: Text(_getStatusLabel(status)),
                      selected: _selectedStatus == status,
                      onSelected: (selected) {
                        setModalState(() {
                          _selectedStatus = selected ? status : null;
                        });
                        setState(() {
                          _selectedStatus = selected ? status : null;
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                
                // Priority Filter
                Text(
                  'Priority',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Wrap(
                  spacing: 8,
                  children: TaskPriority.values.map((priority) {
                    return FilterChip(
                      label: Text(_getPriorityLabel(priority)),
                      selected: _selectedPriority == priority,
                      onSelected: (selected) {
                        setModalState(() {
                          _selectedPriority = selected ? priority : null;
                        });
                        setState(() {
                          _selectedPriority = selected ? priority : null;
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setModalState(() {
                            _selectedStatus = null;
                            _selectedPriority = null;
                          });
                          setState(() {
                            _selectedStatus = null;
                            _selectedPriority = null;
                          });
                        },
                        child: const Text('Clear All'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Apply'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getStatusLabel(TaskStatus status) {
    switch (status) {
      case TaskStatus.draft:
        return 'Draft';
      case TaskStatus.assigned:
        return 'Assigned';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.submittedForReview:
        return 'Submitted';
      case TaskStatus.qaApproved:
        return 'Approved';
      case TaskStatus.qaRejected:
        return 'Rejected';
    }
  }

  String _getPriorityLabel(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
      case TaskPriority.urgent:
        return 'Urgent';
    }
  }
}

class _TaskCard extends StatelessWidget {
  final _SampleTask task;
  final VoidCallback onTap;

  const _TaskCard({
    required this.task,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(task.status).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _getStatusText(task.status),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: _getStatusColor(task.status),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              if (task.description != null) ...[
                const SizedBox(height: 8),
                Text(
                  task.description!,
                  style: theme.textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),
              
              // Priority and Due Date
              Row(
                children: [
                  Icon(
                    Icons.flag,
                    size: 16,
                    color: _getPriorityColor(task.priority),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _getPriorityText(task.priority),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: _getPriorityColor(task.priority),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(task.dueDate),
                    style: theme.textTheme.bodySmall,
                  ),
                  const Spacer(),
                  Text(
                    '${task.progress}%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              // Progress Bar
              LinearProgressIndicator(
                value: task.progress / 100,
                backgroundColor: theme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(TaskStatus status) => AppTheme.getStatusColor(status.name);
  Color _getPriorityColor(TaskPriority priority) => AppTheme.getPriorityColor(priority.name);

  String _getStatusText(TaskStatus status) {
    switch (status) {
      case TaskStatus.draft:
        return 'Draft';
      case TaskStatus.assigned:
        return 'Assigned';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.submittedForReview:
        return 'Submitted';
      case TaskStatus.qaApproved:
        return 'Approved';
      case TaskStatus.qaRejected:
        return 'Rejected';
    }
  }

  String _getPriorityText(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
      case TaskPriority.urgent:
        return 'Urgent';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;
    
    if (difference == 0) return 'Today';
    if (difference == 1) return 'Tomorrow';
    if (difference < 0) return 'Overdue';
    return '${difference}d';
  }
}

class _SampleTask {
  final String id;
  final String title;
  final String? description;
  final TaskStatus status;
  final TaskPriority priority;
  final int progress;
  final DateTime dueDate;

  _SampleTask({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    required this.priority,
    required this.progress,
    required this.dueDate,
  });
}

class _TaskSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Search result $index for: $query'),
          onTap: () {
            close(context, query);
            context.push('/tasks/${index + 1}');
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.task),
          title: Text('Suggestion $index'),
          onTap: () {
            query = 'Suggestion $index';
            showResults(context);
          },
        );
      },
    );
  }
}
