#!/bin/bash

# Fix Firestore index conflicts by importing existing indexes into Terraform state
# This prevents "index already exists" errors

set -e

PROJECT_ID="doculoom-446020"
DATABASE="vault"

echo "🔍 Checking for existing Firestore indexes..."

# Get the index IDs from GCP
TIMESTAMP_INDEX_ID=$(gcloud firestore indexes composite list \
  --database="$DATABASE" \
  --filter="collectionGroup:messages AND fields.fieldPath:flushed AND fields.fieldPath:timestamp" \
  --format="value(name)" \
  --project="$PROJECT_ID" 2>/dev/null | head -n1 || echo "")

MEMORIES_INDEX_ID=$(gcloud firestore indexes composite list \
  --database="$DATABASE" \
  --filter="collectionGroup:memories AND fields.fieldPath:user_id AND fields.fieldPath:embedding" \
  --format="value(name)" \
  --project="$PROJECT_ID" 2>/dev/null | head -n1 || echo "")

# Remove from state if exists
echo "🗑️  Removing indexes from Terraform state if they exist..."
terraform state rm module.vault.google_firestore_index.timestamp_index 2>/dev/null || true
terraform state rm module.vault.google_firestore_index.memories_composite_index 2>/dev/null || true

# Import if they exist in GCP
if [ -n "$TIMESTAMP_INDEX_ID" ]; then
  echo "📥 Importing timestamp_index: $TIMESTAMP_INDEX_ID"
  terraform import module.vault.google_firestore_index.timestamp_index "$TIMESTAMP_INDEX_ID"
else
  echo "⚠️  timestamp_index not found in GCP"
fi

if [ -n "$MEMORIES_INDEX_ID" ]; then
  echo "📥 Importing memories_composite_index: $MEMORIES_INDEX_ID"
  terraform import module.vault.google_firestore_index.memories_composite_index "$MEMORIES_INDEX_ID"
else
  echo "⚠️  memories_composite_index not found in GCP"
fi

echo "✅ Done! Run 'terraform plan' to verify."
