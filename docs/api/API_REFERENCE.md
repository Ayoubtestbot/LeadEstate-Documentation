# 📚 LeadEstate API Reference

## 🌐 Base URLs

- **Agency Backend**: `https://leadestate-backend-9fih.onrender.com/api`
- **Owner Dashboard**: `https://leadestate-backend-9fih.onrender.com/api/owner-integration`

---

## 🔐 Authentication

Most endpoints require authentication. Include the following headers:

```http
Content-Type: application/json
Authorization: Bearer <token>
```

For Owner Dashboard endpoints, include:
```http
x-owner-api-key: owner-dashboard-2024
```

---

## 📋 Leads Management

### GET /leads
Get all leads with filtering and pagination.

**Query Parameters:**
- `limit` (number): Maximum number of results (default: 100)
- `offset` (number): Number of records to skip
- `status` (string): Filter by lead status
- `assignedTo` (string): Filter by assigned agent

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "first_name": "John",
      "last_name": "Doe",
      "email": "john@example.com",
      "phone": "+1234567890",
      "status": "new",
      "assigned_to": "Agent Name",
      "language": "en",
      "interested_properties": ["prop-id-1"],
      "created_at": "2024-01-01T00:00:00Z"
    }
  ]
}
```

### POST /leads
Create a new lead.

**Request Body:**
```json
{
  "first_name": "John",
  "last_name": "Doe",
  "email": "john@example.com",
  "phone": "+1234567890",
  "source": "website",
  "budget": 100000,
  "notes": "Interested in downtown properties",
  "assignedTo": "Agent Name",
  "language": "en"
}
```

### PUT /leads/:id
Update an existing lead.

### DELETE /leads/:id
Delete a lead.

---

## 🏠 Properties Management

### GET /properties
Get all properties with filtering.

**Query Parameters:**
- `status` (string): Filter by property status
- `type` (string): Filter by property type
- `minPrice` (number): Minimum price filter
- `maxPrice` (number): Maximum price filter

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "title": "Beautiful Downtown Apartment",
      "description": "Modern 2BR apartment...",
      "price": 250000,
      "type": "apartment",
      "status": "available",
      "bedrooms": 2,
      "bathrooms": 2,
      "area": 1200,
      "address": "123 Main St",
      "city": "New York",
      "state": "NY",
      "zipCode": "10001",
      "image_url": "https://example.com/image.jpg",
      "images": ["url1", "url2", "url3"],
      "created_at": "2024-01-01T00:00:00Z"
    }
  ]
}
```

### POST /properties
Create a new property.

**Request Body:**
```json
{
  "title": "Beautiful Downtown Apartment",
  "description": "Modern 2BR apartment with city views",
  "price": 250000,
  "type": "apartment",
  "bedrooms": 2,
  "bathrooms": 2,
  "area": 1200,
  "address": "123 Main St",
  "city": "New York",
  "state": "NY",
  "zipCode": "10001",
  "image_url": "https://example.com/main-image.jpg",
  "images": ["https://example.com/img1.jpg", "https://example.com/img2.jpg"]
}
```

### PUT /properties/:id
Update an existing property.

### DELETE /properties/:id
Delete a property.

---

## 👥 Team Management

### GET /team
Get all team members.

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "name": "Agent Smith",
      "email": "agent@example.com",
      "phone": "+1234567890",
      "role": "agent",
      "department": "sales",
      "status": "active",
      "joined_at": "2024-01-01T00:00:00Z"
    }
  ]
}
```

### POST /team
Add a new team member.

### PUT /team/:id
Update team member information.

### DELETE /team/:id
Remove a team member.

---

## 📱 WhatsApp Integration

### POST /whatsapp/welcome/:leadId
Send WhatsApp welcome message to a lead.

**Path Parameters:**
- `leadId` (string): UUID of the lead

**Response:**
```json
{
  "success": true,
  "data": {
    "success": true,
    "method": "twilio_whatsapp",
    "messageSid": "SM...",
    "status": "queued",
    "agent": "Agent Name",
    "leadName": "John Doe",
    "phoneNumber": "+1234567890",
    "whatsappUrl": "https://wa.me/1234567890?text=..."
  },
  "message": "WhatsApp welcome message prepared successfully"
}
```

### GET /whatsapp/diagnostic
Get WhatsApp service diagnostic information.

### POST /whatsapp/test
Send a test WhatsApp message.

**Request Body:**
```json
{
  "phoneNumber": "+1234567890",
  "message": "Test message"
}
```

---

## 📊 Dashboard & Analytics

### GET /dashboard/all-data
Get comprehensive dashboard data in a single request.

**Response:**
```json
{
  "success": true,
  "data": {
    "leads": [...],
    "properties": [...],
    "team": [...],
    "stats": {
      "totalLeads": 100,
      "availableProperties": 50,
      "conversionRate": "15.5",
      "closedWonLeads": 15
    }
  },
  "loadTime": 450
}
```

### GET /dashboard/stats
Get dashboard statistics only.

---

## 🔗 Property Linking

### POST /leads/:leadId/link-property
Link a property to a lead's interests.

**Request Body:**
```json
{
  "propertyId": "property-uuid"
}
```

### DELETE /leads/:leadId/unlink-property/:propertyId
Remove a property from lead's interests.

---

## 🏢 Owner Dashboard APIs

### GET /owner-integration/dashboard/all-data
Get owner dashboard data (agencies, stats, etc.).

**Headers Required:**
```http
x-owner-api-key: owner-dashboard-2024
```

### GET /owner-integration/agencies
Get all agencies managed by the owner.

### POST /owner-integration/agencies
Create a new agency.

**Request Body:**
```json
{
  "name": "Elite Properties",
  "managerName": "John Smith",
  "managerEmail": "john@elite.com",
  "phone": "+1234567890",
  "address": "123 Business St",
  "city": "New York",
  "plan": "premium"
}
```

---

## 🛠️ Utility Endpoints

### GET /health
Health check endpoint.

**Response:**
```json
{
  "status": "OK",
  "message": "LeadEstate API is running",
  "database": {
    "status": "connected",
    "timestamp": "2024-01-01T00:00:00Z"
  },
  "uptime": 3600
}
```

### GET /status
API status information.

### GET /optimize-db
Optimize database performance (creates indexes).

---

## 📝 Sample Data Endpoints

### POST /sample-data/leads
Generate sample leads for testing.

**Request Body:**
```json
{
  "count": 50,
  "language": "en"
}
```

### POST /sample-data/properties
Generate sample properties for testing.

### POST /sample-data/team
Generate sample team members.

---

## ❌ Error Responses

All endpoints return errors in this format:

```json
{
  "success": false,
  "message": "Error description",
  "error": "Detailed error information",
  "timestamp": "2024-01-01T00:00:00Z"
}
```

**Common HTTP Status Codes:**
- `200` - Success
- `201` - Created
- `400` - Bad Request
- `401` - Unauthorized
- `404` - Not Found
- `500` - Internal Server Error

---

## 🔄 Rate Limiting

- **General APIs**: 100 requests per minute
- **WhatsApp APIs**: 10 requests per minute
- **Sample Data**: 5 requests per hour

---

## 📱 Frontend Integration

### Agency Frontend
- **URL**: `https://lead-estate-agency-frontend.vercel.app`
- **Repository**: `LeadEstate-Agency-Frontend`

### Owner Dashboard
- **URL**: `https://lead-estate-owner-dashboard.vercel.app`
- **Repository**: `LeadEstate-Owner-Dashboard`

---

*Last Updated: July 16, 2025*
*Version: 2.0*
