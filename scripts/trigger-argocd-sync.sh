#!/bin/bash
# Script to trigger ArgoCD sync
# Usage: ./scripts/trigger-argocd-sync.sh <app-name> [argocd-server] [argocd-token]

set -euo pipefail

APP_NAME="${1:-ai-chatbot-framework-dev}"
ARGOCD_SERVER="${2:-${ARGOCD_SERVER:-https://argocd.example.com}}"
ARGOCD_TOKEN="${3:-${ARGOCD_AUTH_TOKEN:-}}"

if [ -z "$ARGOCD_TOKEN" ]; then
  echo "Error: ArgoCD token not provided"
  echo "Set ARGOCD_AUTH_TOKEN environment variable or pass as third argument"
  exit 1
fi

echo "Triggering ArgoCD sync for application: $APP_NAME"
echo "ArgoCD Server: $ARGOCD_SERVER"

# Check if jq is available
if ! command -v jq &> /dev/null; then
  echo "Installing jq..."
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sudo apt-get update && sudo apt-get install -y jq || sudo yum install -y jq
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    brew install jq
  fi
fi

# Sync application
SYNC_RESPONSE=$(curl -s -w "\n%{http_code}" -X POST \
  -H "Authorization: Bearer $ARGOCD_TOKEN" \
  "$ARGOCD_SERVER/api/v1/applications/$APP_NAME/sync" \
  -H "Content-Type: application/json" \
  -d '{
    "prune": true,
    "dryRun": false,
    "strategy": {
      "hook": {}
    }
  }')

HTTP_CODE=$(echo "$SYNC_RESPONSE" | tail -n1)
BODY=$(echo "$SYNC_RESPONSE" | sed '$d')

if [ "$HTTP_CODE" -eq 200 ] || [ "$HTTP_CODE" -eq 201 ]; then
  echo "Sync triggered successfully"
  echo "$BODY" | jq '.' || echo "$BODY"
else
  echo "Error triggering sync. HTTP Code: $HTTP_CODE"
  echo "$BODY"
  exit 1
fi

# Wait for sync to complete (optional)
if [ "${WAIT_FOR_SYNC:-false}" == "true" ]; then
  echo "Waiting for sync to complete..."
  MAX_ATTEMPTS=30
  ATTEMPT=0
  
  while [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
    APP_STATUS=$(curl -s -H "Authorization: Bearer $ARGOCD_TOKEN" \
      "$ARGOCD_SERVER/api/v1/applications/$APP_NAME" | \
      jq -r '.status.sync.status // "Unknown"')
    
    if [ "$APP_STATUS" == "Synced" ]; then
      echo "Application synced successfully"
      exit 0
    elif [ "$APP_STATUS" == "Unknown" ]; then
      echo "Application not found"
      exit 1
    fi
    
    echo "Sync status: $APP_STATUS (attempt $((ATTEMPT + 1))/$MAX_ATTEMPTS)"
    sleep 10
    ATTEMPT=$((ATTEMPT + 1))
  done
  
  echo "Sync timeout"
  exit 1
fi

