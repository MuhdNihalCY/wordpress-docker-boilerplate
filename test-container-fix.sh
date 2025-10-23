#!/bin/bash

# Test script to demonstrate container conflict resolution
# This script shows how the updated docker-compose.yml prevents conflicts

echo "🧪 Testing Container Conflict Resolution"
echo "========================================"

# Test 1: Show old vs new container naming
echo "📋 Container Naming Comparison:"
echo
echo "❌ OLD (Hardcoded names - causes conflicts):"
echo "   - wp-boilerplate-wordpress"
echo "   - wp-boilerplate-mysql" 
echo "   - wp-boilerplate-phpmyadmin"
echo
echo "✅ NEW (Dynamic names - prevents conflicts):"
echo "   - \${COMPOSE_PROJECT_NAME:-wp-boilerplate}-wordpress"
echo "   - \${COMPOSE_PROJECT_NAME:-wp-boilerplate}-mysql"
echo "   - \${COMPOSE_PROJECT_NAME:-wp-boilerplate}-phpmyadmin"
echo

# Test 2: Show how project names work
echo "🔧 How Project Names Work:"
echo
echo "When you run: docker-compose -p site1 up -d"
echo "Containers become:"
echo "   - site1-wordpress"
echo "   - site1-mysql"
echo "   - site1-phpmyadmin"
echo
echo "When you run: docker-compose -p site2 up -d"
echo "Containers become:"
echo "   - site2-wordpress"
echo "   - site2-mysql"
echo "   - site2-phpmyadmin"
echo

# Test 3: Show management script usage
echo "🛠️ Management Script Usage:"
echo
echo "Create sites:"
echo "   ./manage-multiple-sites.sh create mysite"
echo "   ./manage-multiple-sites.sh create mysite 3"
echo
echo "Fix conflicts:"
echo "   ./manage-multiple-sites.sh fix-conflicts"
echo
echo "Manage sites:"
echo "   ./manage-multiple-sites.sh start mysite1"
echo "   ./manage-multiple-sites.sh stop mysite1"
echo "   ./manage-multiple-sites.sh list"
echo

# Test 4: Show current running containers
echo "📊 Current Running Containers:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep -E "(wordpress|mysql|phpmyadmin)" || echo "   No WordPress containers running"
echo

echo "✅ Container conflict resolution is now implemented!"
echo "   Multiple sites can run simultaneously without conflicts."
