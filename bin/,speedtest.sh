#!/bin/bash
# Original Author: Alec Jacobson
#
# Test ssh connection speed by uploading and then downloading a 10000kB test
# file (optionally user-specified size)
#
# Usage:
#   ./speedtest.sh user@hostname [test file size in kBs]
#


ssh_server=$1
test_file=".scp-test-file"

# Optional: user specified test file size in kBs
if test -z "$2"
then
  # default size is 10kB ~ 10mB
  test_size="100000"
else
  test_size=$2
fi


# generate a 10000kB file of all zeros
echo "Generating $test_size kB test file..."
set -x
`dd if=/dev/zero of=$test_file bs=$(echo "$test_size*1024" | bc) count=1 &> /dev/null`

# upload test
echo "Testing upload to $ssh_server..."
up_speed=`scp -v $test_file $ssh_server:$test_file 2>&1 | \
  grep "Bytes per second" | \
  sed "s/^[^0-9]*\([0-9.]*\)[^0-9]*\([0-9.]*\).*$/\1/g"`
up_speed=`echo "($up_speed*0.0009765625*100.0+0.5)/1*0.01" | bc`

# download test
echo "Testing download from $ssh_server..."
down_speed=`scp -v $ssh_server:$test_file $test_file 2>&1 | \
  grep "Bytes per second" | \
  sed "s/^[^0-9]*\([0-9.]*\)[^0-9]*\([0-9.]*\).*$/\2/g"`
down_speed=`echo "($down_speed*0.0009765625*100.0+0.5)/1*0.01" | bc`

# clean up
echo "Removing test file on $ssh_server..."
`ssh $ssh_server "rm $test_file"`
echo "Removing test file locally..."
`rm $test_file`
set +x

# print result
echo ""
echo "Upload speed:   $up_speed kB/s"
echo "Download speed: $down_speed kB/s"

up_mbps=$(echo "scale=0; $up_speed/125" |bc)
down_mbps=$(echo "scale=0; $down_speed/125" |bc)

echo "Upload speed: $up_mbps mbps"
echo "Download speed: $down_mbps mbps"
