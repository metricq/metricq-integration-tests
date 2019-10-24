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

# Test 2: source and sink combined
echo "########## TEST 2 ##########"
echo "# source and sink combined #"
echo "############################"
TEST_2_SINK_ID=$(docker-compose run --name "test_2_sink_$TEST_UID" -d metricq-cxx metricq-sink-dummy -s amqp://rabbitmq:rabbitmq@rabbitmq-server/ --count 10 --timeout 10 -m dummy.pets)
docker-compose run --name "test_2_source_$TEST_UID" metricq-cxx \
  metricq-source-dummy -s amqp://rabbitmq:rabbitmq@rabbitmq-server/ \
  --token source-dummy-test2 --metric "dummy.pets" --messages-per-chunk 10 \
  --chunk-count 10
(docker ps | grep -q $TEST_2_SINK_ID) && docker attach --no-stdin $TEST_2_SINK_ID

echo "#### Tests succeeded! ####"
exit 0
