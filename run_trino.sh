#!/bin/bash

set -e
docker cp ./scripts/star.sql trino:/tmp/star.sql
docker exec -it trino trino -f /tmp/star.sql
