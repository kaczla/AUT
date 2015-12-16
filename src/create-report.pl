#!/usr/bin/perl

use strict;

print "1..".($#ARGV + 1),"\n";

my $counter = 1;

for my $test_case (@ARGV) {

    my $test_case_name = $test_case;
    $test_case_name =~ s{\.res$}{};

    if (-s $test_case == 0) {
        print "ok $counter $test_case_name\n";
    } else {
        print "not ok $counter $test_case_name\n";

        open my $fh, '<', $test_case;

        while (my $line=<$fh>) {
            $line =~ s/^\s*---/===/;

            print "  $line";
        }
    }

    ++$counter;
}
