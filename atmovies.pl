#!/usr/bin/perl -w
use strict;

unless(0 == $#ARGV)
{
    print "Usage: $0 <\@atmovies URL>\n";
    exit;
}

my $CURL = '/usr/bin/curl -s';

my $url = shift;

my %imdb = ( 'date' => '',
             'name' => '',
             'url' => ''
           );
my @curl = `$CURL $url`;
foreach(@curl)
{
    # 終極救援 Extraction <img src="/images/cer_F2.gif" vspace=5 align=absmiddle>
    if(/(\S+) (.*) <img .* vspace=5 align=absmiddle>/)
    {
        $imdb{'name'} = "$1_$2";
    }

    if(/上映日期：(\S+)</)
    {
        $imdb{'date'} = $1;
        $imdb{'date'} =~ s/\//\-/g;
    }

    # <LI><a  href="http://us.imdb.com/Title?3416744" target=_blank>IMDb</a>
    if(/ href="(\S+)" target=_blank>IMDb</i)
    {
        $imdb{'url'} = $1;
    }
}

print $imdb{'date'} . "_" . $imdb{'name'} . "\n";
print $imdb{'url'} . "\n";
