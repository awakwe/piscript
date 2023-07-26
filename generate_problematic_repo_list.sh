#!/bin/bash
# generate_problematic_repo_list.sh

generate_problematic_repo_list() {
    # Temporarily store the output of apt-get update
    local apt_update_output="apt_update_output.txt"

    # Run apt-get update and store the output
    sudo apt-get update 2> $apt_update_output

    # Extract lines that contain "Failed to fetch", parse to get the repository
    # This may need to be modified depending on the exact error messages you get
    local problematic_repos=$(grep "Failed to fetch" $apt_update_output | cut -d' ' -f4 | cut -d'/' -f3-4 | uniq)

    # Clean up
    rm $apt_update_output

    # If no problematic repositories were found, exit
    if [ -z "$problematic_repos" ]; then
        echo "No problematic repositories found."
        exit 0
    fi

    echo "The following problematic repositories were found:"
    echo "$problematic_repos"

    read -p "Do you want to add these to the problematic_repos.txt file? [y/n]: " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi

    # Add the problematic repositories to the problematic_repos.txt file
    echo "$problematic_repos" > problematic_repos.txt

    echo "Problematic repositories have been added to problematic_repos.txt."
}

generate_problematic_repo_list
