import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../domain/entities/task.dart';

class CreateTaskPage extends StatefulWidget {
  const CreateTaskPage({super.key});

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  TaskPriority _selectedPriority = TaskPriority.medium;
  DateTime? _dueDate;
  final List<String> _attachments = [];
  final List<_ChecklistItemData> _checklistItems = [];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.createTask),
        actions: [
          TextButton(
            onPressed: _saveTask,
            child: Text(
              l10n.save,
              style: TextStyle(color: theme.colorScheme.primary),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Title
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: l10n.taskTitle,
                prefixIcon: const Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Description
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: l10n.taskDescription,
                prefixIcon: const Icon(Icons.description),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Priority
            DropdownButtonFormField<TaskPriority>(
              value: _selectedPriority,
              decoration: InputDecoration(
                labelText: l10n.priority,
                prefixIcon: const Icon(Icons.flag),
              ),
              items: TaskPriority.values.map((priority) {
                return DropdownMenuItem(
                  value: priority,
                  child: Text(_getPriorityLabel(priority)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedPriority = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            
            // Project (Placeholder)
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: l10n.projects,
                prefixIcon: const Icon(Icons.folder),
              ),
              items: ['Project 1', 'Project 2', 'Project 3'].map((project) {
                return DropdownMenuItem(
                  value: project,
                  child: Text(project),
                );
              }).toList(),
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            
            // Department (Placeholder)
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: l10n.departments,
                prefixIcon: const Icon(Icons.business),
              ),
              items: ['Engineering', 'Design', 'QA'].map((dept) {
                return DropdownMenuItem(
                  value: dept,
                  child: Text(dept),
                );
              }).toList(),
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            
            // Assignee (Placeholder)
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: l10n.assignee,
                prefixIcon: const Icon(Icons.person),
              ),
              items: ['John Doe', 'Jane Smith', 'Bob Johnson'].map((user) {
                return DropdownMenuItem(
                  value: user,
                  child: Text(user),
                );
              }).toList(),
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            
            // Due Date
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(
                _dueDate == null
                    ? 'Select Due Date'
                    : 'Due: ${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}',
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) {
                  setState(() {
                    _dueDate = date;
                  });
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: theme.colorScheme.outline),
              ),
            ),
            const SizedBox(height: 24),
            
            // Checklist Section
            Row(
              children: [
                Text(
                  'Checklist',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: _addChecklistItem,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Item'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            ..._checklistItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: item.controller,
                        decoration: InputDecoration(
                          hintText: 'Checklist item ${index + 1}',
                          isDense: true,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _removeChecklistItem(index),
                    ),
                  ],
                ),
              );
            }).toList(),
            const SizedBox(height: 24),
            
            // Attachments Section
            Row(
              children: [
                Text(
                  l10n.attachments,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: _addAttachment,
                  icon: const Icon(Icons.attach_file),
                  label: const Text('Add File'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            if (_attachments.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _attachments.map((attachment) {
                  return Chip(
                    label: Text(attachment),
                    onDeleted: () {
                      setState(() {
                        _attachments.remove(attachment);
                      });
                    },
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  void _addChecklistItem() {
    setState(() {
      _checklistItems.add(_ChecklistItemData());
    });
  }

  void _removeChecklistItem(int index) {
    setState(() {
      _checklistItems[index].controller.dispose();
      _checklistItems.removeAt(index);
    });
  }

  void _addAttachment() {
    // TODO: Implement file picker
    setState(() {
      _attachments.add('sample_file_${_attachments.length + 1}.pdf');
    });
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      // TODO: Save task
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task created successfully')),
      );
      context.pop();
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

class _ChecklistItemData {
  final TextEditingController controller = TextEditingController();

  void dispose() {
    controller.dispose();
  }
}
