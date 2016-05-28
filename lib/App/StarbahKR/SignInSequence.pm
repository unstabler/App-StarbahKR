package App::StarbahKR::SignInSequence;
use utf8;
use strict;
use warnings;

use Data::Dumper;
use Encode qw/decode/;
use LWP::UserAgent;
use HTTP::Cookies;
use JSON;

use App::StarbahKR::Random;

sub DEFAULT_USERAGENT () { 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/12.10240' }
sub GOOGLE_PORTAL_URL () { 'http://clients3.google.com/generate_204' }


sub HOST_HTTP  () { 'http://first.wifi.olleh.com' }
sub HOST_HTTPS () { 'https://first.wifi.olleh.com' }
sub URL_INDEX  () { HOST_HTTP  . '/starbucks/index_en_new.html' }
sub URL_ENTRY  () { HOST_HTTPS . '/starbucks/starbucks_en.php' }
sub URL_ISSUE  () { HOST_HTTPS . '/starbucks/issue.php' }

sub new {
    my $class = shift;

    my $body = {
        'ua' => LWP::UserAgent->new(
            'agent'      => DEFAULT_USERAGENT,
            'cookie_jar' => HTTP::Cookies->new
        )
    };

    return bless $body, $class;
}

sub signin {
    my $self = shift;
    my $redirection_url = $self->get_redirection_url 
        or die "redirection url을 확인할 수 없었습니다.";
    my %form = $self->extract_form(
        $self->{ua}->get($redirection_url)->decoded_content
    );

    my $name  = generate_name();
    my $email = generate_email();

    warn sprintf("%s (%s)로 로그인을 시도합니다.", $name, $email);

    $self->{ua}->post(URL_INDEX, \%form);

    $self->{ua}->post(URL_ENTRY, {
        firstflag  => $form{firstflag},
        branchflag => $form{branchflag},
        validUrl   => URL_INDEX 
    }, Referer => URL_INDEX);

    my $res = $self->{ua}->post(URL_ISSUE, {
        firstflag  => $form{firstflag},
        branchflag => decode('cp949', $form{branchflag}),
        lang       => 'en',
        devicecode => 'pc',
        ip         => $form{ip},
        mac        => $form{mac},

        userNm          => $name,
        cust_email_addr => $email
    }, Referer => URL_ENTRY);
    
    my $auth_result = from_json($res->decoded_content);
    my $code = int($auth_result->{result_cd});
    return $code;
}

sub get_redirection_url {
    my $self = shift;
    my $res = $self->{ua}->get(GOOGLE_PORTAL_URL);

    unless ($res->code == 200 && $res->redirects) {
        return;
    }

    my ($url) = $res->previous->header('Location');
    $url =~ s/index\.html/redirection.php/; 

    return $url;
}

sub extract_form {
    my $self = shift;
    my $html = shift;

    my %form;

    for my $key (qw/ip mac url firstflag branchflag ssid mmcap hotspot/) {
        my ($value) = $html =~ m/name\s*=\s*"$key"\s+value\s*=\s*"(.+?)"/;
        $form{$key} = $value;
    }

    return %form;
}

1;
