package AnyMQ::Trait::Hippie;
use Moose::Role;
use MooseX::Types::Moose qw/ Str Int /;
use namespace::autoclean;

has host => (is => "ro", isa => Str);
has port => (is => "ro", isa => Int);

sub new_topic {
    my ($self, $opt) = @_;
    $opt = { name => $opt } unless ref $opt;
    AnyMQ::Topic->new_with_traits(
        traits => ['Hippie'],
        %$opt,
        bus => $self );
}

1;

