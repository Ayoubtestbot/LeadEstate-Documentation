# LeadEstate API Documentation

## ðŸ”” **Base URL**
```
Production: https://leadestate-backend-9fih.onrender.com
Development: http://localhost:6001
```

## ðŸ” **Authentication**

### **JWT Token Structure**
```json
{
  "userId": "uuid",
  "email": "user@example.com",
  "role": "manager|agent",
  "agencyId": "uuid",
  "subscriptionStatus": "trial|active|expired",
  "trialEndDate": "2025-09-10T20:06:51.032Z",
  "planName": "starter|professional|enterprise"
}
```

### **Headers Required**
```http
Authorization: Bearer <jwt_token>
Content-Type: application/json
```

## ðŸ“¹ **API Endpoints**

### **ðŸ” Public Endpoints**

#### **Health Check**
```http
GET /health
```

**Response:**
```json
{
  "status": "healthy",
  "timestamp": "2025-08-27T16:36:11.180Z",
  "uptime": 12345,
  "environment": "production",
  "version": "1.0.0"
}
```

#### **Test Deployment**
```http
GET /api/auth/test-deployment
```

**Response:**
```json
{
  "success": true,
  "message": "Deployment is working! Latest commit deployed successfully.",
  "timestamp": "2025-08-27T16:36:11.180Z",
  "routes": {
    "trialSignup": "/api/auth/trial-signup",
    "testDeployment": "/api/auth/test-deployment",
    "login": "/api/auth/login"
  },
  "environment": {
    "NODE_ENV": "production",
    "JWT_SECRET": "SET"
  }
}
```

### **ðŸ”‡ Authentication Endpoints**

#### **Trial Signup**
```http
POST /api/auth/trial-signup
```

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "password123",
  "firstName": "John",
  "lastName": "Doe",
  "companyName": "Real Estate Agency"
}
```

**Response (201):**
```json
{
  "success": true,
  "message": "Trial account created successfully",
  "data": {
    "user": {
      "id": "uuid",
      "email": "user@example.com",
      "firstName": "John",
      "lastName": "Doe",
      "role": "manager",
      "agencyId": "uuid",
      "subscriptionStatus": "trial",
      "trialEndDate": "2025-09-10T20:06:51.032Z"
    },
    "token": "jwt_token",
    "refreshToken": "refresh_token",
    "agency": {
      "id": "uuid",
      "name": "Real Estate Agency",
      "status": "active"
    },
    "expiresIn": "7d"
  }
}
```

**Validation Errors (400):**
```json
{
  "success": false,
  "message": "Validation failed",
  "errors": [
    {
      "field": "email",
      "message": "Please provide a valid email"
    }
  ]
}
```

**User Exists (409):**
```json
{
  "success": false,
  "message": "User with this email already exists"
}
```

#### **Login**
```http
POST /api/auth/login
```

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Response (200):**
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "user": {
      "id": "uuid",
      "email": "user@example.com",
      "firstName": "John",
      "lastName": "Doe",
      "role": "manager",
      "agencyId": "uuid",
      "subscriptionStatus": "trial",
      "trialEndDate": "2025-09-10T20:06:51.032Z",
      "planName": "starter",
      "phone": null,
      "avatarUrl": null,
      "lastLoginAt": "2025-08-27T16:36:11.180Z",
      "emailVerifiedAt": null
    },
    "token": "jwt_token",
    "refreshToken": "refresh_token",
    "expiresIn": "7d"
  }
}
```

**Invalid Credentials (401):**
```json
{
  "success": false,
  "message": "Invalid email or password"
}
```

### **ðŸ” Protected Endpoints**

> **Note:** All protected endpoints require valid JWT token and active subscription

#### **Users Management**
```http
GET /api/users
POST /api/users
PUT /api/users/:id
DELETE /api/users/:id
```

#### **Leads Management**
```http
GET /api/leads
POST /api/leads
PUT /api/leads/:id
DELETE /api/leads/:id
```

#### **Properties Management**
```http
GET /api/properties
POST /api/properties
PUT /api/properties/:id
DELETE /api/properties/:id
```

#### **Analytics**
```http
GET /api/analytics
GET /api/analytics/leads
GET /api/analytics/properties
GET /api/analytics/performance
```

## ðŸ”¡¯ **Middleware Stack**

### **Request Flow**
```
1. Rate Limiting (100 requests/15min)
2. CORS Validation
3. Body Parsing (JSON/URL-encoded)
4. Authentication (JWT verification)
5. Subscription Status Check
6. Agency Isolation (automatic filtering)
7. Route Hendler
8. Error Handling
9. Response
```

### **Rate Limiting**
- **Window**: 15 minutes
- **Max Requests**: 100 per IP
- **Headers**: `X-RateLimit-Limit`, `X-RateLimit-Remaining`

### **CORS Policy**
- **Allowed Origins**: Configured frontend domains
- **Allowed Methods**: GET, POST, PUT, DELETE, PATCH, OPTIONS
- **Allowed Headers**: Content-Type, Authorization, X-Requested-With
- **Credentials**: Enabled

## ðŸ”¨ â”Œ **Error Handling**

### **Standard Error Response**
```json
{
  "success": false,
  "message": "Error description",
  "error": "Detailed error message (development only)",
  "timestamp": "2025-08-27T16:36:11.180Z"
}
```

### **HTTP Status Codes**
- **200**: Success
- **201**: Created
- **400**: Bad Request (validation errors)
- **401**: Unauthorized (invalid/missing token)
- **403**: Forbidden (subscription expired)
- **404**: Not Found
- **409**: Conflict (duplicate resource)
- **429**: Too Many Requests (rate limited)
- **500**: Internal Server Error

### **Subscription Status Errors**
```json
{
  "success": false,
  "message": "Subscription required",
  "subscriptionStatus": "expired",
  "trialEndDate": "2025-08-27T16:36:11.180Z"
}
```

## ðŸ” â”Œ **Data Isolation**

### **Agency-Based Filtering**
All protected endpoints automatically filter data by the user's `agency_id`:

```sql
-- Example: Getting leads for authenticated user
SELECT * FROM leads WHERE agency_id = $1;
```

### **Multi-Tenant Security**
- JWT tokens contain `agency_id`
- Middleware enforces agency isolation
- No cross-agency data access possible
- Database queries automatically scoped

## ðŸ“ª ðŸ“Š **Response Formats**

### **Success Response**
```json
{
  "success": true,
  "message": "Operation successful",
  "data": {
    // Response data
  }
}
```

### **Paginated Response**
```json
{
  "success": true,
  "data": {
    "items": [...],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 100,
      "pages": 5
    }
  }
}
```

### **Validation Error Response**
```json
{
  "success": false,
  "message": "Validation failed",
  "errors": [
    {
      "field": "email",
      "message": "Please provide a valid email",
      "value": "invalid-email"
    }
  ]
}
```

## ðŸ”§ ðŸ”ª **Testing**

### **Test Endpoints**
```bash
# Health check
curl https://leadestate-backend-9fih.onrender.com/health

# Test deployment
curl https://leadestate-backend-9fih.onrender.com/api/auth/test-deployment

# Trial signup
curl -X POST https://leadestate-backend-9fih.onrender.com/api/auth/trial-signup \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123",
    "firstName": "Test",
    "lastName": "User",
    "companyName": "Test Company"
  }'
```

### **Authentication Testing**
```bash
# Login and get token
TOKEN=$(curl -X POST https://leadestate-backend-9fih.onrender.com/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "test@example.com", "password": "password123"}' \
  | jq -r '.data.token')

# Use token for protected endpoints
curl -H "Authorization: Bearer $TOKEN" \
  https://leadestate-backend-9fih.onrender.com/api/users
```

---

*Last Updated: August 27, 2025*
*API Version: 1.0.0*
