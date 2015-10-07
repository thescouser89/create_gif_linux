#!/bin/bash
set -e
# ==============================================================================
# Utility to create gifs of a window screen
#
# You need to make sure that byzanz, dzen2 and xwininfo are installed first
#
# Author: Dustin
# ==============================================================================

# ******************************************************************************
# Set the max duration (in seconds) of the gif
# ******************************************************************************
MAX_DURATION=100

# First let's ask the user which window he wants to capture
echo "Please click on the window you'd like to record"

# let's capture the window coordinates
xwindow_info="$(xwininfo)"
upper_left_x=$(echo -e "${xwindow_info}" | grep "Absolute upper-left X" | awk '{ print $4 }')
upper_left_y=$(echo -e "${xwindow_info}" | grep "Absolute upper-left Y" | awk '{ print $4 }')
width=$(echo -e "${xwindow_info}" | grep "Width:" | awk '{ print $2 }')
height=$(echo -e "${xwindow_info}" | grep "Height:" | awk '{ print $2 }')

echo "Once you press Enter key, recording will start after 5 seconds"
# wait for user to press the Enter key
read
sleep 5

echo ""
echo "Recording started"

# Sleep a little bit to give time for the zenity window to disappear
name_of_gif="$(date  +%Y-%m-%d-%H-%M-%S).gif"
# hack to get the pid of backgrounded byzanz-record
jobs &>/dev/null
byzanz-record  \
    --duration=${MAX_DURATION} \
    --x=${upper_left_x} \
    --y=${upper_left_y} \
    --width=${width} \
    --height=${height} \
    ${name_of_gif} &

new_job_started="$(jobs -n)"
if [ -n "${new_job_started}" ];then
    pid_byzanz=$!
fi

echo "Click here to stop recording" | dzen2 -e 'button1=exit;button2=exit;button3=exit' -y -1 -p

kill ${pid_byzanz}
