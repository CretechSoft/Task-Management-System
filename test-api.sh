#!/bin/bash

# Task Management System - Simple API Test Script
# This script tests basic API endpoints

BASE_URL="http://localhost:5000/api"
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "================================"
echo "Task Management System API Test"
echo "================================"
echo ""

# Check if server is running
echo -n "Checking if server is running... "
if curl -s "${BASE_URL}/health" > /dev/null; then
    echo -e "${GREEN}✓ Server is running${NC}"
else
    echo -e "${RED}✗ Server is not running. Please start the server first with 'npm start' or 'npm run dev'${NC}"
    exit 1
fi

echo ""
echo "Testing Authentication Endpoints"
echo "--------------------------------"

# Test Registration
echo -n "Testing user registration... "
REGISTER_RESPONSE=$(curl -s -X POST "${BASE_URL}/auth/register" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test User",
    "email": "test@example.com",
    "password": "test123",
    "role": "employee"
  }')

if echo "$REGISTER_RESPONSE" | grep -q "token"; then
    echo -e "${GREEN}✓ Registration successful${NC}"
    TOKEN=$(echo "$REGISTER_RESPONSE" | grep -o '"token":"[^"]*' | cut -d'"' -f4)
else
    echo -e "${YELLOW}⚠ Registration failed (user might already exist)${NC}"
fi

# Test Login
echo -n "Testing user login... "
LOGIN_RESPONSE=$(curl -s -X POST "${BASE_URL}/auth/login" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "test123"
  }')

if echo "$LOGIN_RESPONSE" | grep -q "token"; then
    echo -e "${GREEN}✓ Login successful${NC}"
    TOKEN=$(echo "$LOGIN_RESPONSE" | grep -o '"token":"[^"]*' | cut -d'"' -f4)
else
    echo -e "${RED}✗ Login failed${NC}"
    exit 1
fi

# Test Get Current User
echo -n "Testing get current user... "
ME_RESPONSE=$(curl -s -X GET "${BASE_URL}/auth/me" \
  -H "Authorization: Bearer $TOKEN")

if echo "$ME_RESPONSE" | grep -q "user"; then
    echo -e "${GREEN}✓ Get current user successful${NC}"
else
    echo -e "${RED}✗ Get current user failed${NC}"
fi

echo ""
echo "Testing Department Endpoints"
echo "----------------------------"

# Test Create Department
echo -n "Testing create department... "
DEPT_RESPONSE=$(curl -s -X POST "${BASE_URL}/departments" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test Department",
    "description": "A test department",
    "color": "#3498db"
  }')

if echo "$DEPT_RESPONSE" | grep -q "department"; then
    echo -e "${GREEN}✓ Create department successful${NC}"
    DEPT_ID=$(echo "$DEPT_RESPONSE" | grep -o '"_id":"[^"]*' | head -1 | cut -d'"' -f4)
else
    echo -e "${YELLOW}⚠ Create department failed (might not have admin permissions)${NC}"
fi

# Test Get Departments
echo -n "Testing get departments... "
GET_DEPT_RESPONSE=$(curl -s -X GET "${BASE_URL}/departments" \
  -H "Authorization: Bearer $TOKEN")

if echo "$GET_DEPT_RESPONSE" | grep -q "departments"; then
    echo -e "${GREEN}✓ Get departments successful${NC}"
else
    echo -e "${RED}✗ Get departments failed${NC}"
fi

echo ""
echo "Testing Project Endpoints"
echo "-------------------------"

# Test Get Projects
echo -n "Testing get projects... "
GET_PROJ_RESPONSE=$(curl -s -X GET "${BASE_URL}/projects" \
  -H "Authorization: Bearer $TOKEN")

if echo "$GET_PROJ_RESPONSE" | grep -q "projects"; then
    echo -e "${GREEN}✓ Get projects successful${NC}"
else
    echo -e "${RED}✗ Get projects failed${NC}"
fi

echo ""
echo "Testing Task Endpoints"
echo "----------------------"

# Test Get Tasks
echo -n "Testing get tasks... "
GET_TASKS_RESPONSE=$(curl -s -X GET "${BASE_URL}/tasks" \
  -H "Authorization: Bearer $TOKEN")

if echo "$GET_TASKS_RESPONSE" | grep -q "tasks"; then
    echo -e "${GREEN}✓ Get tasks successful${NC}"
else
    echo -e "${RED}✗ Get tasks failed${NC}"
fi

echo ""
echo "Testing Notification Endpoints"
echo "-------------------------------"

# Test Get Notifications
echo -n "Testing get notifications... "
GET_NOTIF_RESPONSE=$(curl -s -X GET "${BASE_URL}/notifications" \
  -H "Authorization: Bearer $TOKEN")

if echo "$GET_NOTIF_RESPONSE" | grep -q "notifications"; then
    echo -e "${GREEN}✓ Get notifications successful${NC}"
else
    echo -e "${RED}✗ Get notifications failed${NC}"
fi

echo ""
echo "================================"
echo -e "${GREEN}API Tests Completed!${NC}"
echo "================================"
echo ""
echo "Your JWT Token (save this for manual testing):"
echo "$TOKEN"
echo ""
