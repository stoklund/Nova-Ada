#!/usr/bin/env perl
# Parse completions out of standard specifications.

my %stdpacks;
my @gargs = ();
my $ingen = 0;

# First read a list of standard packages.
open(FH, '<', 'std-qpackages.txt') or die;
while(<FH>) {
    chomp;
    $stdpacks{$_} = 1;
}

while (<>) {
    if (/^generic/) {
        @gargs = ();
        $ingen = 1;
    }
    next unless $ingen;

    if (/^\s+with\s+(package|function|procedure)\s+([^\s()]+)/) {
        push(@gargs, "$2 => \$[$1]");
    }
    if (/^\s+type\s+(\w+)/) {
        push(@gargs, "$1 => \$[type]");
    }

    if (/^package\s+([\w.]+)\s+is/) {
        if ($stdpacks{$1}) {
            $stdpacks{$1} = join(", ", @gargs);
        }
        @gargs = ();
        $ingen = 0;
    }

    if (/^(function|procedure)\s+([\w.]+)/) {
        #printf("%s %s\n", $1, $2);
        @gargs = ();
        $ingen = 0;
    }
}

foreach my $pkg (sort keys %stdpacks) {
    my $app = $stdpacks{$pkg};
    next if $app == 1;
    $app =~ s/"/&quot;/g;
    $app =~ s/>/&gt;/g;
    $app =~ s/</&lt;/g;
    print <<"END";
        <completion string="$pkg">
            <behavior prefix="(?&lt;=new )">
                <append>($app)</append>
            </behavior>
        </completion>
END
}