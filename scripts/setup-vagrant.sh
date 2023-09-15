#!/bin/bash

VAGRANT_BOX="ubuntu/focal64"
VAGRANT_BOX_DISTRIBUTION="ubuntu"

# Helper function to check if vagrant command already exists
# i.e. is vagrant installed beforehand.
check_vagrant_installed() {
    command -v vagrant &> /dev/null || {
        echo "Vagrant is not installed. Please install Vagrant and try again."
        exit 1
    }
}

# Function to provision the Vagrant box.
provision_vagrant_box() {
  echo "Provisioning the Vagrant box with Ubuntu Focal64"

  # Check if vagrant is installed.
  check_vagrant_installed

  # Having verified that vagrant is installed, check if ehe required Vagrant box is already added.
  if ! vagrant box list | grep -q "$VAGRANT_BOX_DISTRIBUTION"; then
    echo "Adding Ubuntu Vagrant box..."
    # Add the Ubuntu Vagrant box
    vagrant box add "$VAGRANT_BOX"
  fi

  # Check if Vagrant box is running
  if [ ! -d ".vagrant" ]; then
    echo "Initializing and starting the Vagrant box..."
    # Initialize and start the Vagrant box
    vagrant init "$VAGRANT_BOX"
    vagrant up
  else
    echo "Vagrant box is already running."
  fi
}

# Execute the provision function
provision_vagrant_box

echo "Vagrant box setup completed successfully."
exit 0
