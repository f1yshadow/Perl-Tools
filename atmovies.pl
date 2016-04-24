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
my $line_count = 0;
foreach(@curl)
{
    ++$line_count;
#<div class="filmTitle"><!-- filmTitle -->
#	星際大戰七部曲：原力覺醒 Star Wars: The Force Awakens
#	<img src="/images/cer_G.gif" vspace=5 align=absmiddle>
#</div><!-- filmTitle end -->
    if(/filmTitle/i)
    {
        my $title = $curl[$line_count++];
        if($title =~ /(\S+) (.*)/)
        {
            $imdb{'name'} = "$1_$2";
        }
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
        last;
    }
}

print $imdb{'date'} . "_" . $imdb{'name'} . "\n";
print $imdb{'url'} . "\n";
