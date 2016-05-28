package App::StarbahKR::Random;
use utf8;
use strict;
use warnings;

use Exporter;

our @ISA    = qw/Exporter/;
our @EXPORT = qw/generate_name generate_email/;

sub generate_name {
    # http://zetawiki.com/wiki/시대별_흔한_이름
    my @last_name  = qw/김 이 박 최 정 강 조 윤 장 임 오 한 신 서 권 황 안 송 류 홍/;
    my @first_name = qw/유진 민지 수빈 지원 지현 지은 현지 은지 예진 예지
                        서연 민서 서현 지우 서윤 지민 수빈 하은 예은 윤서
                        영숙 정숙 영희 명숙 경숙 순자 정희 순옥 영순 현숙 
                        영수 영철 영호 영식 성수 성호 상철 종수 경수 상호
                        동현 지훈 성민 현우 준호 민석 민수 주혁 준영 승현
                        민준 지후 지훈 준서 현우 예준 건우 현준 민재 우진/;

    my $generated_name = (
        $last_name [int rand(scalar @last_name) ] .
        $first_name[int rand(scalar @first_name)]
    );

    return $generated_name;
}

sub rand_number {
    return 1000 + int(rand(9000));
}

sub rand_alphabet {
    return chr(97 + int(rand(26)));
}

sub generate_email {
    my @domain_list = qw/gmail.com/;

    my $address;
        
    $address .= rand_alphabet() for 1 .. (1 + int(rand(4))); 
    $address .= rand_number();

    return sprintf("%s@%s", $address, $domain_list[int rand(scalar @domain_list)]);
}

1;
