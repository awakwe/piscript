#!/bin/bash
# remove_problematic_repo.sh

remove_problematic_repo() {
    # A file that lists problematic repositories
    local problematic_repo_file="problematic_repos.txt"

    if [[ -f "$problematic_repo_file" ]]; then
        while IFS= read -r repo
        do
            echo "Checking for the presence of $repo..."
            # Check if the problematic repo exists in the sources.list
            if grep -q "$repo" /etc/apt/sources.list; then
                echo "$repo found in sources.list. Attempting removal..."
                # Use sed to remove the repo from sources.list
                # Backup original file for safety
                sudo sed -i.bak "/$repo/d" /etc/apt/sources.list

                echo "$repo removed from sources.list."
            else
                echo "$repo not found in sources.list."
            fi

        done < "$problematic_repo_file"
    else
        echo "No problematic repository file found."
    fi

    # Update package list after changes to the sources
    echo "Updating package list..."
    sudo apt-get update
}
