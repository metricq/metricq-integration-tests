#!/bin/sh
set -e
TEST_UID=$(cat /dev/urandom | LC_ALL=C tr -dc 'a-zA-Z0-9' | fold -w 5 | head -n 1)

# Test 1: simple source send
echo "####### TEST 1 #######"
echo "# simple source send #"
echo "######################"
docker-compose run --name "test_1_source_$TEST_UID" metricq-cxx \
  metricq-source-dummy -s amqp://rabbitmq:rabbitmq@rabbitmq-server/ \
  --token source-dummy-test1 --metric "dummy.pets" --messages-per-chunk 10 \
  --chunk-count 100

echo "#### Test succeeded! ####"
exit 0
