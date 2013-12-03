#!/usr/bin/env perl

use warnings;
use strict;
use 5.10.1;

use LWP::UserAgent;
use IO::String;
use BibTeX::Parser;
use Mac::Pasteboard;

# get the DOI information
my $doi = shift;

my $ua = LWP::UserAgent->new;
my $req = HTTP::Request->new(GET => "http://dx.doi.org/$doi");
$req->header(Accept => "text/bibliography; style=bibtex");

my $res = $ua->request($req);
die "get failed" unless $res->is_success;
my $bibtex = $res->content;

# set up bibtex as a filehandle
my $io = IO::String->new($bibtex);

# parse the bibtex using the filehandle
my $parser = BibTeX::Parser->new($io);
my $entry = $parser->next;
die "parsing failed" unless $entry->parse_ok;

# make a nice author line
my @authors = $entry->author;
my $first_author = $authors[0];
my $author = $first_author->first . " " . $first_author->last;
if (@authors == 2) {
    my $second_author = $authors[1];
    $author .= " and " . $second_author->first . " " . $second_author->last;
} elsif (@authors > 2) {
    $author .= " <i>et al.</i>";
}

my $title = $entry->field('title');
my $journal = $entry->field('journal');
my $volume = $entry->field('volume');
my $year = $entry->field('year');
my $pages = $entry->field('pages');

# create the citation
my $citation = "<body>$author, $title. <i>$journal</i> <b>$volume</b>, $pages ($year).</body>";
say $citation;

# copy it to the clipboard
my $pb = Mac::Pasteboard->new;
$pb->clear;
$pb->copy($citation, "public.html");

__END__
