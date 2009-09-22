package AnonPublicPost;

use strict;
use warnings;

# use MT::Log::Log4perl qw( l4mtdump ); our $logger;

sub check_user {
    my $cb    = shift;
    my $app   = shift;
    # $logger ||= MT::Log::Log4perl->new(); $logger->trace();

    # We only run if we detect an anonymous user posting an entry
    return if $app->user or ($app->mode || '') ne 'post';
    # $logger->info('>>>>>>>>>>>> ANONYMOUS POSTING <<<<<<<<<<<<<<<<');

    my $username = $app->config->PublicPostDefaultUser
        or return $app->error( no_anon_user() );
    
    my $user = MT->model('author')->load({ name => $username })
        or return $app->error( invalid_anon_user( $username ) );;

    # $logger->debug('$user: ', l4mtdump($user));

    my $cookieparam = $app->start_session( $user, 0 );
    require CGI::Cookie;
    $app->{cookies}{$app->user_cookie} = CGI::Cookie->new( %$cookieparam );
    # $logger->debug('$app->{cookies}: ', l4mtdump($app->{cookies}));

    my $session = $app->{session};
    $app->param( 'magic_token', $session->id );
    $app->user( $user );
    # $logger->debug('$app->param(magic_token): ', $app->param('magic_token'));
    $app->request('kill_anonymous_session', 1);
}

sub reap_session {
    my ($cb) = shift;
    my $app = MT->instance;
    # $logger ||= MT::Log::Log4perl->new(); $logger->trace();
    
    if ( $app->request('kill_anonymous_session') ) {
        # $logger->debug('Killing session: ', $app->{session}->id);
        MT::Auth->invalidate_credentials( { app => $app } );
        # delete $app->{session};
        # my %cookies = $app->cookies();
        # $app->_invalidate_commenter_session( \%cookies );
    }
}

sub invalid_anon_user {
    _post_error(
        "PublicPostDefaultUser '[_2]' not found.",
        $_[0]
    );
}

sub no_anon_user {
    _post_error("No PublicPostDefaultUser defined.")
}

sub _post_error {
    my ($message, @params) = @_;
    my $plugin = MT->component(__PACKAGE__);
    MT->log({
        message => $plugin->translate(
            "[_1] error: $message", $plugin->name, @params
        ),
        level    => MT::Log::INFO(),
        class    => 'entry',
        category => 'new',
    });
    return $plugin->translate("Error: Could not post");
}

1;
