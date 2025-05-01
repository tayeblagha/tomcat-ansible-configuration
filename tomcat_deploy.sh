#!/bin/bash
if [ $# -ne 1 ]; then
  echo "Usage: $0 <ENVIRONMENT>"
  exit 1
fi

ENVIRONMENT=$1

# Build Docker image
docker build -t tomcat-container ./prod

# Run container with privileged mode and volume mount
# Start the container with systemd
docker run --privileged -d --name tomcat-container -p 8080:8080 -v $(pwd)/deploy:/data tayeblagha/tomcat

# Execute the test script inside the running container
docker exec -it tomcat-container /tomcat_test.sh $ENVIRONMENT


