FROM debian:bullseye

# Install dependencies & systemd tools
RUN apt-get update && \
    apt-get install -y \
      ansible \
      curl \
      openjdk-11-jdk \
      procps \
      systemd \
      systemd-sysv \
      dbus && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create required directories for systemd
RUN mkdir -p /etc/ansible /run/systemd/system && \
    echo "localhost ansible_connection=local" > /etc/ansible/hosts

# Copy test script and playbook
COPY tomcat_test.sh /tomcat_test.sh
RUN chmod +x /tomcat_test.sh

# Start systemd as init system
CMD ["/sbin/init"]