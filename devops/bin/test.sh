#!/bin/sh
#VARS
TEST_OUTPUT="/tmp/tests.log"
COMPOSE_FILES="-f ./devops/deploy/local/docker-compose.yml -f ./devops/deploy/local/docker-compose-tests.yml"
NAME_PREFIX="unittests"

TEST_REPORT=""
TEST_COVERAGE="";
while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        --report)
            TEST_REPORT="--log-junit ./reports/phpunit.xml"
            ;;
        --coverage)
            TEST_COVERAGE="--coverage-clover ./reports/clover.xml --coverage-html ./reports/coverage"
            ;;
    esac
    shift
done

#start application
COMPOSE_HTTP_TIMEOUT=120 docker-compose -p $NAME_PREFIX $COMPOSE_FILES up -d
sleep 10

#run backend tests and put result to test.log
(docker-compose -p $NAME_PREFIX $COMPOSE_FILES exec -T api php bin/phpunit $TEST_REPORT $TEST_COVERAGE ) | tee $TEST_OUTPUT

#ensure that application was stoped and removeed containers
docker-compose -p $NAME_PREFIX $COMPOSE_FILES stop
docker-compose -p $NAME_PREFIX $COMPOSE_FILES rm -f

#check log and fail build if there are errors
if grep -q 'ERRORS' $TEST_OUTPUT
then
    exit 1
fi

if grep -q 'FAILURES' $TEST_OUTPUT
then
    exit 1
fi

if [ ! -f $TEST_OUTPUT ]; then
    echo "Something went wrong!"
    exit 1
fi