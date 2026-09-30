require 'securerandom'

def generate_secure_password(length = 16)
  # Define character sets
  sets = [
    ('a'..'z').to_a,
    ('A'..'Z').to_a,
    ('0'..'9').to_a,
    ['!', '@', '#', '$', '%', '^', '&', '*', '_', '-']
  ]
  
  # Ensure at least one character from each set is included
  password = sets.map(&:sample)
  
  # Fill the rest of the length with completely random characters
  all_chars = sets.flatten
  (length - password.size).times { password << all_chars.sample }
  
  # Shuffle the array so the guaranteed characters aren't always at the start
  password.shuffle.join
end

puts "Your secure password: #{generate_secure_password(20)}"
# Output example: Your secure password: xG7!m9-QzA_pL2$vK8*w
