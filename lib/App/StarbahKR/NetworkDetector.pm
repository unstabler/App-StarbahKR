package App::StarbahKR::NetworkDetector;
use strict;
use warnings;

use LWP::UserAgent;
use Exporter;

our @ISA    = qw/Exporter/;
our @EXPORT = qw/is_online is_starbucks_ssid/; 

sub GOOGLE_PORTAL_URL   () { 'http://clients3.google.com/generate_204' }
sub STARBUCKS_SSID_LIST () { 
    (
        'olleh_starbucks',
        'olleh GiGA WiFi'
    )
}

sub is_starbucks_ssid {
    my $ssid = shift;

    return scalar grep { $_ eq $ssid } STARBUCKS_SSID_LIST;
}

sub is_online {
    my $ua  = LWP::UserAgent->new;
    my $res = $ua->get(GOOGLE_PORTAL_URL);

    return $res->code == 204;
}

1;
