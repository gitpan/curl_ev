use strict;
use warnings;

use version;
use ExtUtils::PkgConfig;
use ExtUtils::MakeMaker;


my $minimum_libcurl_ver = "7.16.0";
my $libcurl_ver = eval {
	my %curl = ExtUtils::PkgConfig->find('libcurl');
	$curl{modversion};
};
if ($@) {
	print STDERR <<EOD;
libcurl not found ($@)
You must install libcurl $minimum_libcurl_ver or newer to.
NA: Unable to build distribution on this platform.
EOD
	exit;
}

print "Found libcurl version $libcurl_ver\n";

if ( version->parse($libcurl_ver) < version->parse($minimum_libcurl_ver) ) {
	print STDERR <<EOD;
Your currently installed libcurl version - $libcurl_ver - is too old.
This module does not support libcurl older than $minimum_libcurl_ver.
NA: Unable to build distribution on this platform.
EOD
	exit;
}


WriteMakefile(
	NAME         => "Net::Curl::Multi::EV",
	DISTNAME     => "curl_ev",
	ABSTRACT     => 'Using Net::Curl::Multi with EV',
	AUTHOR       => '<kni@cpan.org>',
	LICENSE      => "perl",
	VERSION_FROM => "CurlEV.pm",
	PREREQ_PM    => { EV => 4, 'Net::Curl' => 0.29 },
	PM           => { 'CurlEV.pm' => '$(INST_LIBDIR)/EV.pm' },
);
