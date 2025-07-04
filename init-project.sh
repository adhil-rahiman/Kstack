#!/bin/bash

# Ask for new package name
read -p "Enter new package name (e.g., com.yourcompany.app): " NEW_PACKAGE
if [[ -z "$NEW_PACKAGE" ]]; then
  echo "❌ Package name cannot be empty."
  exit 1
fi

# Derive new product name from current repo folder name
NEW_PROJECT_NAME=$(basename "$(pwd)")
echo "📦 Using '$NEW_PROJECT_NAME' as PRODUCT_NAME."

# Use placeholder team ID
TEAM_ID="TEAMID1234"

# Read old package from gradle.properties
OLD_PACKAGE=$(grep "^PACKAGE_NAME=" gradle.properties | cut -d'=' -f2)
if [[ -z "$OLD_PACKAGE" ]]; then
  echo "❌ PACKAGE_NAME not found in gradle.properties."
  exit 1
fi

echo "🔁 Replacing:"
echo "   • Package: $OLD_PACKAGE → $NEW_PACKAGE"
echo "   • Project Name: Kstack → $NEW_PROJECT_NAME"

# Update gradle.properties
sed -i '' "s|$OLD_PACKAGE|$NEW_PACKAGE|g" gradle.properties
sed -i '' "s|Kstack|$NEW_PROJECT_NAME|g" gradle.properties

# Replace in all project files
grep -rl "$OLD_PACKAGE" ./ | xargs sed -i '' "s|$OLD_PACKAGE|$NEW_PACKAGE|g"
grep -rl "Kstack" ./ | xargs sed -i '' "s|Kstack|$NEW_PROJECT_NAME|g"

# Move directory structure
OLD_PATH=$(echo "$OLD_PACKAGE" | tr '.' '/')
NEW_PATH=$(echo "$NEW_PACKAGE" | tr '.' '/')

find . -type d -path "*/$OLD_PATH" | while read -r dir; do
  new_dir=$(echo "$dir" | sed "s|$OLD_PATH|$NEW_PATH|g")
  mkdir -p "$(dirname "$new_dir")"
  mv "$dir" "$new_dir"
done

# Create iOS xcconfig with updated values
XCCONFIG_PATH="iosApp/Configs/GeneratedConfig.xcconfig"
mkdir -p "$(dirname "$XCCONFIG_PATH")"

cat <<EOF > $XCCONFIG_PATH
PRODUCT_NAME = $NEW_PROJECT_NAME
PRODUCT_BUNDLE_IDENTIFIER = $NEW_PACKAGE.$NEW_PROJECT_NAME
DEVELOPMENT_TEAM = $TEAM_ID
EOF

echo "🛠️  iOS Config written to $XCCONFIG_PATH"

echo "✅ Project renamed to '$NEW_PROJECT_NAME' with package '$NEW_PACKAGE'"
