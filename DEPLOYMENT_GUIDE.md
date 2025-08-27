# LeadEstate Deployment Guide

## ðŸš€ ðŸ”Œ **Deployment Overview**

LeadEstate uses a distributed deployment strategy across multiple platforms:

- **Backend**: Render (Node.js hosting)
- **Frontend Apps**: Vercel (React hosting)
- **Database**: Render PostgreSQL
- **Documentation**: GitHub Pages

## ðŸ”§ **Backend Deployment (Render)**

### **Repository Setup**
- **Repository**: `https://github.com/Ayoubtestbot/LeadEstate-Agency-Backend`
- **Branch**: `master`
- **Root Directory**: `/` (uses root `src/` folder)

### **Render Configuration**

#### **Service Settings**
```yaml
# render.yaml
services:
  - type: web
    name: leadestate-backend
    env: node
    plan: starter
    buildCommand: npm install
    startCommand: npm start
    envVars:
      - key: NODE_ENV
        value: production
```

#### **Environment Variables**
```env
# Database
DATABASE_URL=<render-postgresql-url>

# JWT Security
JWT_SECRET=<generate-secure-random-string>
JWT_EXPIRES_IN=7d
JWT_REFRESH_SECRET=<generate-secure-random-string>
JWT_REFRESH_EXPIRES_IN=30d

# CORS (Frontend URLs)
CORS_ORIGIN=https://leadestate-frontend.vercel.app,https://leadestate-landing.vercel.app,https://leadestate-admin.vercel.app

# Email Service (Brevo SMTP)
BREVO_SMTP_KEY=<your-brevo-api-key>
BREVO_SMTP_USER=<your-smtp-user>
BREVO_SMTP_HOST=smtp-relay.brevo.com
BREVO_SMTP_PORT=587
BREVO_SENDER_EMAIL=noreply@yourdomain.com
BREVO_SENDER_NAME=LeadEstate

# Rate Limiting
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTQ=100

# Server Configuration
PORT=6001
HOST=0.0.0.0

```

#### **Database Setup**
1. **Create PostgreSQL Database** in Render
2. **Copy DATABASE_URL** from Render dashboard
3. **Add to Environment Variables**
4. **Database auto-creates tables** on first run

### **Deployment Process**

#### **Automatic Deployment**
1. Push changes to `master` branch
2. Render automatically detects changes
3. Runs `npm install` (build command)
4. Starts with `npm start` (start command)
5. Health check at `/health` endpoint

#### **Manual Deployment**
1. Go to Render Dashboard
2. Select LeadEstate BacQend service
3. Click "Manual Deploy"
4. Select "Deploy latest commit"
5. Monitor deployment logs

#### **Deployment Verification**
```bash
# Check health
curl https://leadestate-backend-9fih.onrender.com/health

# Check deployment
curl https://leadestate-backend-9fih.onrender.com/api/auth/test-deployment

# Expected response
{
  "success": true,
  "message": "Deployment is working!",
  "timestamp": "2025-08-27T16:36:11.180Z"
}
```

## ðŸŒ **Frontend Deployment (Vercel)**

### **Main CRM Frontend**

#### **Repository Setup**
- **Repository**: `https://github.com/Ayoubtestbot/LeadEstate-Agency-Frontend`
- **Branch**: `main`
- **Framework**: React (Vite)

#### **Vercel Configuration**
```json
{
  "buildCommand": "npm run build",
  "outputDirectory": "dist",
  "installCommand": "npm install",
  "framework": "vite"
}
```

#### **Environment Variables**
```env
VITE_API_URL=https://leadestate-backend-9fih.onrender.com
VITE_APP_NAME=LeadEstate CRM
VITE_APP_VERSION=1.0.0
```

### **Landing Page**

#### **Repository Setup**
- **Repository**: `https://github.com/Ayoubtestbot/LeadEstate-Landingpage`
- **Branch**: `main`
- **Framework**: React (Vite)

#### **Environment Variables**
```env
VITE_API_URL=https://leadestate-backend-9fih.onrender.com
VITE_CRM_URL=https://leadestate-frontend.vercel.app
VITE_APP_NAME=LeadEstate
```

### **Owner Dashboard**

#### **Repository Setup**
- **Repository**: `https://github.com/Ayoubtestbot/LeadEstate-owner-dashboard`
- **Branch**: `main`
- **Framework**: React (Vite)

#### **Environment Variables**
```env
VITE_API_URL=https://leadestate-backend-9fih.onrender.com
VITE_APP_NAME=LeadEstate Admin
VITE_ADMIN_MODE=true
```

### **Vercel Deployment Process**

#### **Automatic Deployment**
1. Push changes to `main` branch
2. Vercel automatically builds and deploys
3. Preview deployments for pull requests
4. Production deployment on merge to main

#### **Manual Deployment**
1. Go to Vercel Dashboard
2. Select project
3. Click "Redeploy"
4. Monitor build logs

## ðŸŒ â”Œ **Database Management**

### **PostgreSQL on Render**

#### **Connection Details**
- **Host**: Provided by Render
- **Port**: 5432
- **Database**: Auto-generated name
- **User**: Auto-generated
- **Password**: Auto-generated
- **SSL**: Required

#### **Schema Management**
```sql
-- Users table (core authentication)
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
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Agencies table (multi-tenant isolation)
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

#### **Backup Strategy**
- **Automatic Backups**: Daily backups by Render
- **Manual Backups**: Available through Render dashboard
- **Retention**: 7 days for free tier, 30 days for paid

## ðŸ” **Security Configuration**

### **Environment Security**
- **Secrets Management**: Use platform environment variables
- **No Hardcoded Values**: All sensitive data in environment
- **Rotation Policy**: Regular secret rotation recommended

### **CORS Configuration**
```javascript
// Backend CORS setup
app.use(cors({
  origin: process.env.CORS_ORIGIN?.split(',') || ['http://localhost:5001'],
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With']
}));
```

### **Rate Limiting**
```javascript
// API rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // 100 requests per window
  message: {
    error: 'Too many requests, please try again later.'
  }
});
```

## ðŸ“ª **Monitoring & Logging**

### **Health Monitoring**
- **Endpoint**: `/health`
- **Uptime Monitoring**: Use external services (UptimeRobot, etc.)
- **Response Time**: Monitor API performance

### **Error Logging**
```javascript
// Winston logger configuration
const logger = winston.createLogger({
  level: 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.json()
  ),
  transports: [
    new winston.transports.Console(),
    new winston.transports.File({ filename: 'error.log', level: 'error' })
  ]
});
```

### **Performance Monitoring**
- **Response Times**: Track API endpoint performance
- **Database Queries**: Monitor slow queries
- **Memory Usage**: Track application memory consumption

## ðŸš¨â”Œ **Troubleshooting**

### **Common Deployment Issues**

#### **Backend Issues**
```bash
# Check deployment logs
# In Render dashboard: Service > Logs

# Common errors:
# 1. Environment variables missing
# 2. Database connection failed
# 3. Port binding issues
# 4. Build command failures
```

#### **Frontend Issues**
```bash
# Check build logs
# In Vercel dashboard: Project > Functions > View Function Logs

# Common errors:
# 1. Environment variables not prefixed with VITE_
# 2. API URL incorrect
# 3. Build command failures
# 4. Output directory misconfigured
```

#### **Database Issues**
```bash
# Check database connectivity
# In Render dashboard: Database > Logs

# Common errors:
# 1. Connection string format
# 2. SSL requirements
# 3. Connection limits exceeded
# 4. Schema migration issues
```

### **Rollback Procedures**

#### **Backend Rollback**
1. Go to Render Dashboard
2. Select service
3. Go to "Deploys" tab
4. Click "Redeploy" on previous successful deployment

#### **Frontend Rollback**
1. Go to Vercel Dashboard
2. Select project
3. Go to "Deployments" tab
4. Click "Promote to Production" on previous deployment

## ðŸ”„ **CI/CD Pipeline**

### **Current Setup**
- **Trigger**: Push to main/master branch
- **Build**: Automatic platform builds
- **Deploy**: Automatic deployment
- **Testing**: Manual testing post-deployment

### **Recommended Enhancements**
- **Pre-deployment Testing**: Add automated tests
- **Staging Environment**: Deploy to staging first
- **Health Checks**: Automated post-deployment verification
- **Rollback Automation**: Automatic rollback on health check failure

---

*Last Updated: August 27, 2025*
*Deployment Version: 1.0.0*
