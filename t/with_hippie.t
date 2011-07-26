use strict;
use warnings;
use Test::More;
use Moose ();
use AnyEvent;
use AnyMQ;
use Data::Dumper;
my $bus = AnyMQ->new_with_traits(
    traits => ['Hippie'],
    host => "localhost",
    port => 5000,
);
my $topic = $bus->topic(3);
my $listener = $bus->new_listener($topic);
$listener->poll(sub {
      my @messages = @_;
      warn Data::Dumper::Dumper($_) for @messages;
});
AnyEvent->condvar->recv;

done_testing;

