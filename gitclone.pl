#!/usr/bin/perl
#
# this application will take the input handed to it by Apache
# it will then look at the event that the github sent to
# clone the source controlled data from github (including itself!)
# then, it will copy the source files to the cgi-bin directory

use LWP::UserAgent;

sub postdata { # call with postdata(api,channel,message)
    # channel is a string that represents the part of the URL that slack uses to determine the channel
    # api is the static value of the slack api URL
    # message is what you want to show up in the channel
    my $api = shift;
    my $channel = shift;
    my $message = shift;
    
    my $handle = LWP::UserAgent->new; # create a new object to reference
    
    my $server_endpoint = "$api"; # define the full URL to which to POST
    #DEBUG
    print $server_endpoint."<br>\n";
    
    # set custom HTTP request header fields
    my $request = HTTP::Request->new(POST => $server_endpoint); # object to add  data
    $request->header('content-type' => 'application/json'); # header data to define
    
    # add POST data to HTTP request body
    my $post_data = '{"channel":"' . $channel . '","username":"gitclone","icon_emoji":":children_crossing:","text":"' . $message . '" }';

    #DEBUG
    print $post_data."<br>\n";
    
    # actually connect to the URL and POST the data
    $request->content($post_data);
    
    my $resp = $handle->request($request); # let's find out what happened
    if ($resp->is_success) { # if the code was a 200 or a handful of 400's, then
        my $response = $resp->decoded_content;
        print "Received reply: $response\n"; # report the successful code
    }
    else {
        print "HTTP POST error code: ", $resp->code, "<br>\n"; # bad news! a 100, 300, 500 or some 400's
        print "HTTP POST error message: ", $resp->message, "<br>\n";
    }
    
}

# the base URL defines the web server to whom to send the JSON messages
# this is common among _all_ slack users
$slack_api_url = "https://hooks.slack.com/services";

# Define the channels to which messages will be sent.
# the <name>_channel will be appended to the slack_api_url, defined above
# for testing, this channel has been defined for novation systems general channel
$general_channel = "/T04SM9RP9/B04SWH2NM/B38qFo36HvoAtXpk2vuxQk8E";

my $api = $slack_api_url . $general_channel;

# read all channels from a configuration file. That way, the config file can be updated without
# having to change this source code.
#
# open(my $FH,"<","./channels.cfg");
# read in the values and assign them to an array
# close $FH;

# at this point, we have a list of channels and their URLs
# now, we need to read what the web server sent us to determine which channel will receive the message
# and what that message might be.

# the CGI definition sets environment variables and passes them to the CGI program (this program) for use
#Variable Name	Description
#CONTENT_TYPE	The data type of the content. Used when the client is sending attached content to the server. For example file upload etc.
#CONTENT_LENGTH	The length of the query information. It's available only for POST requests
#HTTP_COOKIE	Return the set cookies in the form of key & value pair.
#HTTP_USER_AGENT	The User-Agent request-header field contains information about the user agent originating the request. Its name of the web browser.
#PATH_INFO	The path for the CGI script.
#QUERY_STRING	The URL-encoded information that is sent with GET method request.
#REMOTE_ADDR	The IP address of the remote host making the request. This can be useful for logging or for authentication purpose.
#REMOTE_HOST	The fully qualified name of the host making the request. If this information is not available then REMOTE_ADDR can be used to get IR address.
#REQUEST_METHOD	The method used to make the request. The most common methods are GET and POST.
#SCRIPT_FILENAME	The full path to the CGI script.
#SCRIPT_NAME	The name of the CGI script.
#SERVER_NAME	The server's hostname or IP Address
#SERVER_SOFTWARE	The name and version of the software the server is running.

# some of these we actually care about for this program:
#QUERY_STRING is the GET request - VERY important to this program
#REMOTE_ADDR/REMOTE_HOST will ensure that we're not being spoofed
#REQUEST_METHOD - nice to know, but not functionally interesting for this program
#PATH_INFO can be useful so that the program knows what path to use for retrieving or writing files
#SCRIPT_NAME - the name of this script, as the webserver calls it
#SCRIPT_FILENAME - combination of the previous two strings - the full path from root to file name

# initialize some local variables
local ($buffer, @pairs, $pair, $name, $value, %FORM, $req);

# Read in the passed values from the environment
$req = $ENV{'REQUEST_METHOD'}; # =~ tr/a-z/A-Z/; # convert the text to all uppercase

if ($req eq "GET") # if the method was a GET (we hope), then…
{
    $buffer = $ENV{'QUERY_STRING'}; # read the values from the incoming URL
}

# Split information into name/value pairs
@pairs = split(/&/, $buffer); # break out each value pair into a member of the @pairs array

# so that we can see the results on the web browser (during testing)
print "Content-type:text/html\r\n\r\n";
 print "<html>";
 print "<head>";
 print "<title>values</title>";
 print "</head>";
 print "<body>";
 print "<h2>Values</h2>";
 print "<p>";
 print "<table border=0>";

foreach $pair (@pairs) # roll through the list of values
{
    ($name, $value) = split(/=/, $pair); # create an array pair
    $$name=$value;
    
    #DEBUG print "<tr><td>"."$name"."</td><td>"."$value"."</td></tr>\n";
}
 print "</table>";
# at this point, all of the values have been placed into the same variables they were paired by (in lower case).
#

# now, let's do some logical routing of this information
$channel = "#programming";
$message = "TEST-> Testing, Testing, is this thing on? ";


# in this section, we will parse the message coming in and use the information to determine what needs to be sent in the message
# magically read the incoming data
if ( $buffer ne "" ) {
    $message = "GET request was: $buffer";
}

# in this section, we will fire off the copy of the data from github using the same format/structure/path that the current
# gitclone.sh uses. We could just fire-off the gitclone.sh, too. My only concern is that the script is probably running as
# the apache user (apache, _www, _apache, or something) that probably doesn't have the rights to overwrite the current cgi-bin
# contents with the new ones.

# my $user = getpwuid $<;

# $message = $message . " - User = $user";

system("/bin/sh /home/ec2-user/gitclone.sh");
if ( $? ne 0 )
{
    printf "command failed: %d : %n",$?,$! >> 8;
}
else
{
    printf "command exited with value %d", $? >> 8;
}

postdata($api,$channel,$message);


 print "</body>";
 print "</html>";
