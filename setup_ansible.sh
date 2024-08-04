#!/bin/bash

# Update the system
echo "Updating the system..."
sudo apt update
sudo apt upgrade -y

# Install dependencies
echo "Installing dependencies..."
sudo apt install -y software-properties-common


#!/bin/bash

# Prompt for the SSH key decryption password
read -sp 'Enter SSH key decryption password: ' SSH_KEY_PASSWORD
echo

# Decrypt the SSH key
echo $SSH_KEY_PASSWORD | ansible-vault decrypt /root/.ssh/id_rsa.enc --output /root/.ssh/id_rsa --ask-vault-password

# Set the appropriate permissions for the SSH key
chmod 600 /root/.ssh/id_rsa

# Add the SSH key to the SSH agent
eval "$(ssh-agent -s)"
ssh-add /root/.ssh/id_rsa

# Run the Ansible playbook
ansible-playbook /playbook.yml

# Start a new shell to allow testing
/bin/bash

