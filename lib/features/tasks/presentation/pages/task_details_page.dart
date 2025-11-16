import 'package:flutter/material.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/task.dart';

class TaskDetailsPage extends StatefulWidget {
  final String taskId;

  const TaskDetailsPage({
    super.key,
    required this.taskId,
  });

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    // Sample task data
    final task = _SampleTask(
      id: widget.taskId,
      title: 'Implement authentication module',
      description:
          'Create a comprehensive authentication system with login, registration, and password reset functionality. Include social login options and two-factor authentication.',
      status: TaskStatus.inProgress,
      priority: TaskPriority.high,
      progress: 65,
      dueDate: DateTime.now().add(const Duration(days: 3)),
      assignee: 'John Doe',
      project: 'Mobile App Rewrite',
      department: 'Engineering',
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Task #${widget.taskId}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to edit task
            },
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share),
                    SizedBox(width: 8),
                    Text('Share'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete),
                    SizedBox(width: 8),
                    Text('Delete'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Task Header
          Container(
            padding: const EdgeInsets.all(16.0),
            color: theme.colorScheme.surfaceVariant,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _StatusChip(status: task.status),
                    _PriorityChip(priority: task.priority),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Progress
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: task.progress / 100,
                        backgroundColor: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${task.progress}%',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Tabs
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: l10n.taskDescription),
              Tab(text: l10n.attachments),
              Tab(text: l10n.comments),
            ],
          ),
          
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDetailsTab(context, task),
                _buildAttachmentsTab(context),
                _buildCommentsTab(context),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildActionBar(context, task),
    );
  }

  Widget _buildDetailsTab(BuildContext context, _SampleTask task) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description
          Text(
            l10n.taskDescription,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            task.description,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          
          // Details Grid
          _DetailItem(
            label: l10n.assignee,
            value: task.assignee,
            icon: Icons.person,
          ),
          const SizedBox(height: 12),
          _DetailItem(
            label: l10n.projects,
            value: task.project,
            icon: Icons.folder,
          ),
          const SizedBox(height: 12),
          _DetailItem(
            label: l10n.departments,
            value: task.department,
            icon: Icons.business,
          ),
          const SizedBox(height: 12),
          _DetailItem(
            label: l10n.dueDate,
            value: _formatDate(task.dueDate),
            icon: Icons.calendar_today,
          ),
          const SizedBox(height: 24),
          
          // Checklist
          Text(
            'Checklist',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          _ChecklistItem(
            text: 'Design database schema',
            isDone: true,
          ),
          _ChecklistItem(
            text: 'Implement user model',
            isDone: true,
          ),
          _ChecklistItem(
            text: 'Create authentication API',
            isDone: false,
          ),
          _ChecklistItem(
            text: 'Write unit tests',
            isDone: false,
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentsTab(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return _AttachmentCard(
          type: index % 3 == 0
              ? AttachmentType.image
              : index % 3 == 1
                  ? AttachmentType.pdf
                  : AttachmentType.video,
          name: 'Attachment ${index + 1}',
        );
      },
    );
  }

  Widget _buildCommentsTab(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: 5,
            itemBuilder: (context, index) {
              return _CommentItem(
                author: 'User ${index + 1}',
                text: 'This is comment ${index + 1}. Great progress on this task!',
                time: DateTime.now().subtract(Duration(hours: index * 2)),
              );
            },
          ),
        ),
        _buildCommentInput(context),
      ],
    );
  }

  Widget _buildCommentInput(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Add a comment...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filledTonal(
            icon: const Icon(Icons.send),
            onPressed: () {
              // Send comment
              _commentController.clear();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionBar(BuildContext context, _SampleTask task) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                _showStatusChangeDialog(context, task.status);
              },
              child: const Text('Change Status'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton(
              onPressed: () {
                // Update progress
              },
              child: const Text('Update Progress'),
            ),
          ),
        ],
      ),
    );
  }

  void _showStatusChangeDialog(BuildContext context, TaskStatus currentStatus) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: TaskStatus.values.map((status) {
              return RadioListTile<TaskStatus>(
                title: Text(_getStatusText(status)),
                value: status,
                groupValue: currentStatus,
                onChanged: (value) {
                  Navigator.pop(context);
                  // Update status
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _StatusChip extends StatelessWidget {
  final TaskStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = AppTheme.getStatusColor(status.name);
    
    return Chip(
      label: Text(
        _getStatusText(),
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
      backgroundColor: color.withOpacity(0.2),
    );
  }

  String _getStatusText() {
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
}

class _PriorityChip extends StatelessWidget {
  final TaskPriority priority;

  const _PriorityChip({required this.priority});

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.getPriorityColor(priority.name);
    
    return Chip(
      avatar: Icon(Icons.flag, size: 18, color: color),
      label: Text(
        _getPriorityText(),
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
      backgroundColor: color.withOpacity(0.2),
    );
  }

  String _getPriorityText() {
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

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _DetailItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChecklistItem extends StatefulWidget {
  final String text;
  final bool isDone;

  const _ChecklistItem({
    required this.text,
    required this.isDone,
  });

  @override
  State<_ChecklistItem> createState() => _ChecklistItemState();
}

class _ChecklistItemState extends State<_ChecklistItem> {
  late bool _isDone;

  @override
  void initState() {
    super.initState();
    _isDone = widget.isDone;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return CheckboxListTile(
      value: _isDone,
      onChanged: (value) {
        setState(() {
          _isDone = value ?? false;
        });
      },
      title: Text(
        widget.text,
        style: theme.textTheme.bodyMedium?.copyWith(
          decoration: _isDone ? TextDecoration.lineThrough : null,
        ),
      ),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
    );
  }
}

class _AttachmentCard extends StatelessWidget {
  final AttachmentType type;
  final String name;

  const _AttachmentCard({
    required this.type,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // Open attachment
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                color: theme.colorScheme.surfaceVariant,
                child: Icon(
                  _getIcon(),
                  size: 48,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                name,
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon() {
    switch (type) {
      case AttachmentType.image:
        return Icons.image;
      case AttachmentType.pdf:
        return Icons.picture_as_pdf;
      case AttachmentType.video:
        return Icons.video_file;
      case AttachmentType.doc:
        return Icons.description;
      case AttachmentType.link:
        return Icons.link;
    }
  }
}

class _CommentItem extends StatelessWidget {
  final String author;
  final String text;
  final DateTime time;

  const _CommentItem({
    required this.author,
    required this.text,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            child: Text(author[0]),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      author,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatTime(time),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inMinutes}m ago';
    }
  }
}

class _SampleTask {
  final String id;
  final String title;
  final String description;
  final TaskStatus status;
  final TaskPriority priority;
  final int progress;
  final DateTime dueDate;
  final String assignee;
  final String project;
  final String department;

  _SampleTask({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.progress,
    required this.dueDate,
    required this.assignee,
    required this.project,
    required this.department,
  });
}
