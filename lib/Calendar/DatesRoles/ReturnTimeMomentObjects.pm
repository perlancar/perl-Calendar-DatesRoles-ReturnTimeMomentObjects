package Calendar::DatesRoles::ReturnTimeMomentObjects;

# AUTHORITY
# DATE
# DIST
# VERSION

use 5.010001;
use strict;
use warnings;

use Time::Moment;
use Role::Tiny;

around get_entries => sub {
    my $orig = shift;
    my $entries = $orig->(@_);

    for my $entry (@$entries) {
        if ($entry->{date} =~ m!\A(\d\d\d\d)-(\d\d)-(\d\d)
                                (?:
                                    T(\d\d):(\d\d)
                                    (?:
                                        /(\d\d):(\d\d)
                                    )?
                                )?\z!x) {
            my ($y, $m, $d, $H1, $M1, $H2, $M2) = ($1,$2,$3, $4,$5, $6,$7);

            if (defined $H2) {
                $entry->{date_end} = Time::Moment->new(
                    year=>$y, month=>$m, day=>$d, hour=>$H2, minute=>$M2, second=>0);
            }
            if (defined $H1) {
                $entry->{date} = Time::Moment->new(
                    year=>$y, month=>$m, day=>$d, hour=>$H1, minute=>$M1, second=>0);
            } else {
                $entry->{date} = Time::Moment->new(
                    year=>$y, month=>$m, day=>$d);
            }
        } else {
            die "Can't parse entry's 'date' field: $entry->{date}";
        }

    }

    $entries;
};

1;
# ABSTRACT: Return Time::Moment objects in get_entries()

=head1 SYNOPSIS

 # apply the role to a Calendar::Dates::* class
 use Calendar::Dates::ID::Holiday;
 use Role::Tiny;
 Role::Tiny->apply_roles_to_package(
     'Calendar::Dates::ID::Holiday',
     'Calendar::DatesRoles::ReturnDateTimeObjects');

 # use the Calendar::Dates::* module as usual
 my $entries = Calendar::Dates::ID::Holiday->get_entries(2020);

 # now the 'date' field in each entry in $entries are Time::Moment objects
 # instead of 'YYYY-MM-DD' strings.


=head1 DESCRIPTION

This role is similar to L<Calendar::DatesRoles::ReturnDateTimeObjects> but
instead of returning L<DateTime> objects, this role returns L<Time::Moment>
objects instead.


=head1 SEE ALSO

L<Calendar::Dates>

L<Calendar::DatesRolse::ReturnDateTimeObjects>
