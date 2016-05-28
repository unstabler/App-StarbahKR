use utf8;
use strict;
use Test::More tests => 5;

use App::StarbahKR::NetworkDetector;

my %ssid_cases = (
    'olleh_starbucks'    => 1,
    'olleh GiGA WiFi'    => 1,
    'ollehWiFi'          => 0,
    'T wifi zone'        => 0,
    '私以外私じゃないの' => 0
);

while (my ($ssid, $expected) = each %ssid_cases) {
    my $got = int(is_starbucks_ssid($ssid));
    is($got, $expected, "is_starbucks_ssid($ssid): expected $expected, got $got.")
}
