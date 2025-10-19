#!/bin/bash
# performance_test.sh

# Set the base URL of your API
API_BASE_URL="http://localhost:8080"

# Create a test employee
echo "Creating test employee..."
CREATE_RESPONSE=$(curl -s -X POST "${API_BASE_URL}/api/employees" \
  -H "Content-Type: application/json" \
  -d '{"name":"Load Test","email":"load.test@example.com","position":"Tester"}')

# Extract the employee ID
EMPLOYEE_ID=$(echo $CREATE_RESPONSE | jq -r '.id')
echo "Created employee with ID: $EMPLOYEE_ID"

# Run load tests
echo -e "\n=== Starting Performance Tests ==="

# Test GET all employees
echo -e "\nTesting GET /api/employees (10,000 requests with 100 concurrent connections)"
ab -n 10000 -c 100 "${API_BASE_URL}/api/employees"

# Test GET employee by ID
echo -e "\nTesting GET /api/employees/{id} (10,000 requests with 100 concurrent connections)"
ab -n 10000 -c 100 "${API_BASE_URL}/api/employees/${EMPLOYEE_ID}"

# Test POST employee
echo -e "\nTesting POST /api/employees (1,000 requests with 10 concurrent connections)"
ab -n 1000 -c 10 -p test_employee.json -T "application/json" -k -v 1 "${API_BASE_URL}/api/employees"

# Cleanup
echo -e "\nCleaning up test data..."
curl -X DELETE "${API_BASE_URL}/api/employees/${EMPLOYEE_ID}"