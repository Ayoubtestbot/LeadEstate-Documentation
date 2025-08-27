# LeadEstate - Real Estate SaaS Platform

## ðŸ“‹ **Overview**

LeadEstate is a comprehensive real estate SaaS platform designed for real estate agencies to manage leads, properties, teams, and analytics. The platform features a multi-tenant architecture with subscription-based access and trial functionality.

## ðŸ—ï¸ **Architecture Overview**

### **Multi-Repository Structure**

The LeadEstate platform is organized into 5 separate repositories:

| Repository | Purpose | Technology | Deployment |
|------------|---------|------------|------------|
| **LeadEstate-Agency-Backend** | Main CRM Backend API | Node.js, Express, PostgreSQL | Render |
| **LeadEstate-Agency-Frontend** | Main CRM Frontend | React, Vite, Tailwind CSS | Vercel |
| **LeadEstate-Landingpage** | Marketing & Subscription Entry | React, Vite, Tailwind CSS | Vercel |
| **LeadEstate-owner-dashboard** | Admin Dashboard | React, Vite, Tailwind CSS | Vercel |
| **LeadEstate-Documentation** | Complete Documentation | Markdown | GitHub Pages |

### **Data Flow Architecture**

```
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”    â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”    â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚   Landing Page  â”‚    â”‚  Agency Frontendâ”‚    â”‚ Owner Dashboard â”‚
â”‚  (Subscription) â”‚    â”‚   (Main CRM)    â”‚    â”‚    (Admin)      â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”˜    â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”˜    â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”˜
          â”‚                      â”‚                      â”‚
          â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
                                 â”‚
                    â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â–¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
                    â”‚   Agency Backend API    â”‚
                    â”‚  (Multi-tenant Core)    â”‚
                    â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
                                  â”‚
                    â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â–¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
                    â”‚    PostgreSQL DB        â”‚
                    â”‚  (Agency Isolation)     â”‚
                    â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
```

## ðŸ” **Authentication & Multi-Tenancy**

### **Subscription-Based Authentication**
- **Trial Signup**: 14-day free trial with full access
- **Subscription Plans**: Starter, Professional, Enterprise
- **JWT Tokens**: Secure authentication with refresh tokens
- **Agency Isolation**: Strict data separation by `agency_id`

### **User Roles**
- **Manager**: Full agency access (trial users default role)
- **Agent**: Limited access to assigned leads/properties
- **Admin**: System-wide access (owner dashboard)

## ðŸš€ **Deployment Configuration**

### **Backend (Render)**
- **Repository**: `LeadEstate-Agency-Backend`
- **Branch**: `master`
- **Build Command**: `npm install`
- **Start Command**: `npm start`
- **Environment**: Production
- **Database**: PostgreSQL (Render managed)

### **Frontend Applications (Vercel)**

#### **Main CRM Frontend**
- **Repository**: `LeadEstate-Agency-Frontend`
- **Branch**: `main`
- **Framework**: React (Vite)
- **Build Command**: `npm run build`
- **Output Directory**: `dist`

#### **Landing Page**
- **Repository**: `LeadEstate-Landingpage`
- **Branch**: `main`
- **Framework**: React (Vite)
- **Build Command**: `npm run build`
- **Output Directory**: `dist`

#### **Owner Dashboard**
- **Repository**: `LeadEstate-owner-dashboard`
- **Branch**: `main`
- **Framework**: React (Vite)
- **Build Command**: `npm run build`
- **Output Directory**: `dist`

## ðŸ› ï¸ **Technology Stack**

### **Backend Technologies**
```json
{
  "runtime": "Node.js 18+",
  "framework": "Express.js",
  "database": "PostgreSQL",
  "authentication": "JWT",
  "validation": "express-validator",
  "security": "helmet, cors, rate-limiting",
  "logging": "winston",
  "email": "Brevo SMTP (pending integration)",
  "realtime": "Socket.IO",
  "deployment": "Render"
}
```

### **Frontend Technologies**
```json
{
  "framework": "React 18",
  "bundler": "Vite",
  "styling": "Tailwind CSS",
  "routing": "React Router",
  "state": "Context API / useState",
  "http": "Axios",
  "deployment": "Vercel"
}
```

## ðŸ“Š **Database Schema**

### **Core Tables**

#### **Users Table**
```sql
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  role VARCHAR(20) DEFAULT 'agent',
  agency_id UUID NOT NULL,
  status VARCHAR(20) DEFAULT 'active',
  subscription_status VARCHAR(20) DEFAULT 'trial',
  trial_end_date TIMESTAMP,
  plan_name VARCHAR(50) DEFAULT 'starter',
  phone VARCHAR(20),
  avatar_url TEXT,
  last_login_at TIMESTAMP,
  email_verified_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);
```

#### **Agencies Table**
```sql
CREATE TABLE agencies (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(100) NOT NULL,
  email VARCHAR(255) NOT NULL,
  owner_id UUID NOT NULL,
  status VARCHAR(20) DEFAULT 'active',
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  FOREIGN KEY (owner_id) REFERENCES users(id)
);
```

### **Data Isolation Strategy**
- All tenant data includes `agency_id` foreign key
- Middleware enforces agency-based filtering
- JWT tokens contain `agency_id` for automatic isolation
- Trial users get full access within their agency scope

## ðŸ”— **API Endpoints**

### **Authentication Endpoints**
```
POST /api/auth/trial-signup     # Create trial account
POST /api/auth/login           # User login
POST /api/auth/refresh         # Refresh JWT token
GET  /api/auth/test-deployment # Test deployment status
```

### **Protected Endpoints** (Require Authentication + Subscription)
```
GET    /api/users              # Get agency users
POST   /api/users              # Create user
GET    /api/leads              # Get agency leads
POST   /api/leads              # Create lead
GET    /api/properties         # Get agency properties
POST   /api/properties         # Create property
GET    /api/analytics          # Get agency analytics
```

### **Subscription Middleware**
All protected routes include:
1. **Authentication Check**: Valid JWT token
2. **Subscription Status**: Active trial or paid subscription
3. **Agency Isolation**: Automatic filtering by `agency_id`
4. **Trial Info**: Adds trial status to requests

## ðŸŒ **Environment Variables**

### **Backend Environment**
```env
# Database
DATABASE_URL=postgresql://user:pass@host:port/db

# JWT Security
JWT_SECRET=your-secret-key
JWT_EXPIRES_IN=7d
JWT_REFRESH_SECRET=your-refresh-secret
JWT_REFRESH_EXPIRES_IN=30d

# CORS
CORS_ORIGIN=https://your-frontend.vercel.app

# Email Service (Brevo SMTP)
BREVO_SMTP_KEY=your-brevo-api-key
BREVO_SMTP_USER=your-smtp-user
BREVO_SMTP_HOST=smtp-relay.brevo.com
BREVO_SMTP_PORT=587
BREVO_SENDER_EMAIL=noreply@yourdomain.com
BREVO_SENDER_NAME=LeadEstate

# Rate Limiting
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=100
```

### **Frontend Environment**
```env
# API Configuration
VITE_API_URL=https://your-backend.render.com
VITE_APP_NAME=LeadEstate
VITE_APP_VERSION=1.0.0
```

## ðŸš¦ **Current Implementation Status**

### âœ… **Completed Features**
- [x] Multi-tenant backend architecture
- [x] Trial signup with 14-day access
- [x] JWT authentication with refresh tokens
- [x] Database schema with agency isolation
- [x] User and agency management
- [x] Deployment on Render (backend)
- [x] CORS configuration for frontend integration
- [x] Rate limiting and security middleware
- [x] Comprehensive error handling and logging

### ðŸ”„ **In Progress**
- [ ] Email service integration (Brevo SMTP configured, pending testing)
- [ ] Frontend applications deployment
- [ ] Lead and property management endpoints
- [ ] Analytics and reporting features

### ðŸ“‹ **Pending Features**
- [ ] Payment integration (Stripe/PayPal)
- [ ] Advanced subscription management
- [ ] Real-time notifications (Socket.IO)
- [ ] File upload and management
- [ ] Advanced analytics dashboard
- [ ] Mobile responsive design
- [ ] API documentation (Swagger)

## ðŸ”§ **Development Workflow**

### **Local Development Setup**

#### **Backend Setup**
```bash
# Clone repository
git clone https://github.com/Ayoubtestbot/LeadEstate-Agency-Backend.git
cd LeadEstate-Agency-Backend

# Install dependencies
npm install

# Setup environment
cp .env.example .env
# Edit .env with your configuration

# Start development server
npm run dev
```

#### **Frontend Setup**
```bash
# Clone repository
git clone https://github.com/Ayoubtestbot/LeadEstate-Agency-Frontend.git
cd LeadEstate-Agency-Frontend

# Install dependencies
npm install

# Setup environment
cp .env.example .env.local
# Edit .env.local with your configuration

# Start development server
npm run dev
```

### **Deployment Process**

#### **Backend Deployment (Render)**
1. Push changes to `master` branch
2. Render automatically deploys from GitHub
3. Environment variables configured in Render dashboard
4. Database migrations run automatically

#### **Frontend Deployment (Vercel)**
1. Push changes to `main` branch
2. Vercel automatically deploys from GitHub
3. Environment variables configured in Vercel dashboard
4. Build artifacts cached for faster deployments

## ðŸ“ž **Support & Maintenance**

### **Monitoring**
- **Backend Health**: `/health` endpoint for uptime monitoring
- **Error Logging**: Winston logger with structured logging
- **Performance**: Response time tracking and optimization

### **Backup Strategy**
- **Database**: Automated daily backups on Render
- **Code**: Version control with GitHub
- **Environment**: Documented configuration management

### **Security Measures**
- **Authentication**: JWT with secure secret rotation
- **Authorization**: Role-based access control
- **Data Protection**: Agency-based data isolation
- **Rate Limiting**: API abuse prevention
- **CORS**: Strict origin validation
- **Input Validation**: Comprehensive request validation

---

## ðŸ“š **Additional Resources**

- **API Testing**: Use the test deployment endpoint for verification
- **Database Access**: Available through Render dashboard
- **Logs**: Real-time logging available in deployment platforms
- **Performance**: Monitor response times and optimize queries

---

*Last Updated: August 27, 2025*
*Version: 1.0.0*
*Maintained by: LeadEstate Development Team*
