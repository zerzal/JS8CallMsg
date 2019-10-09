#!/usr/bin/perl
#JS8Call APRS MESSAGEING - see $ver below

 #use strict;
 #use warning;
  
# SET VARIABLES
#######################

my $cgiurl = "index.pl";

my $ver = "1.1";

my $tmptxt = "js8msg.txt";

# PROCESS FORM DATA
########################
read(STDIN, my $buffer, $ENV{'CONTENT_LENGTH'});

#if no form data go to system start
   if (!$buffer) { 
         &begin;
   }

# Split the name-value pairs
@pairs = split(/&/, $buffer);

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

 if ($FORM{'EMAIL'}) {
 
my $preamble = "\@ALLCALL APRS::EMAIL-2  :";
my $email = $FORM{'to'};
my $msg = $FORM{'msg'};
my $tag = "{01}";

my $js8 = $preamble.$email."  $msg".$tag;
	
open TMP, '>', "$tmptxt";
print TMP $js8;
#print TMP "JUNK";
close TMP;
&begin
}


#OUTPUT FOR FORM SMSGTE
###########################

#OUTPUT FOR FORM APRS MSG
###########################


#MAIN PAGE MENU (FORMS)
#######################
if ($FORM{'EMAIL'}) {
&toEmail;
}

if ($FORM{'SMS'}) {
&toSMS;
}

if ($FORM{'APRS'}) {
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
print "<INPUT TYPE=submit NAME=EMAIL VALUE=EMAIL>\&nbsp\;\&nbsp\;";
print "</form>\n";

print "<FORM ACTION=$cgiurl METHOD=POST>";
print "<INPUT TYPE=submit NAME=SMS VALUE=SMS>\&nbsp\;\&nbsp\;";
print "</form>\n";

print "<FORM ACTION=$cgiurl METHOD=POST>";
print "<INPUT TYPE=submit NAME=APRS VALUE=APRS>";
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

print "<input id=email name=EMAIL type=hidden>\n";

#Fields of EMAIL form

print "<FONT SIZE = 2 color = Black>Email Address:</font><br>\n";
print "<input id=to name=to size=40 type=text><br><br>\n";

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

print "<input id=sms name=SMS type=hidden>\n";

#Fields of SMS form

print "<FONT SIZE = 2 color = Black>Phone Number or Shortcut:</font><br>\n";
print "<input id=to name=to size=40 type=text><br><br>\n";

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

print "<FONT SIZE = 2 color = Black>Phone Number or Shortcut:</font><br>\n";
print "<input id=to name=to size=40 type=text><br><br>\n";

print "<FONT SIZE = 2 color = Black>Enter Your Message:</font><br>\n";
print "<input id=msg name=msg size=40 type=text><br>\n";

print "<input type=submit> \* <input type=reset><br><br><br><br><br><br>\n";
print "</form>";

print "</body></html>\n";

exit;

}
