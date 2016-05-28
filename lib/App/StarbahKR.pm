package App::StarbahKR;
use 5.008;
use strict;
use warnings;

use App::StarbahKR::NetworkDetector;
use App::StarbahKR::ConnectionManager::NetworkManager;
use App::StarbahKR::SignInSequence;

our $VERSION = '0.0114514';

sub notify {
    my $message = shift;

    # FIXME: TOO DIRTY X(
    if ($ENV{DISPLAY} && -e '/usr/bin/kdialog') {
        system('/usr/bin/kdialog', '--title', 'Starbucks Wifi Agent', '--passivepopup', $message);
    }
    warn $message;
}

sub perform_signin {
    unless (is_online()) {
        my $sequence = App::StarbahKR::SignInSequence->new;

        eval {
            my $code = $sequence->signin; 
            die "로그인 코드가 정의되어 있지 않습니다." unless defined $code;
            # TODO: 1001일 시 다시 로그인 시도
            die "로그인 코드 $code 가 반환되었습니다" unless $code == 0;

            notify("정상적으로 로그인 되었습니다.");
        };

        if ($@) {
            notify("로그인에 실패했습니다: $@");
            exit 0;
        }
    } else {
        notify('이미 온라인 상태입니다.');
        exit 0;
    }
}

sub auto {
    # TODO: support other connection manager, like netctl ... etc
    my $manager = App::StarbahKR::ConnectionManager::NetworkManager->new;
    unless ($manager->is_enabled) {
        notify("NetworkManager가 실행되고 있지 않습니다. 종료합니다.");
        exit -127;
    } 

    if (grep { is_starbucks_ssid($_) } $manager->get_current_ssid) {
        perform_signin();
    } else {
        notify("Starbucks Wi-Fi AP에 연결되어 있지 않습니다.");
        exit -1;
    }
}


1;
__END__

=head1 NAME

App::StarbahKR - Starbucks Wi-Fi AP에 자동으로 로그인 해 줍니다.

=head1 SYNOPSIS

    use App::StarbahKR;

    # 알아서 합니다.
    # (NetworkManager가 실행되어 있을 때에만 유효)
    App::StarbahKR::auto();
    
    # 우선 로그인 해봅니다.
    App::StarbahKR::perform_signin();

=head1 DESCRIPTION

App::StarbahKR is ...

=head1 AUTHOR

unstabler E<lt>dopping.cheese {at} gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
