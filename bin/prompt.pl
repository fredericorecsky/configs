#!/usr/bin/env perl

use strict;
use warnings;

use Cwd;
use File::Basename;
use Term::ANSIColor;
use Sys::Hostname;

$| = 1;

binmode(STDOUT, ":utf8");

my ( $status ) = @ARGV;

status();
host_dir();
git_info();
rperl();
print "\n";
print "\x{2605} :"; # does not work for some fonts

sub status { 
    print "[";
    if ( $status ) {
        print color( 'red' );
        print " \x{1f615} "; # does not work for some fonts
        print "$status";
    }else{
        print color( 'green' );
        print " \x{2615} "; # does not work for some fonts
        print " ok ";
    }
    print color('reset' );
    print "]"
}

sub host_dir {
    my $hostname = hostname();
    my $cwd = getcwd();
    my $ssh = ( $ENV{SSH_CLIENT} || $ENV{ SSH_TTY } ) ? 1 : 0;
    print "[";
    $ssh ? print color( 'on_blue' ) : print color( 'blue');
    print $hostname . ":";
    print color( 'reset' );
    if ( $cwd =~ /^$ENV{ HOME }(.*)/ ) {
        print "~$1";
    }else{
        print $cwd;
    }
    print "]";
}

sub git_info {
    my $git_toplevel = `git rev-parse --show-toplevel 2>/dev/null`;
    if ( !$? ){
        my ( $git_branch ) = `git rev-parse --abbrev-ref HEAD`; 
        $git_branch =~ s/\*\s+//;
        chomp $git_branch;
        my @remotes = `git remote -v`;
        my $origin;
        for my $remote ( @remotes ) {
            my ( $name, $server ) = split ( /\s/, $remote );
            $origin = basename $server;
        }
        print "[";
        print color( 'magenta' );
        print "$origin:";
        print color( 'cyan' );
        print "$git_branch";
        print color( 'reset' );
        print "]";
    }
}

# TODO move to rperl
sub rperl {
    if ( -e "$ENV{ HOME }/.rperl_remote" ) {
        open my $fh, "<", "$ENV{ HOME }/.rperl_remote";  # data point
            my $remote = <$fh>;
        close $fh;
        print "[::$remote]";
    }
}



