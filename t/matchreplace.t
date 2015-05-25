use strict;
use Test::More tests => 5;

BEGIN{ use_ok( 'Asterisk::config' ) };

my $file = 't/replace.conf';
my $filecontent = join "\n", ("disallow=all", "allow=alaw,ulaw,g729", "[usera]", "username=usera", "secret=s3cr3t", "disallow=all", "allow=alaw", "[userb]", "username=userb", "secret=s3cr3t", "disallow=all", "allow=alaw", "[userc]", "username=userc", "secret=s3cr3t", "disallow=all", "allow=alaw\n");
open my $fh,"+>:utf8", $file;
$fh->syswrite($filecontent);
close $fh;
my $conf = Asterisk::config->new( file => $file );

$conf->assign_matchreplace( section => 'usera', match => 'allow', replace => 'allow=speex');
$conf->assign_matchreplace( match => 'secret', replace => 'secret=qwerty' );
$conf->save_file();
$conf->reload();

is(@{$conf->fetch_values_arrayref( section => 'usera', key => 'allow'  )}[0], 'speex' , 'Section defined');
is(@{$conf->fetch_values_arrayref( section => 'usera', key => 'secret' )}[0], 'qwerty', 'Section not defined 1');
is(@{$conf->fetch_values_arrayref( section => 'userb', key => 'secret' )}[0], 'qwerty', 'Section not defined 2');
is(@{$conf->fetch_values_arrayref( section => 'userc', key => 'secret' )}[0], 'qwerty', 'Section not defined 3');

unlink $file;
