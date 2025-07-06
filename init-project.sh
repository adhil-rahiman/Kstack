#!/bin/bash

read -p "📦 Enter new package name (e.g., com.company.app): " NEW_PACKAGE
read -p "🧩 Enter new project name (e.g., MyProject): " NEW_NAME

# Validate input
if [[ -z "$NEW_PACKAGE" || -z "$NEW_NAME" ]]; then
  echo "❌ Package name and project name cannot be empty."
  exit 1
fi

# Constants
OLD_PACKAGE=$(grep "^customPackageName=" gradle.properties | cut -d'=' -f2)
OLD_NAME="Kstack"

# Paths
CONFIG_FILE="iosApp/Configuration/Config.xcconfig"
INDEX_FILE="webApp/src/jsMain/resources/index.html"
PBXPROJ_FILE="iosApp.xcodeproj/project.pbxproj"
STRINGS_FILE="./composeApp/src/androidMain/res/values/strings.xml"
SETTINGS_FILE="settings.gradle.kts"

echo "📦 Using '$NEW_NAME' as PRODUCT_NAME."
echo "🔁 Replacing:"
echo "   • Package: $OLD_PACKAGE → $NEW_PACKAGE"
echo "   • Project Name: $OLD_NAME → $NEW_NAME"

# Update gradle.properties
sed -i '' "s|$OLD_PACKAGE|$NEW_PACKAGE|g" gradle.properties

# Replace all files
find . -type f \( -name "*.kt" -o -name "*.kts" -o -name "*.gradle" -o -name "*.swift" -o -name "*.xml" -o -name "*.html" \) \
  -exec sed -i '' "s|$OLD_PACKAGE|$NEW_PACKAGE|g" {} +

find . -type f \( -name "*.kt" -o -name "*.kts" -o -name "*.gradle" -o -name "*.swift" -o -name "*.html" -o -name "*.pbxproj" \) \
  -exec sed -i '' "s|$OLD_NAME|$NEW_NAME|g" {} +

# Update iOS xcconfig
if [[ -f "$CONFIG_FILE" ]]; then
  sed -i '' "s|PRODUCT_NAME=.*|PRODUCT_NAME=$NEW_NAME|g" "$CONFIG_FILE"
  sed -i '' "s|PRODUCT_BUNDLE_IDENTIFIER=.*|PRODUCT_BUNDLE_IDENTIFIER=$NEW_PACKAGE.\$(TEAM_ID)|g" "$CONFIG_FILE"
  echo "🛠️ iOS Config updated at $CONFIG_FILE"
fi

# Replace app name in Android strings.xml
if [[ -f "$STRINGS_FILE" ]]; then
  sed -i '' "s|<string name=\"app_name\">.*</string>|<string name=\"app_name\">$PRODUCT_NAME</string>|g" "$STRINGS_FILE"
else
  echo "⚠️ strings.xml not found at $STRINGS_FILE"
fi


# Update index.html title
if [[ -f "$INDEX_FILE" ]]; then
  sed -i '' "s|<title>.*</title>|<title>$NEW_NAME</title>|g" "$INDEX_FILE"
  echo "🌐 Web index.html title updated"
fi

# Update iOS .pbxproj
if [[ -f "$PBXPROJ_FILE" ]]; then
  sed -i '' "s|$OLD_PACKAGE|$NEW_PACKAGE|g" "$PBXPROJ_FILE"
  sed -i '' "s|$OLD_NAME|$NEW_NAME|g" "$PBXPROJ_FILE"
  echo "🍏 iOS project.pbxproj updated"
fi

# Update settings.gradle(.kts)
if [[ -f "$SETTINGS_FILE" ]]; then
  sed -i '' "s|rootProject.name = \"$OLD_NAME\"|rootProject.name = \"$NEW_NAME\"|g" "$SETTINGS_FILE"
fi

# Move directory structure
OLD_PATH=$(echo "$OLD_PACKAGE" | tr '.' '/')
NEW_PATH=$(echo "$NEW_PACKAGE" | tr '.' '/')

find . -type d -path "*/$OLD_PATH" | while read -r dir; do
  new_dir=$(echo "$dir" | sed "s|$OLD_PATH|$NEW_PATH|g")
  mkdir -p "$(dirname "$new_dir")"
  mv "$dir" "$new_dir"
done

# Delete empty legacy packages
find . -type d -empty -name "droidnotes" -exec rm -r {} +
find . -type d -empty -name "com" -exec rm -r {} +

echo "✅ Renaming complete!"
echo "🏁 Project renamed to '$NEW_NAME' with package '$NEW_PACKAGE'"
