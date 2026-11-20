# Chat Service Specifications

<!-- Features are defined under H2 headings -->
## User can manage AI chat conversations
`feat~ai.chat~1`

The user can send prompts, view responses, and manage message history within chat sessions.

Needs: req


<!-- Requirements are defined under H3 headings, directly within the covering feature's H2 section -->
### System must delete message upon user request
`req~ai.chat.message.delete~1`

The system permanently deletes a message from the database when requested by the author.

Rationale: Essential for privacy compliance (GDPR right to erasure) and conversation management.

Covers: feat~ai.chat~1

Needs: impl, utest


### System must reject deletion of messages by non-authors
`req~ai.chat.message.delete.permission-check~1`

When a deletion request is initiated by a user who is not the author, the system aborts the operation and returns an authorization error.

Issue: #142

Covers: feat~ai.chat~1

Needs: impl, utest


### System must regenerate message upon user request
`req~ai.chat.message.regenerate~1`

Status: draft

Needs: impl, utest


<!-- Example of Feature Forwarding (no intermediate req needed) -->
## User can toggle dark mode
`feat~ui.theme.dark-mode~1`

The user can switch between light and dark theme from the settings menu.

feat --> impl, utest : feat~ui.theme.dark-mode~1
