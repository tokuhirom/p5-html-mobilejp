use Modern::Perl;
use HTML::MobileJp;

say "<html><body>";
for my $carrier (qw/I E V/) {
    for my $is_gps (0, 1) {
        my $html = gps_form(
            callback_url => 'http://gp.ath.cx/',
            carrier      => $carrier,
            is_gps       => $is_gps,
        );
        print qq{
            <h1>$carrier, $is_gps</h1>
            $html
            <input type="submit" value="post" />
            </form>
        };
    }
}
say "<div>carrier, is_gps</div>";
say "</body></html>";
