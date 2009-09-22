package AnonPublicPost;

use strict;
use warnings;

# use MT::Log::Log4perl qw( l4mtdump ); our $logger;

sub check_user {
    my $cb    = shift;
    my $app   = shift;
    # $logger ||= MT::Log::Log4perl->new(); $logger->trace();

    # We only run if we detect an anonymous user posting an entry
    return if $app->user;               # Not anonymous
    return unless 'post' eq $app->mode; # Not a 'post' (entry submission)

    # $logger->info('>>>>>>>>>>>> ANONYMOUS POSTING <<<<<<<<<<<<<<<<');

    # Lookup the PublicPostDefaultUser account name from the config
    # Return an error it has not been set
    my $username = $app->config->PublicPostDefaultUser
        or return $app->error( no_anon_user() );
    
    # Load the PublicPostDefaultUser user, return an error if not found
    my $user = MT->model('author')->load({ name => $username })
        or return $app->error( invalid_anon_user( $username ) );
    # $logger->debug('$user: ', l4mtdump($user));

    # Start a session for the user
    my $cookieparam = $app->start_session( $user, 0 );

    # Append the cookie onto the cookies hash
    # This is necessary in some cases where the cookies are read prior
    # to this code being executed, like (I think) when custom fields
    # are in use.
    require CGI::Cookie;
    $app->{cookies}{$app->user_cookie} = CGI::Cookie->new( %$cookieparam );
    # $logger->debug('$app->{cookies}: ', l4mtdump($app->{cookies}));

    # Get the previously created session's ID and store it in the app parameter
    # hash as a value for the magic_token which is used to validate the session
    my $session = $app->{session};
    $app->param( 'magic_token', $session->id );

    # Store the current user as the $app->user
    $app->user( $user );
    # $logger->debug('$app->param(magic_token): ', $app->param('magic_token'));

    # Flag this request so that reap_session will do it's work at post_run
    $app->request('kill_anonymous_session', 1);
}

sub reap_session {
    my ($cb) = shift;
    my $app = MT->instance;
    # $logger ||= MT::Log::Log4perl->new(); $logger->trace();

    # We only do this if we've flagged this request as an anonymous post
    return unless $app->request('kill_anonymous_session');
    # $logger->debug('Killing session: ', $app->{session}->id);

    # Here we invalidate the session and the user cookie to prevent login.
    # However, we preserve the $app->user data to prevent display of the login form
    my $user = $app->user;
    MT::Auth->invalidate_credentials( { app => $app } );
    $app->user($user);
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
