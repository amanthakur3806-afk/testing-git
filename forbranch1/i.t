#!/usr/bin/env perl
use strict;
use warnings;

# 1. Define an array of sample log lines
my @log_lines = (
    '2026-09-30 10:14:02 [INFO] User admin logged in.',
    '2026-09-30 10:15:11 [ERROR] Database connection failed.',
    '2026-09-30 10:16:45 [WARN] Low disk space on /dev/sda1.',
    '2026-09-30 10:17:22 [ERROR] Database connection failed.',
    '2026-09-30 10:18:01 [ERROR] File not found: config.json.',
    '2026-09-30 10:19:30 [INFO] Backup completed successfully.'
);

# 2. Define a hash to store error counts (Key: Error Message, Value: Count)
my %error_counts;

print "--- Processing Logs ---\n";

# 3. Loop through each log line using a foreach loop
foreach my $line (@log_lines) {
    
    # 4. Use a regular expression to match lines containing [ERROR]
    # It captures everything after '[ERROR] ' into the built-in variable $1
    if ($line =~ /\[ERROR\]\s+(.+)/) {
        my $error_message = $1;
        
        # Increment the count for this specific error message in our hash
        $error_counts{$error_message}++;
    }
}

print "Processing complete.\n\n";
print "--- Error Report ---\n";

# 5. Output the results from the hash
# 'keys %error_counts' returns a list of all unique error messages found
foreach my $error (keys %error_counts) {
    print "Error: '$error' occurred $error_counts{$error} time(s).\n";
}
