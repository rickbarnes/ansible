# Use the official Ubuntu image
FROM ubuntu:latest

# Prevent prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update and install necessary packages
RUN apt-get update && apt-get install -y \
    software-properties-common \
    sudo \
    ssh \
    git \
    curl \
    python3-pip \
    && apt-get clean

# Add Docker GPG key and repository
RUN add-apt-repository --yes --update ppa:ansible/ansible && \
    apt-get install -y ansible apt-transport-https && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0EBFCD88 && \
    add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) \
      stable" && \
    apt-get update && \
    apt-get install -y docker-ce

# Copy the install script and playbook into the container
COPY setup_ansible.sh /setup_ansible.sh
COPY playbook.yml /playbook.yml

# Copy the encrypted SSH key into the container
COPY id_rsa.enc /root/.ssh/id_rsa.enc

# Make the script executable
RUN chmod +x /setup_ansible.sh

# Set the entrypoint to the script
ENTRYPOINT ["/setup_ansible.sh"]

