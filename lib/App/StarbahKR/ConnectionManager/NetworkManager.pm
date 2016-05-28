package App::StarbahKR::ConnectionManager::NetworkManager;
use strict;
use warnings;

use base 'App::StarbahKR::ConnectionManager';

# FIXME: HARD-CODED NMCLI PATH
sub NMCLI_PATH           () { '/usr/bin/nmcli' }
sub CONNECTION_TYPE_WIFI () { '802-11-wireless' }

sub new {
    return bless {}, __PACKAGE__;
}

sub _nmcli {
    my $output;

    open my $handle, '-|', NMCLI_PATH, @_;
    binmode $handle, ':encoding(utf8)';
    $output .= $_ while <$handle>;
    close $handle;

    return $?, $output if wantarray;
    return $output;
}

sub _parse_ssid_list {
    my $output = shift;
    my @connected;

    for my $row (split "\n", $output) {
        my ($name, $type) = split ":", $row;
        if ($type eq CONNECTION_TYPE_WIFI) {
            push @connected, $name;
        }
    }

    return @connected;
}

sub is_enabled {
    return unless grep { $^O eq $_ } qw/linux openbsd freebsd/;

    my ($status) = _nmcli('general');
    return $status == 0;
}

sub get_current_ssid {
    my ($status, $output) = _nmcli('-t', '-f', 'name,type', 'connection', 'show', '--active');

    if ($status != 0) {
        warn "operation failed; seems NetworkManager is not running :(";
        return;
    }

    return _parse_ssid_list($output);
}

1;
