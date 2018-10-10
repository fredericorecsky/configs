package MyPerl;

use strict;
use warnings;

use Data::Dumper;

use IPC::Open3;
use IO::Select;
use Symbol 'gensym';

sub execute {
    my ( $context, @cmd ) = @_;

    my ( $wtr, $rdr, $err, $pid );
    $err = gensym();

    eval {
        $pid = open3( $wtr, $rdr, $err, @cmd );
    };
    die "$@\n" if $@;

    my $sel = IO::Select->new;
    $sel->add( $rdr, $err );

    my ( $stdout, $stderr );

    while ( my @ready = $sel->can_read ) {
        for my $fh ( @ready ) {
            my $line;
            my $len = sysread $fh, $line, 4096;
            if ( $len == 0 ) {
                $sel->remove( $fh );
                next;
            } else {
                if ( $fh == $rdr ) {
                    $stdout .= $line;
                    print $line if $context->{ io_sync };
                    next;
                }
                if ( $fh == $err ) {
                    $stderr .= $line;
                    warn $line if $context->{ io_sync };
                    next;
                }
            }
        }
    }

    waitpid( $pid, 0 );

    return (( $? >> 8 ), $stdout, $stderr );
}

sub remote_host {
    my ( $context, $host ) = shift;
    
    if ( $host ) {
        my $run = `ssh $host exit`;  # TODO : exists_ssh_host
        
        if ( $? ){
            die <<EOF;
        The host: $host is offline or not configured on 
        ssh config file. Please check your ssh config on 
        $ENV{HOME}/.ssh/config.
EOF
        }else{
            open my $fh , ">", "$ENV{HOME}/.rperl_remote" or die;
                print $fh "$host";
            close $fh;
        }
    }
    
    #eval
    open my $fh, "<", "$ENV{HOME}/.rperl_remote" or die;
        $context->{ remote } = <$fh>;
    close $fh;
}





1;
