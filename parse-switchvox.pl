#!/usr/bin/perl -w
#
# this application will take the input handed to it by Apache
# it will then look at the event that the switchvox sent to determine the path to go through
# using the other variables, it will convert the GET that the switchvox sent it and convert it
#    into variables to be passed in JSON format to the slack server as a POST
#
#
# the main channel is viewed by everyone
#
slack_api_url="https://hooks.slack.com/services"
main_channel_url="/T04SM9RP9/B04SWH2NM/B38qFo36HvoAtXpk2vuxQk8E/"

# add other channels, here, as needed
# Here is my change. Lets see what happens - Shane Hudson
