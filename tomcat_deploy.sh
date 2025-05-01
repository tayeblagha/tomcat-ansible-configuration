#!/bin/bash
if [ $# -ne 1 ]; then
  echo "Usage: $0 <ENVIRONMENT>"
  exit 1
fi

ENVIRONMENT=$1

# If ENVIRONMENT is not PROD, set it to DEV
if [ "$ENVIRONMENT" != "PROD" ]; then
  ENVIRONMENT="DEV"
fi

# Clean up existing container
docker rm -f tomcat-container 2>/dev/null

# Build Docker image
docker build -t tayeblagha/tomcat ./prod

# Run container with privileged mode and volume mount
docker run --privileged -d --name tomcat-containerr -p 8080:8080 \
  -v $(pwd)/deploy:/data \
  tayeblagha/tomcat

# Wait for systemd initialization
sleep 15

# Execute test script
docker exec -it tomcat-containerr /tomcat_test.sh $ENVIRONMENT