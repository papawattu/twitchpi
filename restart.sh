#!/bin/bash
# return GPIO input status

# select pin
GPIO=13
raspi-gpio set ${GPIO} pu 
# prepare the pin
if [ ! -d /sys/class/gpio/gpio${GPIO} ]; then
  echo "${GPIO}" > /sys/class/gpio/export
fi
echo "in" > /sys/class/gpio/gpio"${GPIO}"/direction

# continuously monitor current value
while true; do
  if [ 1 == "$(</sys/class/gpio/gpio"${GPIO}"/value)" ]; then
    printf "Low \r"
    sleep 1
  else
    printf "Restarting stream \r"
    systemctl restart stream
    sleep 5
  fi
done
