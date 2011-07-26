package AnyMQ::Topic::Trait::Hippie;
use Moose::Role;
use AnyEvent;
use AnyEvent::HTTP::MXHR qw/ mxhr_get /;
use Data::Dumper;
use JSON;
use Try::Tiny;
use namespace::autoclean;

has bus => (is => "ro", required => 1);
has _xhr_guard => ( is => 'ro', lazy => 1, builder => '_build_xhr_guard', clearer => '_clear_xhr_guard' );

sub _build_xhr_guard {
    my $self = shift;
    my $uri = sprintf "http://%s:%d/_hippie/mxhr/%s?client_id=", $self->bus->host, $self->bus->port, $self->name;
    mxhr_get($uri,
            on_error => sub { Carp::cluck("Error @_"); $self->_clear_xhr_guard; },
            on_eof => sub { warn("EOF @_"); $self->_clear_xhr_guard; },
            sub {
                my ($payload, $headers) = @_;
                if ($headers->{'content-type'} ne "application/json") {
                    warn("Got message in content-type: " . ($headers->{'content-type'}||'unknown') . " I don't know how to deal with, ignoring.");
                }
                else {
                    try { $self->publish(JSON::from_json($payload)) }
                    catch { warn "failed to publsih: $_" };
                }
                # return true if you want to keep reading. return false
                # if you would like to stop
                return 1;
            }
    );
}

sub BUILD {}; after 'BUILD' => sub {
    my $self = shift;
    $self->_xhr_guard;
};

sub DEMOLISH {}; after 'DEMOLISH' => sub {
    my $self = shift;
    $self->_clear_xhr_guard;
};

1;

