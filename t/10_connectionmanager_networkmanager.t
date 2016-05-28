use utf8;
use strict;
use Test::More tests => 2;

use App::StarbahKR::ConnectionManager::NetworkManager;

my $test_case = <<TEST_CASE_1;
New Ethernet Connection 1:802-3-ethernet
yaju senpai:931-stinks
오늘도 좋은 날씨:802-11-wireless
TEST_CASE_1

my @ssid_list = 
    App::StarbahKR::ConnectionManager::NetworkManager::_parse_ssid_list($test_case);

is(scalar @ssid_list, 1);
is($ssid_list[0], "오늘도 좋은 날씨");

