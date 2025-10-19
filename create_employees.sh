#!/bin/bash
# create_employees.sh

# Configuration
API_BASE_URL="http://localhost:8080"
NUM_USERS=${1:-10}  # Use first argument or default to 10

# Validate that the argument is a number
if ! [[ "$NUM_USERS" =~ ^[0-9]+$ ]]; then
    echo "Error: Please provide a valid number of users to create"
    echo "Usage: $0 [number_of_users]"
    echo "Example: $0 5"
    exit 1
fi

# Arrays of possible data for randomization
FIRST_NAMES=("John" "Jane" "Michael" "Emily" "David" "Sarah" "Robert" "Lisa" "William" "Emma")
LAST_NAMES=("Smith" "Johnson" "Williams" "Brown" "Jones" "Miller" "Davis" "Garcia" "Rodriguez" "Wilson")
DOMAINS=("example.com" "test.org" "demo.net" "mock.io" "fake.co")
DEPARTMENTS=("Engineering" "Marketing" "HR" "Finance" "Operations" "Sales" "IT" "Product" "Support" "Design")
POSITIONS=("Software Engineer" "Senior Developer" "Team Lead" "Manager" "Architect" "DevOps Engineer" "QA Engineer" "Product Owner" "Scrum Master" "UX Designer")

# Function to generate random number in range
random_number() {
  echo $((RANDOM % $1))
}

# Function to generate a random date within the last 5 years
random_date() {
  local current_year=$(date +%Y)
  local start_year=$((current_year - 5))
  local year=$((RANDOM % (current_year - start_year + 1) + start_year))
  local month=$((RANDOM % 12 + 1))
  local day=$((RANDOM % 28 + 1)) # Simple way to handle months, not perfect but works for testing
  printf "%04d-%02d-%02d" $year $month $day
}

# Function to generate random user data
generate_employee() {
  local first_name=${FIRST_NAMES[$(random_number ${#FIRST_NAMES[@]})]}
  local last_name=${LAST_NAMES[$(random_number ${#LAST_NAMES[@]})]}
  local domain=${DOMAINS[$(random_number ${#DOMAINS[@]})]}
  local department=${DEPARTMENTS[$(random_number ${#DEPARTMENTS[@]})]}
  local position=${POSITIONS[$(random_number ${#POSITIONS[@]})]}
  local timestamp=$(date +%s)
  local email="$(echo $first_name.$last_name.$timestamp | tr '[:upper:]' '[:lower:]')@$domain"
  local hire_date=$(random_date)
  local active=$((RANDOM % 2)) # Randomly true or false (0 or 1)

  echo "Creating employee: $first_name $last_name"

  # Create employee JSON
  cat <<EOF
{
  "firstName": "$first_name",
  "lastName": "$last_name",
  "email": "$email",
  "department": "$department",
  "position": "$position",
  "hireDate": "$hire_date",
  "active": $([ "$active" -eq 1 ] && echo "true" || echo "false")
}
EOF
}

# Main execution
echo "Starting to create $NUM_USERS test employees..."
echo "========================================"

for ((i=1; i<=$NUM_USERS; i++)); do
  echo -e "\nCreating employee $i of $NUM_USERS"
  employee_data=$(generate_employee)
  echo "Employee data: $employee_data"

  response=$(curl -s -X POST "${API_BASE_URL}/api/employees" \
    -H "Content-Type: application/json" \
    -d "$employee_data")

  if [ $? -eq 0 ]; then
    employee_id=$(echo $response | jq -r '.id')
    if [ "$employee_id" != "null" ]; then
      echo "✅ Successfully created employee with ID: $employee_id"
    else
      echo "❌ Failed to create employee. Response: $response"
    fi
  else
    echo "❌ Request failed with status code: $?"
  fi

  # Small delay between requests
  sleep 0.5
done

echo -e "\n========================================"
echo "Finished creating $NUM_USERS test employees"