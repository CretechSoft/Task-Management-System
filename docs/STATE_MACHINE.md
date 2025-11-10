# State Machine Documentation

## Task Status Flow

The task management system implements a strict state machine for task status transitions. This ensures data integrity and proper workflow enforcement.

### Status States

```
┌─────────┐
│  Draft  │ (Initial state - Task created but not ready)
└────┬────┘
     │
     v
┌──────────┐
│ Assigned │ (Task assigned to employee)
└────┬─────┘
     │
     v
┌──────────────┐
│ In Progress  │ (Employee working on task)
└───────┬──────┘
        │
        v
┌────────────────────────┐
│ Submitted for Review   │ (Employee submitted work)
└──────────┬─────────────┘
           │
           ├──────────────┐
           │              │
           v              v
    ┌─────────────┐  ┌─────────────┐
    │ QA Approved │  │ QA Rejected │
    │   (Done)    │  │  (Returned) │
    └─────────────┘  └──────┬──────┘
                            │
                            │ (loops back)
                            v
                     ┌──────────────┐
                     │ In Progress  │
                     └──────────────┘
```

### Allowed Transitions

| From Status | To Status | Who Can Perform | Notes |
|------------|-----------|-----------------|-------|
| Draft | Assigned | Admin, TeamLead | Initial assignment |
| Assigned | In Progress | Assignee, TeamLead | Start work |
| In Progress | Submitted for Review | Assignee | Submit completed work |
| Submitted for Review | QA Approved | QA, Admin | Accept work |
| Submitted for Review | QA Rejected | QA, Admin | Reject and return |
| QA Rejected | In Progress | Assignee, TeamLead | Rework after rejection |
| In Progress | Assigned | TeamLead | Reset if needed |

### State Properties

**Draft**
- Created but not yet assigned
- Can be edited freely
- No SLA tracking yet

**Assigned**
- Assigned to specific employee
- SLA countdown starts
- Employee notified

**In Progress**
- Employee actively working
- Progress can be updated (0-100%)
- Attachments can be added

**Submitted for Review**
- Work completed by employee
- Evidence/attachments should be present
- Waiting for QA review

**QA Approved**
- Final state (terminal)
- Work accepted
- Task completed successfully

**QA Rejected**
- Work rejected by QA
- Reason must be provided
- Returns to In Progress
- Original SLA may be extended

## Role-Based Permissions

### Admin
- Can perform any transition
- Can override any restriction
- Full audit log access

### Team Lead
- Create tasks (Draft state)
- Assign tasks (Draft → Assigned)
- Can move tasks back to earlier states
- Cannot QA approve/reject

### Employee/Assignee
- Start work (Assigned → In Progress)
- Update progress
- Submit for review (In Progress → Submitted)
- Resume after rejection (Rejected → In Progress)
- Cannot approve their own work

### QA
- Review submitted tasks
- Approve (Submitted → Approved)
- Reject (Submitted → Rejected)
- Cannot modify task details

## Audit Trail

Every status change is logged in the `TaskAudit` table:

```dart
@freezed
class TaskAudit with _$TaskAudit {
  const factory TaskAudit({
    required String id,
    required String taskId,
    required TaskStatus fromStatus,
    required TaskStatus toStatus,
    required String byUserId,
    String? note,
    required DateTime at,
  }) = _TaskAudit;
}
```

### Audit Log Example

```json
{
  "id": "aud-001",
  "taskId": "tsk-001",
  "fromStatus": "assigned",
  "toStatus": "in_progress",
  "byUserId": "usr-001",
  "note": "Started working on authentication module",
  "at": "2024-01-10T09:00:00Z"
}
```

## Validation Rules

### Status Change Validation

```dart
bool canChangeStatus(
  TaskStatus currentStatus,
  TaskStatus newStatus,
  UserRole userRole,
  String userId,
  String? assigneeId,
) {
  // Cannot stay in same status
  if (currentStatus == newStatus) return false;
  
  // Check role permissions
  switch (newStatus) {
    case TaskStatus.assigned:
      return userRole.isTeamLeadOrHigher;
    
    case TaskStatus.inProgress:
      return userRole.isAssignee(userId, assigneeId) ||
             userRole.isTeamLeadOrHigher;
    
    case TaskStatus.submittedForReview:
      return userRole.isAssignee(userId, assigneeId);
    
    case TaskStatus.qaApproved:
    case TaskStatus.qaRejected:
      return userRole.isQAOrHigher;
    
    default:
      return false;
  }
}
```

## SLA Management

### SLA States

Tasks have SLA tracking that affects notifications:

```dart
enum SLAState {
  onTrack,    // More than 24 hours remaining
  warning,    // 4-24 hours remaining
  critical,   // 0-4 hours remaining
  overdue,    // Past due date
}
```

### Escalation Rules

1. **24 hours before due**: Warning notification to assignee
2. **4 hours before due**: Critical notification to assignee + team lead
3. **1 hour before due**: Urgent notification to all stakeholders
4. **Overdue**: Daily notifications until resolved

### SLA Suspension

SLA tracking is suspended when task is:
- In QA Approved state (terminal)
- Waiting for QA review (Submitted for Review)
- Can be manually paused by Team Lead

## Workflow Examples

### Happy Path

```
1. TeamLead creates task → Draft
2. TeamLead assigns to Employee → Assigned
3. Employee starts work → In Progress
4. Employee updates progress (0% → 50% → 100%)
5. Employee submits → Submitted for Review
6. QA reviews and approves → QA Approved (Done)
```

### Rejection & Rework

```
1. Task in Progress → 100%
2. Employee submits → Submitted for Review
3. QA finds issues → QA Rejected
4. Employee reviews feedback → In Progress
5. Employee fixes issues → 100%
6. Employee resubmits → Submitted for Review
7. QA approves → QA Approved
```

### Reassignment

```
1. Task assigned to Employee A → Assigned
2. Employee A starts → In Progress
3. TeamLead reassigns to Employee B
4. Status remains In Progress
5. Employee B continues work
```

## Implementation Notes

### Database Triggers

Consider implementing database triggers for:
- Auto-creating audit entries
- Validating state transitions
- Updating timestamps
- Sending notifications

### Optimistic Locking

Use ETags or version numbers to prevent concurrent modifications:

```dart
class Task {
  final String id;
  final int version;
  // ... other fields
}
```

### Idempotency

Status change operations should be idempotent. Changing status to the same value should not create duplicate audit entries.

## Testing Checklist

- [ ] Verify all allowed transitions work
- [ ] Verify forbidden transitions are blocked
- [ ] Test role-based permissions
- [ ] Verify audit trail is created for each change
- [ ] Test concurrent status changes
- [ ] Verify SLA calculations
- [ ] Test notification triggers
- [ ] Verify rejection workflow
- [ ] Test edge cases (deleted users, deleted projects)
