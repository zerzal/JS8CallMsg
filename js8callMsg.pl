$value="\"@ALLCALL APRS::SMSGTE   :@${phone} ${msg}\""


#!/usr/bin/perl
#JS8Call APRS MESSAGEING - see $ver below

 #use strict;
 #use warning;
  
# SET VARIABLES
#######################

my $cgiurl = "index.pl";

my $ver = "1.0";

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
	
open TMP, ">$tmptxt";
print TMP "$js8";
close TMP;




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
&APRS;
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
print "<INPUT TYPE=submit NAME=APRS	VALUE=APRS>";
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

# Reply checkbox
print "<FONT SIZE = 3 color = Black><b>CHECK HERE IF REPLY</font>\&nbsp\;</b>\n";
print "<input id=reply name=reply type=checkbox value=1 class=largerCheckbox><br><br>\n";

#Fields of 213 form
# 1
print "<FONT SIZE = 2 color = Black>1. Incident Name (Optional):</font><br>\n";
print "<input id=incident name=incident size=40 type=text><br><br>\n";

# 2
print "<FONT SIZE = 2 color = Black>2. To (Name):</font><br>\n";
print "<input id=to name=to size=40 type=text><br>\n";

print "<FONT SIZE = 2 color = Black>Position/Title:</font><br>\n";
print "<input id=tpos name=tpos size=40 type=text><br>\n";

print "<FONT SIZE = 2 color = Black>Email Address: <b>REQUIRED</b></font><FONT SIZE = 2 color = 0099CC><br>(Can be Winlink user alias)</font><br>\n";
print "<input id=email name=email size=40 type=text><br>\n";

print "<FONT SIZE = 2 color = Black>CC:</font><br>\n";
print "<input id=cc name=cc size=40 type=text><br><br>\n";

# 3
print "<FONT SIZE = 2 color = Black>3. From (Name):</font><br>\n";
print "<input id=from name=from size=40 type=text><br>\n";

print "<FONT SIZE = 2 color = Black>Position/Title:</font><br>\n";
print "<input id=title name=title size=40 type=text><br>\n";

print "<FONT SIZE = 2 color = Black>Signature:</font><br>\n";
print "<input id=sig name=sig size=40 type=text><br><br>\n";

# 4
print "<FONT SIZE = 2 color = Black>4. Subject:</font><br>\n";
print "<input id=subject name=subject size=40 type=text>\n";

# 5
print "<br><br><FONT SIZE = 2 color = Black>5. Date:</font><br>\n";
print "<input id=date name=date size=14 type=text value=$lmon\/$lmday\/$lyear>\n";

# 6
print "<br><FONT SIZE = 2 color = Black>6. Time:</font><br>\n";
print "<input id=time name=time size=7 type=text value=$ftime><br><br>\n";

# 7
print "<FONT SIZE = 2 color = Black>7. Message: <b>REQUIRED</b></font><br>\n";
print "<textarea name=msg cols=40 rows=10></textarea><br><br>";

# 8
print "<FONT SIZE = 2 color = Black>8. Approved by (Name):</font><br>\n";
print "<input id=approved name=approved size=40 type=text><br>\n";

print "<FONT SIZE = 2 color = Black>Position/Title:</font><br>\n";
print "<input id=atitle name=atitle size=40 type=text><br>\n";

print "<FONT SIZE = 2 color = Black>Signature:</font><br>\n";
print "<input id=asig name=asig size=40 type=text><br><br>\n";

print "<input type=submit> \* <input type=reset><br><br><br><br><br><br>\n";
print "</form>";

print "</body></html>\n";

exit;

}

#FORM SMS
sub toSMS {
print "Content-type: text/html\n\n";
print "<html><head><title>FORM ARRL RADIOGRAM</title></head>\n";
print "<body><FONT SIZE = 5><b>FORM ARRL RADIOGRAM</b></FONT><br><br>\n";
print "<FONT SIZE = 2 color = Black>ARRL RADIOGRAM GOES HERE</font>\&nbsp\;\&nbsp\;\n";

print "<form method=POST action=$cgiurl>\n";

print "<input id=rgram name=rgram type=hidden value=radiogram>\n";
print "First name:<br><input type=text name=firstname><br>";

print "<input type=submit> \* <input type=reset><br><br>\n";
print "</form><br><br><br><br>\n";
print "</body></html>\n";
exit;
}

#FORM APRS
sub toAPRS {
print "Content-type: text/html\n\n";
print "<html><head><title>SIMPLE EMAIL</title></head>\n";
print "<body><FONT SIZE = 5><b>SIMPLE EMAIL</b></FONT><br><br>\n";
print "<FONT SIZE = 2 color = Black>SIMPLE EMAIL GOES HERE</font>\&nbsp\;\&nbsp\;\n";
print "</body></html>\n";
exit;
}

