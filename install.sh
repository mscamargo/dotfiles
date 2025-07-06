#!/bin/bash

set -e

CSV_FILE="./links.csv"

expand_path() {
    echo "${1/\$HOME/$HOME}"
}

# Create symlink
create_symlink() {
    local source="$1"
    local target="$2"
    local description="$3"
    
    source=$(expand_path "$source")
    target=$(expand_path "$target")
    
    # Make source path absolute
    if [[ "$source" != /* ]]; then
        source="$(pwd)/$source"
    fi
    
    # Create target directory if needed
    mkdir -p "$(dirname "$target")"
    
    # Remove existing file/symlink
    [ -e "$target" ] && rm -rf "$target"
    
    # Create symlink
    ln -sf "$source" "$target"
    echo "✓ $description"
}

# Install dotfiles from CSV
while IFS=',' read -r source_path target_path description; do
    # Skip empty lines and comments
    [[ -z "$source_path" || "$source_path" =~ ^#.*$ ]] && continue
    
    # Trim whitespace
    source_path=$(echo "$source_path" | xargs)
    target_path=$(echo "$target_path" | xargs)
    description=$(echo "$description" | xargs)
    
    # Skip if source doesn't exist
    full_source_path="./$source_path"
    [ ! -e "$full_source_path" ] && continue
    
    create_symlink "$source_path" "$target_path" "$description"
    
done < "$CSV_FILE"

echo "Installation completed!"
