#!/usr/bin/env bash

set -e

# Verify we have cfssl
lines=$(which cfssl |wc -l)
if [ $lines -lt 1 ] ; then
    echo "cfssl not found"
    exit -1
fi

# Establish the environment
base=$(realpath $(dirname $0))
echo "Using '$base' for base"
reqs="$base"
data="$base"

# Clean up existing configurations
./clean.sh


# Create a new root CA
mkdir -p root
( cd root
echo "================================"
echo "Generating Root CA"
echo "================================"
cfssl gencert -initca ../ca-sr.json | cfssljson -bare ca
)

# Create our server CA
mkdir -p servers
( cd servers
echo "================================"
echo "Generating Server CA"
echo "================================"
cfssl genkey -initca $reqs/servers-sr.json | cfssljson -bare servers

echo ">> Signing with CA"
cfssl sign -ca $data/root/ca.pem -ca-key $data/root/ca-key.pem --config $reqs/intermediate-config.json -profile intermediate servers.csr |cfssljson -bare servers

echo "================================"
echo "Generating test server certificate"
echo "================================"
cfssl gencert -ca=$data/servers/servers.pem -ca-key=$data/servers/servers-key.pem -config $reqs/leafs-config.json -profile server $reqs/server-test.json |cfssljson -bare server-test
cat $data/servers/server-test.pem $data/servers/servers.pem >$data/servers/server-test-bundle.pem
)

# Create our server CA
mkdir -p clients
( cd clients
echo "================================"
echo "Generating Clients CA"
echo "================================"
cfssl genkey -initca $reqs/clients-sr.json | cfssljson -bare clients

echo ">> Signing with CA"
cfssl sign -ca $data/root/ca.pem -ca-key $data/root/ca-key.pem --config $reqs/intermediate-config.json -profile intermediate clients.csr |cfssljson -bare clients
)

