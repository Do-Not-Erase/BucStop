#!/bin/bash

create_snapshot() {
    echo "Creating snapshot..."
    curl -X POST http://10.147.19.64:8080/snapshots/create -d "description=Automated snapshot before shutdown"
}

create_snapshot

echo "Shutting down containers..."
docker-compose down