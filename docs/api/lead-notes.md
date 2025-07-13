# 📝 Lead Notes API Documentation

## Overview

The Lead Notes API provides comprehensive functionality for managing notes and comments associated with leads in the LeadEstate CRM system. This includes creating, reading, updating, and managing note history.

## Base URL

```
https://your-agency-backend.onrender.com/api
```

## Authentication

All API endpoints require authentication using JWT tokens:

```javascript
headers: {
  'Authorization': 'Bearer YOUR_JWT_TOKEN',
  'Content-Type': 'application/json'
}
```

## Endpoints

### 1. Get All Notes for a Lead

**GET** `/leads/{leadId}/notes`

Retrieves all notes associated with a specific lead, ordered by creation date (newest first).

#### Parameters
- `leadId` (path parameter): The unique identifier of the lead

#### Response
```json
{
  "success": true,
  "message": "Notes retrieved successfully",
  "data": [
    {
      "id": "note_123",
      "content": "Initial contact made via phone. Client interested in 3-bedroom apartments.",
      "type": "note",
      "createdBy": "Sarah Johnson",
      "createdAt": "2024-12-13T10:30:00Z",
      "isPrivate": false,
      "metadata": {
        "source": "phone_call",
        "duration": "15_minutes"
      }
    },
    {
      "id": "note_124",
      "content": "Follow-up call scheduled for tomorrow at 2 PM.",
      "type": "reminder",
      "createdBy": "Sarah Johnson",
      "createdAt": "2024-12-13T11:15:00Z",
      "isPrivate": false,
      "metadata": {
        "reminder_date": "2024-12-14T14:00:00Z"
      }
    }
  ]
}
```

#### Error Response
```json
{
  "success": false,
  "message": "Lead not found",
  "data": null,
  "error": "Lead with ID 123 does not exist"
}
```

### 2. Add New Note to Lead

**POST** `/leads/{leadId}/notes`

Creates a new note for the specified lead.

#### Parameters
- `leadId` (path parameter): The unique identifier of the lead

#### Request Body
```json
{
  "content": "Client showed strong interest in the downtown property. Scheduling viewing for next week.",
  "type": "note",
  "createdBy": "Mike Chen",
  "isPrivate": false,
  "metadata": {
    "property_id": "prop_456",
    "viewing_date": "2024-12-20T10:00:00Z"
  }
}
```

#### Response
```json
{
  "success": true,
  "message": "Note added successfully",
  "data": {
    "id": "note_125",
    "content": "Client showed strong interest in the downtown property. Scheduling viewing for next week.",
    "type": "note",
    "createdBy": "Mike Chen",
    "createdAt": "2024-12-13T14:22:00Z",
    "isPrivate": false,
    "metadata": {
      "property_id": "prop_456",
      "viewing_date": "2024-12-20T10:00:00Z"
    }
  }
}
```

### 3. Update Note

**PUT** `/leads/{leadId}/notes/{noteId}`

Updates an existing note. Only the note creator or managers can update notes.

#### Parameters
- `leadId` (path parameter): The unique identifier of the lead
- `noteId` (path parameter): The unique identifier of the note

#### Request Body
```json
{
  "content": "Updated: Client confirmed viewing appointment for downtown property on Dec 20th at 10 AM.",
  "isPrivate": true
}
```

#### Response
```json
{
  "success": true,
  "message": "Note updated successfully",
  "data": {
    "id": "note_125",
    "content": "Updated: Client confirmed viewing appointment for downtown property on Dec 20th at 10 AM.",
    "type": "note",
    "createdBy": "Mike Chen",
    "createdAt": "2024-12-13T14:22:00Z",
    "updatedAt": "2024-12-13T15:30:00Z",
    "isPrivate": true,
    "metadata": {
      "property_id": "prop_456",
      "viewing_date": "2024-12-20T10:00:00Z"
    }
  }
}
```

### 4. Delete Note

**DELETE** `/leads/{leadId}/notes/{noteId}`

Deletes a note. Only the note creator or managers can delete notes.

#### Parameters
- `leadId` (path parameter): The unique identifier of the lead
- `noteId` (path parameter): The unique identifier of the note

#### Response
```json
{
  "success": true,
  "message": "Note deleted successfully",
  "data": null
}
```

## Note Types

The system supports different types of notes:

| Type | Description | Use Case |
|------|-------------|----------|
| `note` | General note or comment | Standard communication logs |
| `reminder` | Reminder for future action | Follow-up tasks and appointments |
| `call_log` | Phone call record | Call history and outcomes |
| `email_log` | Email communication record | Email correspondence tracking |
| `meeting` | Meeting or viewing record | Property viewings and meetings |
| `system` | System-generated note | Automated status changes |

## Privacy Levels

Notes can have different privacy levels:

- **Public** (`isPrivate: false`): Visible to all team members
- **Private** (`isPrivate: true`): Visible only to the creator and managers

## Metadata Structure

Notes can include metadata for additional context:

```json
{
  "metadata": {
    "source": "phone_call|email|meeting|system",
    "duration": "15_minutes",
    "property_id": "prop_123",
    "viewing_date": "2024-12-20T10:00:00Z",
    "outcome": "interested|not_interested|follow_up_needed",
    "next_action": "schedule_viewing|send_brochure|follow_up_call",
    "priority": "low|medium|high|urgent"
  }
}
```

## Error Codes

| Code | Message | Description |
|------|---------|-------------|
| 400 | Bad Request | Invalid request data or missing required fields |
| 401 | Unauthorized | Invalid or missing authentication token |
| 403 | Forbidden | Insufficient permissions to perform action |
| 404 | Not Found | Lead or note not found |
| 500 | Internal Server Error | Server error occurred |

## Rate Limiting

- **Rate Limit**: 100 requests per minute per user
- **Burst Limit**: 20 requests per 10 seconds
- **Headers**: Rate limit information included in response headers

## Examples

### JavaScript/React Example

```javascript
// Get all notes for a lead
const fetchNotes = async (leadId) => {
  try {
    const response = await fetch(`${API_URL}/leads/${leadId}/notes`, {
      headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json'
      }
    });
    
    const result = await response.json();
    if (result.success) {
      return result.data;
    } else {
      throw new Error(result.message);
    }
  } catch (error) {
    console.error('Error fetching notes:', error);
    throw error;
  }
};

// Add a new note
const addNote = async (leadId, noteData) => {
  try {
    const response = await fetch(`${API_URL}/leads/${leadId}/notes`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(noteData)
    });
    
    const result = await response.json();
    if (result.success) {
      return result.data;
    } else {
      throw new Error(result.message);
    }
  } catch (error) {
    console.error('Error adding note:', error);
    throw error;
  }
};
```

### Node.js Example

```javascript
const axios = require('axios');

// Add note with error handling
const addLeadNote = async (leadId, content, type = 'note') => {
  try {
    const response = await axios.post(
      `${API_URL}/leads/${leadId}/notes`,
      {
        content,
        type,
        createdBy: user.name,
        isPrivate: false
      },
      {
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json'
        }
      }
    );
    
    return response.data.data;
  } catch (error) {
    if (error.response) {
      console.error('API Error:', error.response.data.message);
    } else {
      console.error('Network Error:', error.message);
    }
    throw error;
  }
};
```

## Best Practices

1. **Content Validation**: Always validate note content before sending
2. **Error Handling**: Implement comprehensive error handling
3. **Rate Limiting**: Respect API rate limits
4. **Privacy**: Use appropriate privacy levels for sensitive information
5. **Metadata**: Include relevant metadata for better context
6. **Real-time Updates**: Consider implementing WebSocket for real-time note updates

---

For more information, see the [Assignment History API](assignment-history.md) documentation.
