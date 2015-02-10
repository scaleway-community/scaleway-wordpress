#!/bin/bash
# Run this script
# SCRIPT=$(mktemp); curl -s https://raw.githubusercontent.com/online-labs/image-app-wordpress/master/test.bash > $SCRIPT; bash $SCRIPT

which shunit2 >/dev/null || (apt-get -qq update; apt-get install -yq shunit2)

testMysqlConnect() {
        echo SELECT 1 | mysql >/dev/null
        returnCode=$?
        assertEquals "Cannot connect to mysql without parameters" 0 $returnCode
}

testMysqlDBExists() {
        echo SELECT 1 | mysql wordpress >/dev/null
        returnCode=$?
        assertEquals "Cannot connect to wordpress database" 0 $returnCode
}

testMysqlUserExists() {
        echo 'select count(*) from wp_users' | mysql wordpress | grep 1 >/dev/null
        returnCode=$?
        assertEquals "No admin account" 0 $returnCode
}

. shunit2
