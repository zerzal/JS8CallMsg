#!/usr/bin/perl
#JS8Call APRS MESSAGEING - see $ver below

 #use strict;
 #use warning;
  use IO::Socket::INET;
  
# SET VARIABLES
#######################

#my $cgiurl = "js8callmsg.pl"; #for home local machine
my $cgiurl = "index.pl";  #for testing

my $ver = "1.0";

#my $tmptxt = "/home/dwayne/temp/js8msg.txt";  #for home local machine
my $tmptxt = "js8msg.txt";  #for testing

# PROCESS FORM DATA
########################
read(STDIN, my $buffer, $ENV{'CONTENT_LENGTH'});

#if no form data go to system start
   if (!$buffer) { 
         &begin;
   }

# Split the name-value pairs
my @pairs = split(/&/, $buffer);

foreach $pair (@pairs) {
   ($name, $value) = split(/=/, $pair);

# Un-Webify plus signs and %-encoding
   $value =~ tr/+/ /;
   $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
   $value =~ s/<!--(.|\n)*-->//g;

   $FORM{$name} = $value;
  
}

#OUTPUT FOR FORM EMAIL
#######################

 if ($FORM{'eto'}) {
 
my $preamble = "\@ALLCALL APRS::EMAIL-2 ";
my $colon = ":";
my $email = $FORM{'eto'};
my $msg = $FORM{'msg'};
my $tag = "{01}";
my $js8 = $preamble;
my $js81 = $colon.$email." $msg".$tag;

 print "Content-type: text/html\n\n";
 print "<html><head><title>STRING TO PASTE</title></head><body>\n";
 print "<FONT SIZE = 6><b><center>STRING TO PASTE</b></FONT><BR><BR>\n";
 print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;<FONT SIZE = 4>$js8\&nbsp\;$js81</FONT><br><br>\n";
 print "Return to the <a href=\"$cgiurl\">Entry Screen</a>.";
 print "</FONT></center>\n";
 print "</body></html>\n";
 exit;

#&result
	
#open TMP, '>', "$tmptxt";
#print TMP $js8;
#print TMP "JUNK AGAIN";
#close TMP;


#my $sock = new IO::Socket::INET(PeerAddr => '127.0.0.1',
#                PeerPort => 2237,
#                Proto => 'udp', Timeout => 1) or die('Error opening socket.');
#my $data = printf '{"params": {}, "type": "TX.SET_TEXT", "value": %s}\n' "$js8";
#print $sock $data;


}


#OUTPUT FOR FORM SMSGTE
###########################

 if ($FORM{'sto'}) {
my $preamble = "\@ALLCALL APRS::SMSGTE ";
my $colon = ":";
my $sms = $FORM{'sto'};
my $msg = $FORM{'msg'};
my $tag = "{01}";
my $js8 = $preamble;
my $js81 = $colon."\@$sms"." $msg".$tag;

 print "Content-type: text/html\n\n";
 print "<html><head><title>STRING TO PASTE</title></head><body>\n";
 print "<FONT SIZE = 6><b><center>STRING TO PASTE</b></FONT><BR><BR>\n";
 print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;<FONT SIZE = 4>$js8\&nbsp\;\&nbsp\;$js81</FONT><br><br>\n";
 print "Return to the <a href=\"$cgiurl\">Entry Screen</a>.";
 print "</FONT></center>\n";
 print "</body></html>\n";
 exit;
 
 }

#OUTPUT FOR FORM APRS MSG
###########################

 if ($FORM{'ato'}) {
my $preamble = "\@ALLCALL APRS::";
my $colon = ":";
my $aprs = $FORM{'ato'};
my $msg = $FORM{'msg'};
my $tag = "{01}";
my $js8 = $preamble;
my $js80 = $aprs;
my $js81 = $colon." $msg".$tag;

 print "Content-type: text/html\n\n";
 print "<html><head><title>STRING TO PASTE</title></head><body>\n";
 print "<FONT SIZE = 6><b><center>STRING TO PASTE</b></FONT><BR><BR>\n";
 print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;<FONT SIZE = 4>$js8 $js80 $js81</FONT><br><br>\n";
 print "Return to the <a href=\"$cgiurl\">Entry Screen</a>.";
 print "</FONT></center>\n";
 print "</body></html>\n";
 exit;
 
 }

#MAIN PAGE MENU (FORMS)
#######################
if ($FORM{'toemail'}) {
&toEmail;
}

if ($FORM{'tosms'}) {
&toSMS;
}

if ($FORM{'toaprs'}) {
&toAPRS;
}

#SUBROUTINES
#######################

#Main Menu
sub begin {
print "Content-type: text/html\n\n";
print "<html><head><title>APRS MESSEGING WITH JS8Call $ver</title></head>\n";
print "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">";
print "<body style=\"background-color:FF3333;\"><FONT SIZE = 5><b>APRS MESSEGING<BR>WITH JS8Call</b></FONT><FONT SIZE = 2 color = purple>\&nbsp\;\&nbsp\;<b>$ver</b><br>\n";
print "<br><FONT SIZE = 4 COLOR = BLUE><I>FORMS</I></FONT><BR><BR>";

print "<FORM ACTION=$cgiurl METHOD=POST>";
print "<INPUT TYPE=submit NAME=toemail VALUE=EMAIL>\&nbsp\;\&nbsp\;";
print "</form>\n";

print "<FORM ACTION=$cgiurl METHOD=POST>";
print "<INPUT TYPE=submit NAME=tosms VALUE=SMS>\&nbsp\;\&nbsp\;";
print "</form>\n";

print "<FORM ACTION=$cgiurl METHOD=POST>";
print "<INPUT TYPE=submit NAME=toaprs VALUE=APRS>";
print "</form>\n";

print "</body></html>\n";
exit;
}

#FORM EMAIL
sub toEmail {
print "Content-type: text/html\n\n";
print "<html><head><title>APRS EMAIL MESSAGE - JS8Call</title>";
print "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">";
print "<!-- Style to set the size of checkbox --> <style> input.largerCheckbox { width: 30px; height: 30px; } </style>";
print "</head>\n";
print "<body style=\"background-color:FFCC33;\"><FONT SIZE = 5><b>APRS EMAIL MESSAGE<br>JS8Call</b></FONT><br><br><br>\n";

print "<form method=POST action=$cgiurl>\n";

#Fields of EMAIL form

print "<FONT SIZE = 2 color = Black>Email Address:</font><br>\n";
print "<input id=eto name=eto size=40 type=text><br><br>\n";

print "<FONT SIZE = 2 color = Black>Enter Your Message:</font><br>\n";
print "<input id=msg name=msg size=40 type=text><br>\n";

print "<input type=submit> \* <input type=reset><br><br><br><br><br><br>\n";
print "</form>";

print "</body></html>\n";

exit;

}

#FORM SMS
sub toSMS {
print "Content-type: text/html\n\n";
print "<html><head><title>APRS SMS MESSAGE - JS8Call</title>";
print "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">";
print "<!-- Style to set the size of checkbox --> <style> input.largerCheckbox { width: 30px; height: 30px; } </style>";
print "</head>\n";
print "<body style=\"background-color:FFCC33;\"><FONT SIZE = 5><b>APRS SMS MESSAGE<br>JS8Call</b></FONT><br><br><br>\n";

print "<form method=POST action=$cgiurl>\n";

#Fields of SMS form

print "<FONT SIZE = 2 color = Black>Phone Number or Shortcut:</font><br>\n";
print "<input id=sto name=sto size=40 type=text><br><br>\n";

print "<FONT SIZE = 2 color = Black>Enter Your Message:</font><br>\n";
print "<input id=msg name=msg size=40 type=text><br>\n";

print "<input type=submit> \* <input type=reset><br><br><br><br><br><br>\n";
print "</form>";

print "</body></html>\n";

exit;

}

#FORM APRS
sub toAPRS {
print "Content-type: text/html\n\n";
print "<html><head><title>APRS MESSAGE - JS8Call</title>";
print "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">";
print "<!-- Style to set the size of checkbox --> <style> input.largerCheckbox { width: 30px; height: 30px; } </style>";
print "</head>\n";
print "<body style=\"background-color:FFCC33;\"><FONT SIZE = 5><b>APRS MESSAGE<br>JS8Call</b></FONT><br><br><br>\n";

print "<form method=POST action=$cgiurl>\n";

print "<input id=aprs name=APRS type=hidden>\n";

#Fields of APRS form

print "<FONT SIZE = 2 color = Black>APRS Station with SSID:</font><br>\n";
print "<input id=ato name=ato size=40 type=text><br><br>\n";

print "<FONT SIZE = 2 color = Black>Enter Your Message:</font><br>\n";
print "<input id=msg name=msg size=40 type=text><br>\n";

print "<input type=submit> \* <input type=reset><br><br><br><br><br><br>\n";
print "</form>";

print "</body></html>\n";

exit;

}

sub result {

 print "Content-type: text/html\n\n";
 print "<html><head><title>STRING TO PASTE</title></head><body>\n";
 print "<FONT SIZE = 6><b><center>STRING TO PASTE</b></FONT><BR><BR>\n";
 print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;<FONT SIZE = 15>$js8</FONT><br><br>\n";
 print "Return to the <a href=\"$cgiurl\">Entry Screen</a>.";
 print "</FONT></center>\n";
 print "</body></html>\n";
 exit;

}
