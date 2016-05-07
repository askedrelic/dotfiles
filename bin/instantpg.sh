#!/bin/bash

# instant temporary postgres
# http://daurnimator.com/post/143986521649/instant-postgres

export PGDATA=$(mktemp -d) PGPORT=1234
trap "rm -rf -- $PGDATA" EXIT
initdb
echo "Connect with: psql -p \"$PGPORT\" -h localhost -d postgres"
postgres -F -k ""
