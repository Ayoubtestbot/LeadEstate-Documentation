# 📋 Assignment History API Documentation

## Overview

The Assignment History API tracks and manages the complete history of lead assignments within the LeadEstate CRM system. This includes tracking when leads are assigned, reassigned, or unassigned, along with the reasons and responsible parties.

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

### 1. Get Assignment History for a Lead

**GET** `/leads/{leadId}/assignee-history`

Retrieves the complete assignment history for a specific lead, ordered by date (newest first).

#### Parameters
- `leadId` (path parameter): The unique identifier of the lead

#### Response
```json
{
  "success": true,
  "message": "Assignment history retrieved successfully",
  "data": [
    {
      "id": "history_123",
      "fromAgent": "John Smith",
      "toAgent": "Sarah Johnson",
      "changedAt": "2024-12-13T10:30:00Z",
      "changedBy": "Mike Chen",
      "reason": "Workload redistribution",
      "actionType": "reassignment",
      "metadata": {
        "previous_workload": 45,
        "new_workload": 32,
        "priority_level": "high"
      }
    },
    {
      "id": "history_122",
      "fromAgent": null,
      "toAgent": "John Smith",
      "changedAt": "2024-12-10T09:15:00Z",
      "changedBy": "System",
      "reason": "Initial assignment",
      "actionType": "initial_assignment",
      "metadata": {
        "assignment_method": "round_robin",
        "agent_availability": true
      }
    }
  ]
}
```

### 2. Create Assignment History Record

**POST** `/leads/{leadId}/assignee-history`

Creates a new assignment history record when a lead is assigned or reassigned.

#### Parameters
- `leadId` (path parameter): The unique identifier of the lead

#### Request Body
```json
{
  "fromAgent": "John Smith",
  "toAgent": "Sarah Johnson",
  "changedBy": "Mike Chen",
  "reason": "Agent specialization in luxury properties",
  "actionType": "reassignment",
  "metadata": {
    "property_type": "luxury",
    "agent_expertise": "luxury_specialist",
    "client_preference": "female_agent"
  }
}
```

#### Response
```json
{
  "success": true,
  "message": "Assignment history recorded successfully",
  "data": {
    "id": "history_124",
    "fromAgent": "John Smith",
    "toAgent": "Sarah Johnson",
    "changedAt": "2024-12-13T14:22:00Z",
    "changedBy": "Mike Chen",
    "reason": "Agent specialization in luxury properties",
    "actionType": "reassignment",
    "metadata": {
      "property_type": "luxury",
      "agent_expertise": "luxury_specialist",
      "client_preference": "female_agent"
    }
  }
}
```

### 3. Get Assignment Statistics

**GET** `/leads/assignment-stats`

Retrieves assignment statistics for the agency, including agent workloads and assignment patterns.

#### Query Parameters
- `startDate` (optional): Start date for statistics (ISO 8601 format)
- `endDate` (optional): End date for statistics (ISO 8601 format)
- `agentId` (optional): Filter by specific agent

#### Response
```json
{
  "success": true,
  "message": "Assignment statistics retrieved successfully",
  "data": {
    "totalAssignments": 156,
    "totalReassignments": 23,
    "averageAssignmentDuration": "7.5 days",
    "agentStats": [
      {
        "agentName": "Sarah Johnson",
        "currentLeads": 32,
        "totalAssignments": 45,
        "reassignmentsReceived": 8,
        "reassignmentsGiven": 3,
        "averageLeadDuration": "6.2 days",
        "conversionRate": "18.5%"
      },
      {
        "agentName": "John Smith",
        "currentLeads": 28,
        "totalAssignments": 38,
        "reassignmentsReceived": 5,
        "reassignmentsGiven": 7,
        "averageLeadDuration": "8.1 days",
        "conversionRate": "22.1%"
      }
    ],
    "reassignmentReasons": [
      {
        "reason": "Workload redistribution",
        "count": 12,
        "percentage": "52.2%"
      },
      {
        "reason": "Agent specialization",
        "count": 7,
        "percentage": "30.4%"
      },
      {
        "reason": "Client request",
        "count": 4,
        "percentage": "17.4%"
      }
    ]
  }
}
```

## Action Types

The system supports different types of assignment actions:

| Action Type | Description | Use Case |
|-------------|-------------|----------|
| `initial_assignment` | First assignment of a lead | New lead enters system |
| `reassignment` | Lead moved from one agent to another | Workload balancing, specialization |
| `unassignment` | Lead removed from agent (unassigned) | Agent unavailable, lead on hold |
| `bulk_assignment` | Multiple leads assigned at once | Batch processing |
| `auto_assignment` | System-generated assignment | Round-robin, rule-based assignment |
| `manual_assignment` | Manager manually assigns lead | Direct management decision |

## Common Reassignment Reasons

| Reason | Description | Frequency |
|--------|-------------|-----------|
| `workload_redistribution` | Balancing agent workloads | High |
| `agent_specialization` | Agent expertise match | Medium |
| `client_request` | Client requested specific agent | Low |
| `agent_unavailable` | Original agent unavailable | Medium |
| `performance_improvement` | Performance-based reassignment | Low |
| `geographic_proximity` | Location-based assignment | Medium |
| `language_preference` | Language matching | Low |

## Metadata Structure

Assignment history records can include metadata for additional context:

```json
{
  "metadata": {
    "assignment_method": "round_robin|manual|rule_based|client_request",
    "previous_workload": 45,
    "new_workload": 32,
    "priority_level": "low|medium|high|urgent",
    "property_type": "apartment|house|commercial|luxury",
    "agent_expertise": "first_time_buyers|luxury_specialist|commercial|rental",
    "client_preference": "male_agent|female_agent|language_specific",
    "geographic_area": "downtown|suburbs|waterfront",
    "lead_source": "website|referral|social_media|cold_call",
    "urgency_factor": "immediate|within_week|flexible",
    "budget_range": "under_200k|200k_500k|500k_1m|over_1m"
  }
}
```

## Error Codes

| Code | Message | Description |
|------|---------|-------------|
| 400 | Bad Request | Invalid request data or missing required fields |
| 401 | Unauthorized | Invalid or missing authentication token |
| 403 | Forbidden | Insufficient permissions to perform action |
| 404 | Not Found | Lead or assignment history not found |
| 409 | Conflict | Assignment conflict (e.g., agent already assigned) |
| 500 | Internal Server Error | Server error occurred |

## Examples

### JavaScript/React Example

```javascript
// Get assignment history for a lead
const fetchAssignmentHistory = async (leadId) => {
  try {
    const response = await fetch(`${API_URL}/leads/${leadId}/assignee-history`, {
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
    console.error('Error fetching assignment history:', error);
    throw error;
  }
};

// Record a new assignment
const recordAssignment = async (leadId, assignmentData) => {
  try {
    const response = await fetch(`${API_URL}/leads/${leadId}/assignee-history`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(assignmentData)
    });
    
    const result = await response.json();
    if (result.success) {
      return result.data;
    } else {
      throw new Error(result.message);
    }
  } catch (error) {
    console.error('Error recording assignment:', error);
    throw error;
  }
};

// Get assignment statistics
const fetchAssignmentStats = async (filters = {}) => {
  const queryParams = new URLSearchParams(filters).toString();
  const url = `${API_URL}/leads/assignment-stats${queryParams ? `?${queryParams}` : ''}`;
  
  try {
    const response = await fetch(url, {
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
    console.error('Error fetching assignment stats:', error);
    throw error;
  }
};
```

### Node.js Example

```javascript
const axios = require('axios');

// Reassign lead with full tracking
const reassignLead = async (leadId, fromAgent, toAgent, reason, changedBy) => {
  try {
    // First update the lead assignment
    await axios.patch(`${API_URL}/leads/${leadId}`, {
      assignedTo: toAgent
    }, {
      headers: { 'Authorization': `Bearer ${token}` }
    });
    
    // Then record the assignment history
    const historyResponse = await axios.post(
      `${API_URL}/leads/${leadId}/assignee-history`,
      {
        fromAgent,
        toAgent,
        changedBy,
        reason,
        actionType: 'reassignment',
        metadata: {
          assignment_method: 'manual',
          priority_level: 'medium'
        }
      },
      {
        headers: { 'Authorization': `Bearer ${token}` }
      }
    );
    
    return historyResponse.data.data;
  } catch (error) {
    console.error('Error reassigning lead:', error);
    throw error;
  }
};
```

## Best Practices

1. **Complete Tracking**: Always record assignment changes with proper metadata
2. **Clear Reasons**: Provide meaningful reasons for reassignments
3. **Performance Monitoring**: Use assignment statistics for performance insights
4. **Workload Balancing**: Monitor agent workloads through assignment data
5. **Audit Trail**: Maintain complete audit trail for compliance
6. **Real-time Updates**: Update assignment history immediately when changes occur

## Integration with Lead Management

Assignment history is tightly integrated with the lead management system:

- **Automatic Recording**: Assignment changes automatically create history records
- **Lead Updates**: Lead assignment updates trigger history creation
- **Analytics Integration**: Assignment data feeds into performance analytics
- **Notification System**: Assignment changes trigger WhatsApp/email notifications

---

For more information, see the [Lead Notes API](lead-notes.md) and [Leads API](leads.md) documentation.
