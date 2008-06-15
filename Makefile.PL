use inc::Module::Install;
name 'HTML-MobileJp';
all_from 'lib/HTML/MobileJp.pm';

requires $_ for (qw/
    URI::Escape
    HTML::Entities
    Params::Validate
/);

test_requires 'Test::Base';
test_requires 'Test::More';
test_requires 'YAML';
use_test_base;
auto_include;
WriteAll;
