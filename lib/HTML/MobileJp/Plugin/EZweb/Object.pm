package HTML::MobileJp::Plugin::EZweb::Object;
use strict;
use warnings;
use base 'Exporter';
use Params::Validate;
use HTML::Entities;

our @EXPORT = qw/ezweb_object/;

sub _escape { encode_entities( $_[0], q{<>&"'} ) }

sub _param {
    sprintf q{<param name="%s" value="%s" valuetype="data" />},
      _escape( $_[0] ), _escape( $_[1] );
}

sub ezweb_object {
    validate(
        @_,
        +{
            url    => 1,
            mime_type   => 1,
            copyright   => qr{^(?:yes|no)$},
            standby     => 0,
            disposition => qr{^dev.+$},
            size        => qr{^[0-9]+$},
            title       => 1,
        }
    );
    my %args = @_;

    my @ret;
    push @ret, sprintf(
        q{<object data="%s" type="%s" copyright="%s" standby="%s">},
        _escape( $args{url} ),
        _escape( $args{mime_type} ),
        _escape( $args{copyright} ),
        _escape( $args{standby} )
    );
    for my $key (qw/disposition size title/) {
        push @ret, _param($key, $args{$key});
    }
    push @ret, "</object>";

    join("\n", @ret) . "\n";
}

1;
