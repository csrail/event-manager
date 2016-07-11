#The sunlight-congress gem is a wrapper library. Its job is to hide complexity
# from us. It acts as a regular Ruby object, then the library takes care of
# fetching and parsing data from the server.

#What the parser with the CSV gem looks like
=begin
require 'csv'

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, "0")[0..4]
end

puts "...Event Manager initialized...",
     ""
     
contents = CSV.open("../event_attendees.csv", headers: true, header_converters: :symbol)

contents.each do |row|
  name = row[:first_name]
  
  zipcode = clean_zipcode(row[:zipcode])
  
  puts "#{name} #{zipcode}"
end
=end

=begin
require 'csv'
require 'sunlight/congress'

Sunlight::Congress.api_key = "e179a6973728c4dd3fb1204283aaccb5"

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, "0")[0..4]
end

puts "...Event Manager initialized...",
     ""
     
contents = CSV.open 'event_attendees.csv', headers: true, header_converters: :symbol

contents.each do |row|
  name = row[:first_name]
  
  zipcode = clean_zipcode(row[:zipcode])
  
  legislators = Sunlight::Congress::Legislator.by_zipcode(zipcode)
  
  puts "#{name} #{zipcode} #{legislators}"
end
=end

#The **legislators** we are displaying is an array; the array is sending the
# `to_s` message to each of the objects within the array - each legislator.
# The output results in a raw legislator object - that's a lot of info;
# all we want is the first and last name of each legislator

#Collecting the Names of the Legislators:
#To print only the first and last names of the legislators we would need to
# iterate over the entire collection of legislators for the parricular zipcode
# and for each legislator we want to create a new string which is composed of
# their first name and last name; finally we want to add the name to a
# collection of names.

=begin
require 'csv'
require 'sunlight/congress'

Sunlight::Congress.api_key = "e179a6973728c4dd3fb1204283aaccb5"

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, "0")[0..4]
end

puts "...Event Manager initialized...",
     ""
     
contents = CSV.open 'event_attendees.csv', headers: true, header_converters: :symbol

contents.each do |row|
  name = row[:first_name]
  
  zipcode = clean_zipcode(row[:zipcode])
  
  legislators = Sunlight::Congress::Legislator.by_zipcode(zipcode)
  
  legislator_names = legislators.collect do |legislator|
    "#{legislator.first_name} #{legislator.last_name}"
  end
    
  puts "#{name} #{zipcode} #{legislator_names}"
end
=end

#We are priting an array within the string but instead we want only the
# contents of the array. We have to use the Array#join method. When we join'
# the legislator names, we want to join them with a comma and a space.

=begin
require 'csv'
require 'sunlight/congress'

Sunlight::Congress.api_key = "e179a6973728c4dd3fb1204283aaccb5"

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, "0")[0..4]
end

puts "...Event Manager initialized...",
     ""
     
contents = CSV.open 'event_attendees.csv', headers: true, header_converters: :symbol

contents.each do |row|
  name = row[:first_name]
  
  zipcode = clean_zipcode(row[:zipcode])
  
  legislators = Sunlight::Congress::Legislator.by_zipcode(zipcode)
  
  legislator_names = legislators.collect do |legislator|
    "#{legislator.first_name} #{legislator.last_name}"
  end
  
  legislators_string = legislator_names.join(", ")
  
  puts "#{name} #{zipcode} #{legislators_string}"
end
=end

#The display legislators code looks very cumbersome; we can refactor it
# by identifying what the code is trying to express.
#We should refactor the extraction of legislation names into a new methdd
# named `legislators_by_zipcode`

=begin
require 'csv'
require 'sunlight/congress'

Sunlight::Congress.api_key = "e179a6973728c4dd3fb1204283aaccb5"

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, "0")[0..4]
end

def legislators_by_zipcode(zipcode)
  legislators = Sunlight::Congress::Legislator.by_zipcode(zipcode)
  
  legislator_names = legislators.collect do |legislator|
    "#{legislator.first_name} #{legislator.last_name}"
  end
  
  legislator_names.join(", ")
end

puts "...Event Manager initialized..."

contents = CSV.open 'event_attendees.csv', headers: true, header_converters: :symbol

contents. each do |row|
  name = row[:first_name]
  
  zipcode = clean_zipcode(row[:zipcode])
  
  legislator = legislators_by_zipcode(zipcode)
  
  puts "#{name} #{zipcode} #{legislator}"
end
=end

#this type of implementation is important later on not only for encapsulating
# our method, but also a benefit later if we decide to use an alternative
# gem or introduce a level of caching to prevent look ups for similar zipcodes

=begin
require 'csv'
require 'sunlight/congress'

Sunlight::Congress.api_key = Sunlight::Congress.api_key = "e179a6973728c4dd3fb1204283aaccb5"

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, "0")[0..4]
end

def legislators_by_zipcode(zipcode)
  legislators = Sunlight::Congress::Legislator.by_zipcode(zipcode)
  
  legislator_names = legislators.collect do |legislator|
    "#{legislator.first_name} #{legislator.last_name}"
  end
  
  legislator_names.join(", ")
end

puts "...Event Manager initialized..."

contents = CSV.open 'event_attendees.csv', headers: true, header_converters: :symbol

template_letter = File.read "form_letter.html"

contents. each do |row|
  name = row[:first_name]
  
  zipcode = clean_zipcode(row[:zipcode])
  
  legislator = legislators_by_zipcode(zipcode)
  
  puts "#{name} #{zipcode} #{legislator}"
end
=end

#So we have loaded our form_letter.html inside and now we need to replace
# the CONSTANTS with their respective values:
#We need to find all instances of FIRST_NAME and replace them with the
# individuals's first name
#We need to find all the instaces of LEGISLATORS and replace them with the
#indvidual's representatives.

#Two methods are available to us:
#gsub vs gsub! which are different by one aspect.
#gsub creates a new copy of the original string with the values replaced
#gsub! will replace the values in the original string

#Our template letter needs to create a new letter for every attendee.
# If we change the original template we would have all the same name!
# A safe measure is to make a copy and then change the copy.

=begin
require `csv`
require `sunlight/congress`

Sunlight::Congress.api_key = "e179a6973728c4dd3fb1204283aaccb5"

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, "0")[0..4]
end

def legislators_by_zipcode(zipcode)
  legislators = Sunlight::Congress::Legislator.by_zipcode(zipcode)
  
  legislator_names = legislators.collect do |legislator|
    "#{legislator.first_name} #{legislator.last_name}"
  end
  
  legislator_names.join(", ")
end

puts "...Events Manager initialized...",
     ""
     
contents = CSV.open 'event_attendees.csv', headers: true, header_converters: :symbol

template_letter = File.read "form_letter.html"

contents. each do |row|
  name = row[:first_name]
  
  zipcode = clean_zipcode(row[:zipcode])
  
  legislator = legislators_by_zipcode(zipcode)
  
  personal_letter = template_letter.gsub('FIRST_NAME', name)
  personal_letter.gsub!('LEGISLATORS', legislators)
end
=end

#Trying to define our own templating language has drawbacks.
#Using FIRST_NAME and LEGISLATORS to find and replace might occur if the text
# appears in any of our tempaltes. This code is not exemplary, we are
# inviting disaster to occur.

#Ruby has a template language called ERB.
#ERB is Ruby code that can be added to any plain text document for the purposes
# of generating document information details and/or flow control.

#Defining an ERB template is extremely similar to our existing template.
#The only difference is we are using escape sequence tags that allow us to
# insert any variables, methods or ruby code we want to execute.
#The most common sequence tags we use are:
# <%= ruby code to sexcute and show output %>
# <% ruby code will execute but not show output %>

#We need to update our application to use ERB:
#Require the ERB library
#Create the ERB template from the contents of the template file
#Simplify our `legislators_by_zipcode` to return the original array of
# legislators

=begin
require 'csv'
require 'sunlight/congress'
require 'erb'

Sunlight::Congress.api_key = "e179a6973728c4dd3fb1204283aaccb5"

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, "0")[0..4]
end

def legislators_by_zipcode(zipcode)
  Sunlight::Congress::Legislator.by_zipcode(zipcode)
  #no longer stored in the variable name legislators
end

puts "...Event Manager initialized...",
     ""
     
contents = CSV.open 'event_attendees.csv', headers: true, header_converters: :symbol

template_letter = File.read "form_letter.erb"
erb_template = ERB.new template_letter

contents.each do |row|
  name = row[:first_name]
  
  zipcode = clean_zipcode(row[:zipcode])
  
  legislators = legislators_by_zipcode(zipcode)
  #legislators variable name changed from legislator (now includes s)
  
  form_letter = erb_template.result(binding)
  puts form_letter
end
=end

#We can run our ruby script which prints the erb file out onto the screen
# for us to double check and qualify. Now it is time to save each form
# letter to a file.

#Each file should be uniquely named - that is they should have a unique key
# pointing towards a separate attendee. We achieve this by identifying a
# unique id, first column or row number
#We will assign an ID for the attendee, create an output folder and save
#each form letter to a file based on the id of the attendee.

=begin
require 'csv'
require 'sunlight/congress'
require 'erb'

Sunlight::Congress.api_key = "e179a6973728c4dd3fb1204283aaccb5"

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, "0")[0..4]
end

def legislators_by_zipcode(zipcode)
  Sunlight::Congress::Legislator.by_zipcode(zipcode)
end

puts "...Event Manager initialized...",
     ""
     
contents = CSV.open 'event_attendees.csv', headers: true, header_converters: :symbol

template_letter = File.read "form_letter.erb"
erb_template = ERB.new template_letter

contents.each do |row|
  id = row[0] #assign ID to attendee
  name = row[:first_name]
  
  zipcode = clean_zipcode(row[:zipcode])
  
  legislators = legislators_by_zipcode(zipcode)
  
  form_letter = erb_template.result(binding)
  
  Dir.mkdir("output") unless Dir.exists? "output"
  #create a directory named "output" unless directory already exists
  
  filename = "output/thanks_#{id}.html"
  #save each form letter to file based on the id of the attendee
  
  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
    
end
=end

#File.open allows us to open a file for reading and writing.
#The first parameter is the name of the file.
#The second parameter is a flag that states how we want to open the file.
# The 'w' states that we want to poen the file for writing.
# If the file already exists IT WILL BE DESTROYED.

#Afterwards we send the entire form letter content to the file object.
# The `file` object respods to the message `puts`. The file.puts is similar
# to the Kernel.puts that we have been using.


#Now to write clarn code, we can move the operation of generating
# and saving form letters into its own method.

require 'csv'
require 'sunlight/congress'
require 'erb'

Sunlight::Congress.api_key = "e179a6973728c4dd3fb1204283aaccb5"

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, "0")[0..4]
end

def legislators_by_zipcode(zipcode)
  Sunlight::Congress::Legislator.by_zipcode(zipcode)
end

def save_thank_you_letters(id, form_letter)
  Dir.mkdir("output") unless Dir.exists?("output")
  
  filename = "output/thanks_#{id}.html"
  
  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

puts "...Event Manager initialized..."
     ""
     
contents = CSV.open 'event_attendees.csv', headers:true, header_converters: :symbol

template_letter = File.read "form_letter.erb"
erb_template = ERB.new template_letter

contents.each do |row|
  id = row[0]
  name = row[:first_name]
  zipcode = clean_zipcode(row[:zipcode])
  legislators = legislators_by_zipcode(zipcode)
  
  form_letter = erb_template.result(binding)
  
  save_thank_you_letters(id, form_letter)
end