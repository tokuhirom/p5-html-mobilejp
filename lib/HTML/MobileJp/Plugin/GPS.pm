package HTML::MobileJp::Plugin::GPS;
use strict;
use warnings;
use URI::Escape;
use Params::Validate;
use HTML::Entities;
use base qw/Exporter/;

our @EXPORT = qw/gps_a gps_a_attributes/;

my $codes = +{
    E => +{
        basic => sub {
            # http://www.au.kddi.com/ezfactory/tec/spec/eznavi.html
            +{ href => 'device:location?url=' . uri_escape $_[0] };
        },
        gps => sub {
            # http://www.siisise.net/gps.html#augps
            # datum:wgs84, unit:dms
            +{
                href => (
                        'device:gpsone?url='
                      . uri_escape( $_[0] )
                      . '&ver=1&datum=0&unit=0&acry=0&number=0'
                )
            };
          }
    },
    I => +{
        gps => sub {
            # http://www.nttdocomo.co.jp/service/imode/make/content/gps/
            +{ href => $_[0], lcs => 'lcs' };
        },
        basic => sub {
            # http://www.nttdocomo.co.jp/service/imode/make/content/iarea/
            +{
                href => (
                        'http://w1m.docomo.ne.jp/cp/iarea'
                      . '?ecode=OPENAREACODE&msn=OPENAREAKEY&posinfo=1&nl='
                      . uri_escape $_[0]
                )
            };
        },
    },
    H => +{
        basic => sub {
            # http://www.willcom-inc.com/ja/service/contents_service/club_air_edge/for_phone/homepage/index.html
            +{      href => 'http://location.request/dummy.cgi?my='
                  . uri_escape( $_[0] )
                  . '&pos=$location' };
        },
    },
    V => +{
        gps => sub {
            # http://developers.softbankmobile.co.jp/dp/tool_dl/web/position.php
            +{ href => 'location:auto?url=' . uri_escape($_[0]) };
        },
        basic => sub {
            # http://developers.softbankmobile.co.jp/dp/tool_dl/web/position.php
            +{ href => $_[0], z => 'z' };
        }
    },
};

sub gps_a_attributes {
    validate(
        @_,
        +{
            callback_url => qr{^https?://},
            carrier      => qr{^[IEVH]$},
            is_gps       => 1,
        }
    );
    my %args = @_;

    $codes->{$args{carrier}}->{$args{is_gps} ? 'gps' : 'basic'}->($args{callback_url});
}

sub gps_a {
    validate(
        @_,
        +{
            callback_url => qr{^https?://},
            carrier      => qr{^[IEVH]$},
            is_gps       => 1,
        }
    );
    my %args = @_;

    my $attributes = gps_a_attributes(%args);

    my $ret = "";
    for my $name (sort { $a cmp $b } keys %$attributes) {
        $ret .= qq{ $name="} . encode_entities($attributes->{$name}) . q{"};
    }
    "<a$ret>";
}

1;
