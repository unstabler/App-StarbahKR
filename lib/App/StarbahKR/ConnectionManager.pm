package App::StarbahKR::ConnectionManager;
use strict;
use warnings;

=cut 

=head1 IMPLEMENTATION NOTE

다중 WLAN 인터페이스 사용 시를 대비하여 get_current_ssid 구현은 반드시 LIST를 반환해야 합니다.

=cut

sub is_enabled {
    warn "This is base class; Not Implemented! X(";
}

sub get_current_ssid {
    warn "This is base class; Not Implemented! X(";
}

1;
