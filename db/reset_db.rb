# This script will drop, create, and migrate the database.
puts "Dropping the database..."
system("rails db:drop")

puts "Creating a new database..."
system("rails db:create")

puts "Running migrations..."
system("rails db:migrate")

puts "Database has been reset successfully."
