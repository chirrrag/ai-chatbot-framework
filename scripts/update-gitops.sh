#!/bin/bash
# Script to update GitOps repository with new image tags
# Usage: ./scripts/update-gitops.sh <environment> <image-tag> [gitops-repo-url]

set -euo pipefail

ENVIRONMENT="${1:-dev}"
IMAGE_TAG="${2:-latest}"
GITOPS_REPO_URL="${3:-${GITOPS_REPO_URL:-}}"

if [ -z "$GITOPS_REPO_URL" ]; then
  echo "Error: GitOps repository URL not provided"
  echo "Set GITOPS_REPO_URL environment variable or pass as third argument"
  exit 1
fi

VALUES_FILE="helm/ai-chatbot-framework/values-${ENVIRONMENT}.yaml"

echo "Updating GitOps repository..."
echo "Environment: $ENVIRONMENT"
echo "Image Tag: $IMAGE_TAG"
echo "GitOps Repo: $GITOPS_REPO_URL"

# Clone GitOps repository
TEMP_DIR=$(mktemp -d)
git clone "$GITOPS_REPO_URL" "$TEMP_DIR/gitops" || exit 1
cd "$TEMP_DIR/gitops"

# Determine target branch
if [ "$ENVIRONMENT" == "production" ]; then
  TARGET_BRANCH="main"
elif [ "$ENVIRONMENT" == "staging" ]; then
  TARGET_BRANCH="staging"
else
  TARGET_BRANCH="develop"
fi

git checkout "$TARGET_BRANCH" || git checkout -b "$TARGET_BRANCH"

# Check if values file exists
if [ ! -f "$VALUES_FILE" ]; then
  echo "Error: Values file not found: $VALUES_FILE"
  exit 1
fi

# Install yq if not available
if ! command -v yq &> /dev/null; then
  echo "Installing yq..."
  wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
  chmod +x /usr/local/bin/yq
fi

# Update image tags
echo "Updating image tags in $VALUES_FILE"
yq eval ".image.backend.tag = \"$IMAGE_TAG\"" -i "$VALUES_FILE"
yq eval ".image.frontend.tag = \"$IMAGE_TAG\"" -i "$VALUES_FILE"

# Show changes
echo "Changes:"
git diff "$VALUES_FILE" || true

# Commit and push
git add "$VALUES_FILE"
if git diff --staged --quiet; then
  echo "No changes to commit"
else
  git config user.name "GitLab CI"
  git config user.email "ci@gitlab.com"
  git commit -m "chore: update image tags for $ENVIRONMENT to $IMAGE_TAG [skip ci]"
  git push origin "$TARGET_BRANCH"
  echo "GitOps repository updated successfully"
fi

# Cleanup
cd -
rm -rf "$TEMP_DIR"

