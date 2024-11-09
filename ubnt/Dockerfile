FROM ubuntu:jammy

# Update and install necessary packages
RUN apt-get update && \
    apt-get install -y curl vim openssh-server net-tools iproute2 iputils-ping && \
    apt-get clean

# Create a directory for SSH daemon process
RUN mkdir /var/run/sshd

# Set a password for the root user (use a strong password or use keys instead)
RUN echo 'root:password' | chpasswd

# Enable SSH access for the root user
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

#Add SSH key to container
RUN mkdir -p /root/.ssh
RUN touch /root/.ssh/authorized_keys
RUN echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO/IKr786TCi42F5y4GDkd863wg+hUJ/9xw30sUxeUkB ubnt-key" >> /root/.ssh/authorized_keys

# Expose SSH port
EXPOSE 22

# Start SSH server when the container starts
CMD ["/usr/sbin/sshd", "-D"]
