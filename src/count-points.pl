#!/usr/bin/perl

use strict;
use utf8;

use TAP::Parser;
use Data::Dumper;
use Cwd;

binmode(STDOUT, ':utf8');
binmode(STDERR, ':utf8');

my %overrides = ();

if (-r 'overrides.txt') {
    read_overrides();
}

my @reports = sort @ARGV;

my $total;
my %section_points = ('A' => 0, 'B' => 0, 'C' => 0);

my $student_id = get_student_id();

if (defined $student_id) {
    print "STUDENT ID is $student_id\n";
} else {
    print "UNKNOWN STUDENT ID\n";
}

intro();

for my $report (@reports) {
    update_total($report, process_report($report));
}

outro($total);

sub get_student_id {
    my $pwd = cwd();

    if (my ($student_id) = ($pwd =~ m{-s(\d{5,7})(/arena)?})) {
        return $student_id;
    }

    return undef;
}

sub update_total {
    my ($report_file_path, $points) = @_;

    my $section = get_section($report_file_path);

    if (defined $section && $section ne 'B') {
        if ($section_points{$section} > 0) {
            print "UWAGA: TYLKO ZADANIE Z NAJWIĘKSZĄ LICZBĄ PUNKTÓW BĘDZIE LICZONE DLA DZIAŁU $section\n";
        }

        if ($points > $section_points{$section}) {
            $total = $total - $section_points{$section} + $points;
            $section_points{$section} = $points;
        }
    } else {
        $total += $points;
    }
}

sub get_section {
    my ($report_file_path) = @_;

    if (my ($section) = ($report_file_path =~ m{Task([ABC])})) {
        return $section;
    }

    return undef;
}

sub get_failures_and_successes {
    my ($file_path) = @_;

    open my $tap_fh, $file_path or die $!;

    my $tap_parser = TAP::Parser->new( { source => $tap_fh } );

    while ( my $result = $tap_parser->next ) {
    }

    return (scalar($tap_parser->actual_failed), scalar($tap_parser->passed))
}

sub process_report {
    my ($report_file) = @_;

    my ($task_id) = ($report_file =~ m{^(.*)/report\.txt$});

    my $override_key = get_override_key($student_id, $task_id);

    if (exists $overrides{$override_key}) {
        my $override_points = $overrides{$override_key};

        print $task_id, " ", "FROM overrides.txt: ", $override_points, "\n";

        return $override_points;
    }

    my ($nb_of_failures, $nb_of_successes) = get_failures_and_successes($report_file);

    my $success = ($nb_of_failures == 0 && $nb_of_successes > 0);

    my ($points, $deadline, $total, $remainder) = parse_description($task_id);

    print $task_id, " ", ($success ? "PASSED" : "FAILED");

    if (!check_deadline($task_id, $deadline)) {
        $success = 0;
    }

    if (!check_if_the_right_task($student_id, $task_id, $total, $remainder)) {
        print " WRONG TASK!";
        $success = 0;
    }

    if (!$success) {
        $points = 0;
    }

    if ($success) {
        print "   POINTS: $points";
    }

    print "\n";

    return $points;
}

sub check_deadline {
    my ($task_id, $deadline) = @_;

    for my $file (glob "$task_id/*") {
        if ($file !~ m{\.(in|arg|out|exp|\~)$|/(description\.txt|run)$}) {
            my $last_timestamp = `(cd ../daut-2015-s$student_id ; git log -1 --format=\%cd --date=iso $file 2> /dev/null)`;

            if ($last_timestamp =~ m{\S}) {
                chomp $last_timestamp;
                if ($last_timestamp gt $deadline) {
                    print " TOO LATE [$file: $last_timestamp later than $deadline]";
                    return 0;
                }
            }
        }
    }

    return 1;
}

sub check_if_the_right_task {
    my ($student_id, $task_id, $total, $remainder) = @_;

    if (defined($total)) {
        if ($student_id % $total != $remainder) {
            return 0;
        }
    }

    my $rest3 = $student_id % 3;

    return 0 if $task_id eq 'TaskA00' and $rest3 != 0;
    return 0 if $task_id eq 'TaskA01' and $rest3 != 1;
    return 0 if $task_id eq 'TaskA02' and $rest3 != 2;

    return 0 if $task_id =~ m{^TaskE} and $student_id != 148603 and $student_id != 148335 and $student_id != 148521 and $student_id != 148567;

    return 1;
}

sub intro {
    print_header();
    print "SUMMARY\n\n";
}

sub outro {
    my ($points) = @_;

    print "\nTOTAL POINTS: $points\n";

    open my $fh, '>', 'result.csv';
    print $fh "POINTS\n";
    print $fh $points, "\n";
    close($fh);

    print_header();
}


sub print_header {
    print "=" x 20,"\n";
}

sub parse_description {
    my ($task_id) = @_;

    open my $fh, '<', "$task_id/description.txt" or die "???";

    my $points = 0;
    my $deadline = undef;
    my $total = undef;
    my $remainder = undef;

    while (my $line=<$fh>) {
        if ($line =~ m{^POINTS\s*:\s*(\d+)\s*$}) {
            $points = $1;
        } elsif ($line =~ m{^DEADLINE\s*:\s*(.*?)\s*$}) {
            $deadline = $1;
        } elsif ($line =~ m{^REMAINDER\s*:\s*(\d+)/(\d+)\s*$}) {
            $remainder = $1;
            $total = $2;
        }
    }

    return ($points, $deadline, $total, $remainder);
}

sub read_overrides {
    open my $fh, '<', 'overrides.txt';

    while (my $line=<$fh>) {
        chomp $line;
        my ($id, $task, $points, $info) = split/\s+/,$line;

        $overrides{get_override_key($id, "Task".$task)} = $points;
    }
}

sub get_override_key {
    my ($id, $task) = @_;

    return $id.'+'.$task;
}
