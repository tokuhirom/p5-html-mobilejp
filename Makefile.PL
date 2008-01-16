use inc::Module::Install;
name 'HTML-MobileJp';
all_from 'lib/HTML/MobileJp.pm';

requires $_ for (qw/ /);

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
