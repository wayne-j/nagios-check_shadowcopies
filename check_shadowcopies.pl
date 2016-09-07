#!/usr/bin/perl
#require wmic
use strict;
use warnings;

my $HOST=$ARGV[0];
my $user=$ARGV[1];
my $pass=$ARGV[2];
my $warn=$ARGV[3];
my $crit=$ARGV[4];
my $xresult=0;

if (@ARGV ne 5) { print "Proper usage:\n./check_shadowcopies.pl [Hostname] [domain/user] [password] [Min amount of desired copies in MB] [Min count of copies]\n"; exit 3; }

my $requeststorage = `wmic -U $user%$pass //$HOST "select UsedSpace from Win32_ShadowStorage"`;

if ( !$requeststorage ) { print "No WMI Response.\n"; exit 3;}
my @storageresult = split (/\"\|/,$requeststorage);
foreach ( @storageresult ) {
	m/^(\d+)/mg;
	if ($1) {$xresult = $xresult+$1;}
}
my $usedspace = sprintf("%.2f", ($xresult/1048576));

my @requestcopy = `wmic -U $user%$pass //$HOST "Select * from Win32_ShadowCopy where State = 12"`;
my $shadowcount = ((scalar(grep $_, @requestcopy))-2);

if ( ($usedspace < $warn) && ($shadowcount >= $crit) )
        {
        print "Warning: Only $usedspace MB of space is being used in $shadowcount shadowcopies|'Space Used'=".$usedspace."MB;;;\n";
        exit 1;
}
elsif ($shadowcount < $crit)
        {
        print "Critical: Only $shadowcount shadowcopies have been taken, using $usedspace MB of space|'Space Used'=".$usedspace."MB;;;\n";
        exit 2;
}
else
        {
        print "$shadowcount Shadowcopies using $usedspace MB of space|'Space Used'=".$usedspace."MB;;;\n";
        exit 0;
}
