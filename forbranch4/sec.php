<?php
declare(strict_types=1);

function is_valid_email(string $email): bool {
    // 1. Sanitize and validate basic email format
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        return false;
    }

    // 2. Extract the domain name from the email
    $domain = substr(strrchr($email, "@"), 1);

    // 3. Known temporary/disposable email domains
    $disposable_domains = ['mailinator.com', '10minutemail.com', 'yopmail.com', 'sharklasers.com'];

    if (in_array(strtolower($domain), $disposable_domains, true)) {
        return false; // Blocked disposable email
    }

    // 4. Advanced Check: Verify the domain actually has a mail server setup
    return checkdnsrr($domain, "MX");
}

// Test instances
$emails = ["realuser@gmail.com", "scammer@mailinator.com", "fake@thisdomaindoesnotexist1234.com"];

foreach ($emails as $email) {
    echo $email . " -> " . (is_valid_email($email) ? "✅ Allowed" : "❌ Blocked") . "\n";
}
