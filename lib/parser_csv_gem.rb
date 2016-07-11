#Libraries are not loaded every single time code is executed;
# this ensures that uneeded functionality is not loaded unless required,
# preventing Ruby from having slower start up times.

=begin
require "csv" #tells Ruby to load CSV library
puts "...Event Manager initialized...",
     ""

contents = CSV.open "event_attendees.csv", headers: true
#can also be written like:
#contents = CSV.open("event_attendees.csv", headers: true)
contents.each do |row|
  name = row[2]
  puts name
end
=end

#Instead of using `read` or `readlines` this csv gem uses the `open` method
# to load our file. The library also supports the concept of headers and so
# provides some additional paranmeters to fill in

#Accessing Columns by their Names:
#CSV files with headers have an additional option which allows you to access
# the column values by their headers
#The CSV library provides the option of converting the header names to symbols
# resulting in a hash configuration

=begin
require "csv"
puts "...Event Manager initialized..."
     ""
     
contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol
contents.each do |row|
 name = row[:first_name]
 puts name
end
=end

#Displaying the Zip Codes of All Attendees
# Accessing the zipcode is very easy using the header name;
# "Zipcode" becomes :zipcode

=begin
require "csv"
puts "...Event Manager initialized..."
     ""
     
contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol
contents.each do |row|
  name = row[:first_name]     
  zipcode = row[:zipcode]
  puts "#{name} #{zipcode}"
end
=end

#Problems
# Not all zip codes are showing.
# Not all zip codes are 5 digits long (some are shorter)

#Pseudocode for fixes
# if the zip code is exactly five digits, assume ok
# if the zip code is more than 5 digits, truncate it to first 5
# if zip code is less then 5 digits, PREPEND zeroes to make to 5

#Use String#length to return length of strings
#Use String#rjust to append zeroes to the front of the string.
#Use String#slice to create substrings or array-like notation

=begin
require "csv"
puts "...Event Manager initialized..."
     ""

contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol

contents. each do |row|
  name = row[:first_name]
  zipcode = row[:zipcode]
  
  if zipcode.length < 5 #will result in NilClass NoMethodError when coming across nil
    zipcode = zipcode.rjust 5, "0"
  elsif zipcode.length > 5
    zipcode = zipcode[0..4]
  end

  puts "#{name} #{zipcode}"
end
=end

#To account for the nil zipcode, we use the #nil? method.
#All objects in Ruby respond to #nil? All objects will return false except
# for a `nil`
#We update our implementation to handle this new case by simply adding
# a check for `nil?`

=begin
require "csv"
puts "...Event Manager initialized..."
     ""

contents = CSV.open("event_attendees.csv", headers: true, header_converters: :symbol)

contents.each do |row|
  name = row[:first_name]
  zipcode = row[:zipcode]
  
  if zipcode.nil?
    zipcode = "00000"
  elsif zipcode.length < 5
    zipcode = zipcode.rjust 5, "0"
  elsif zipcode.length > 5
    zipcode = zipcode[0..4]
  end
  
  puts "#{name} #{zipcode}"
end
=end

#Right now the parser is getting more difficult to read clearly;
# good code should almost read like pseudocode
#We can refactor our code to make it shorter; we can move the 
# conditionals affecting zipcode into a method

=begin
require 'csv'

def clean_zipcode(zipcode)
  if zipcode.nil?
    "00000"
  elsif zipcode.length < 5
    zipcode.rjust(5, "0")
  elsif zipcode.length > 5
    zipcode[0..4]
  else
    zipcode
  end
end

puts "...Event Manager initialized...",
     ""

contents = CSV.open("event_attendees.csv", headers: true, header_converters: :symbol)

contents.each do |row|
  name = row[:first_name]
  
  zipcode = clean_zipcode(row[:zipcode])
  
  puts "#{name} #{zipcode}"
end
=end

#"Coercion over Questions" is a theme that promotes refactoring
# Instead of trying to understand our environment, bend the environment
# towards you instead. In the clean_zipcode method, as a series,we can 
# identify that the combination of conditionals combined can be refactored
#`nil` presence can be seen with `.to_s`
#`row[:zipcode].rjust 5, "0"` will have the same effect regardless if the
# string was greater or less than 5 - so why not just do it isntead of
# asking questions?
#`row[:zipcode][0..4]` will retrieve the first five characters of a string
# which will include a zipcode with padded zeroes and a zipcode with more
# than 5 characters

=begin
require 'csv'

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, "0")[0..4]
end

puts "...Event Manager intialized...",
     ""
     
contents = CSV.open("event_attendees.csv", headers: true, header_converters: :symbol)

contents.each do |row|
  name = row[:first_name]
  
  zipcode = clean_zipcode(row[:zipcode])
  
  puts "#{name} #{zipcode}"
end
=end