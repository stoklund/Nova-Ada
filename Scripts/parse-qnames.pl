#!/usr/bin/env perl
# Parse qualified names out of Annex Q Language-Defined Entities.

my $leaf = "";

while (<>) {
    if (/<div class="Index">(\w+)/) {
        $leaf = $1;
        printf("L %s\n", $leaf);
    }
    if (/<I>(child of|in)<\/I>\s*([\w\.]+)/) {
        printf("Q %s.%s\n", $2, $leaf);
    }
}