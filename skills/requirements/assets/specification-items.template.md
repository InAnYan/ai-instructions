<!-- Example: User-Facing Feature -->
### User can manage chat messages
`feat~chat.manage-messages~1`

The user can send, inspect, and delete messages within individual chat sessions.

Needs: req


<!-- Example: Detailed System Requirement covering the Feature -->
### System must delete message upon user request
`req~chat.delete-message~1`

The system permanently deletes a message from the database when requested by the author.

Rationale: Essential for privacy compliance (GDPR right to erasure) and conversation cleanup.

Covers: feat~chat.manage-messages~1

Needs: impl, utest


<!-- Example: Requirement with Edge Case & Issue Reference -->
### System must reject deletion of messages by non-authors
`req~chat.delete-message.permission-check~1`

When a deletion request is initiated by a user who is not the author, the system aborts the operation and returns an authorization error.

Issue: #142

Covers: feat~chat.manage-messages~1

Needs: impl, utest


<!-- Example: Forwarding (Feature covered directly without intermediate req) -->
### User can toggle dark mode
`feat~ui.toggle-dark-mode~1`

The user can switch between light and dark theme from the settings menu.

feat --> impl, utest : feat~ui.toggle-dark-mode~1


<!-- Example: Planned / Draft Requirement for Future Scope -->
### System must export conversation history in JSON format
`req~chat.export-history.json~1`

Status: draft

Needs: impl, utest
