#!/usr/bin/perl
#
# this application will take the input handed to it by Apache
# it will then look at the event that the switchvox sent to determine the path to go through
# using the other variables, it will convert the GET that the switchvox sent it and convert it
#    into variables to be passed in JSON format to the slack server as a POST
#
# add some required perl modules
# require lwp;


# the base URL defines the web server to whom to send the JSON messages
# this is common among _all_ slack users
$slack_api_url = "https://hooks.slack.com/services";

# Define the channels to which messages will be sent.
# the <name>_channel will be appended to the slack_api_url, defined above
# for testing, this channel has been defined for novation systems general channel
$general_channel = "/T04SM9RP9/B04SWH2NM/B38qFo36HvoAtXpk2vuxQk8E/";

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
# so $pair[1] would be something=value
foreach $pair (@pairs) # roll through the list of values
{
    ($name, $value) = split(/=/, $pair); # create an array pair
}

# so that we can see the results on the web browser (during testing)
print "Content-type:text/html\r\n\r\n";
print "<html>";
print "<head>";
print "<title>values</title>";
print "</head>";
print "<body>";
print "<h2>Values</h2>";
# print "<p>$buffer</p>";
print "<p>";
print $pair;
foreach $pair (@pairs) {
    print $pair."<br>\n";
}
print "</body>";
print "</html>";
