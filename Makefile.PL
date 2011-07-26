use strict;
use warnings;
use inc::Module::Install;

name 'AnyMQ-Hippie';
all_from 'lib/AnyMQ/Hippie.pm';

requires 'Web::Hippie' => '0.36';
requires 'AnyMQ' => '0.33';
requires 'AnyEvent::HTTP::MXHR' => '0.00005';
requires 'Moose';
requires 'namespace::autoclean';
requires 'MooseX::Types';

test_requires 'Test::More' => '0.88';

WriteAll;

