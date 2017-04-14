#!/usr/bin/perl
#
# this application will take the input handed to it by Apache
# it will then look at the event that the switchvox sent to determine the path to go through
# using the other variables, it will convert the GET that the switchvox sent it and convert it
#    into variables to be passed in JSON format to the slack server as a POST
#
# add some required perl modules
# require lwp;
use LWP::UserAgent;

sub postslack {
    # call with postslack($message)
    # message is what you want to show up in the channel
    my $message = "sdjiflsjdfklsdjf";
    my $message = shift;

    # the base URL defines the web server to whom to send the JSON messages
    # this is common among _all_ slack users
    my $slack_api_url = "https://hooks.slack.com/services";
    
    # Define the channels to which messages will be sent.
    # the <name>_channel will be appended to the slack_api_url, defined above
    # for testing, this channel has been defined for novation systems general channel
    my $general_channel = "/T04SM9RP9/B04SWH2NM/B38qFo36HvoAtXpk2vuxQk8E";
    
    my $api = $slack_api_url . $general_channel;
    

    my $handle = LWP::UserAgent->new; # create a new object to reference
    
    my $server_endpoint = "$api"; # define the full URL to which to POST
    #DEBUG
    print $server_endpoint."<br>\n";
    
    # set custom HTTP request header fields
    my $request = HTTP::Request->new(POST => $server_endpoint); # object to add  data
    $request->header('content-type' => 'application/json'); # header data to define
    
    # add POST data to HTTP request body
    my $post_data = '{"channel":"' . $channel . '","text":"' . $message . '"}'; # a string to use for the POST
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

sub posthip {
    # call with posthip($message)
    my $message = shift;
    # curl -d '{"color":"green","message":"My first notification (yey)","notify":false,"message_format":"text"}' -H 'Content-Type: application/json' https://chat.novationsys.com/v2/room/1/notification?auth_token=CuswLbN2WOQNxnNY3FzCKuEKxNGDkNiInDYNE4hd
    
    # the base URL defines the web server to whom to send the JSON messages
    # this is common among _all_ slack users
    my $api = "https://chat.novationsys.com/v2/room/1/notification?auth_token=CuswLbN2WOQNxnNY3FzCKuEKxNGDkNiInDYNE4hd";
    
    my $handle = LWP::UserAgent->new; # create a new object to reference
    
    my $server_endpoint = "$api"; # define the full URL to which to POST
    #DEBUG
    print $server_endpoint."<br>\n";
    
    # set custom HTTP request header fields
    my $request = HTTP::Request->new(POST => $server_endpoint); # object to add  data
    $request->header('content-type' => 'application/json'); # header data to define
    
    # add POST data to HTTP request body
    my $post_data = '{"color":"green","message":"<B>' . $message . '</B>","notify":true,"message_format":"html"}'; # a string to use for the POST
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

sub postTeams {
# call with postTeams($message)
    #    print "sending to Teams";
    my $message = shift;
    print "<b>Message: </b><i>" . $message . "</i><P>";
    my $api = 'https://outlook.office.com/webhook/3264b3c1-43a5-44fb-89d5-a43cea7a9827@760e73b3-c900-465f-886b-563bf8055980/IncomingWebhook/111fa0d3a66e41eda1a7f44e59e330fc/9a98a86d-9de9-4cdf-a06c-96f691370682';
    my $handle = LWP::UserAgent->new;
    my $request=HTTP::Request->new(POST => $api);
    print "<b>Server URL: </b><i>" . $api ."</i><P>\n";

    # set custom HTTP request header fields
    my $request = HTTP::Request->new(POST => $api); # object to add  data
    $request->header('Content-type' => 'application/json'); # header data to define

# add POST data to HTTP request body
    my $post_data = '{';
    $post_data = $post_data . '"title":"PBX Message",';
    $post_data = $post_data . '"text":"' . $message . '"'; # a string to use for the POST
    $post_data = $post_data . '}';
    
#DEBUG
    print "<b>What I am sending: </b><i>" . $post_data . "<P></i>\n";

# actually connect to the URL and POST the data
    $request->content($post_data);

    my $resp = $handle->request($request); # let's find out what happened
    if ($resp->is_success) { # if the code was a 200 or a handful of 400's, then
        my $response = $resp->decoded_content;
        print "Received reply: $response\n"; # report the successful code
    } else {
        print "HTTP POST error code: ", $resp->code, "<br>\n"; # bad news! a 100, 300, 500 or some 400's
        print "HTTP POST error message: ", $resp->message, "<br>\n";
    }
}



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

# initialize some local variables
local ($buffer, @pairs, $pair, $name, $value, %FORM, $req);

# Read in the passed values from the environment
$req = $ENV{'REQUEST_METHOD'};

# removed check for GET/POST - don't care.
$buffer = $ENV{'QUERY_STRING'}; # read the values from the incoming URL

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
        $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
        $$name=$value;
     print "<tr><td>"."$name"."</td><td>"."$value"."</td></tr>\n";
    
}
  print "</table>";
# at this point, all of the values have been placed into the same variables they were paired by (in lower case).
#

# now, let's do some logical routing of this information
$channel = "#general";
$message = "Something odd happened.";
$message = $message . "\n" . $ENV{"REMOTE_ADDR"};

# Parse Caller ID Number to include Dashes
$number = " " . ${caller_id_number} . " ";

$split1 = substr($number,0,3);
$split2 = substr($number,3,3);
$split3 = substr($number,6,4);

# $number = "$split1$split2$split3";


#DEBUG print $caller_id_name;

if ( $event_type eq "incoming" ) {
        $channel = "#general";
        $message = "Incoming call from ${caller_id_name} $number";
        $message = $message . '<Br>Number dialed:' . "$incoming_did";
}


if ( $event_type eq "answered" ) {
    if ( ${extension} eq "s" ) {     # "s" was what registered as the extension on outgoing calls. This prevents a message being sent to slack on outgoing calls.
        exit
    }
        $channel = "#general";
        $message = "Call from ${caller_id_name} $number.";
        $message = $message . "<Br>Answered by: " . $extension;
}

#postslack($message);
#posthip($message);
postTeams($message);

 print "</body>";
 print "</html>";
