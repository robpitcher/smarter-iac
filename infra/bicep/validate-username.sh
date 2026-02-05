#!/bin/bash
# Pre-deployment validation script for Azure VM deployment
# This script validates the admin username before deployment

set -e

# List of Azure reserved usernames
RESERVED_USERNAMES=(
  "administrator"
  "admin"
  "user"
  "user1"
  "test"
  "user2"
  "test1"
  "user3"
  "admin1"
  "1"
  "123"
  "a"
  "actuser"
  "adm"
  "admin2"
  "aspnet"
  "backup"
  "console"
  "guest"
  "john"
  "owner"
  "root"
  "server"
  "sql"
  "support"
  "support_388945a0"
  "sys"
  "test2"
  "test3"
  "user4"
  "user5"
)

# Check if username is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <admin-username>"
  echo "Example: $0 adminUser"
  exit 1
fi

USERNAME=$(echo "$1" | tr '[:upper:]' '[:lower:]')

# Check if username is in reserved list
for reserved in "${RESERVED_USERNAMES[@]}"; do
  if [ "$USERNAME" == "$reserved" ]; then
    echo "❌ ERROR: Username '$1' is a reserved Azure username and cannot be used."
    echo "Please choose a different username."
    echo ""
    echo "Examples of valid usernames: adminUser, vmadmin, azureuser, myuser"
    exit 1
  fi
done

# Check length
if [ ${#1} -lt 1 ] || [ ${#1} -gt 20 ]; then
  echo "❌ ERROR: Username must be between 1 and 20 characters."
  exit 1
fi

echo "✅ Username '$1' is valid!"
exit 0
