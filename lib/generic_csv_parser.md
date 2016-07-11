```ruby
puts "...EventManager initialized..."
puts

contents = File.read("event_attendees.csv")
puts contents

File.exist? "event_attendees.csv" # returns true
```

```ruby
lines = File.readlines("event_attendees.csv") #read the entire contents of a file as an array of lines
lines.each do |line|  #iterate over entire collection (array) of lines
  puts line #print the contents of each line
end
```


The first line printed contains the header information.
This row provides descriptional text for each column of data.
It is read from left to right.


Currently have a string of text that represents the entire row.
Rows like this are not very readable.
Need to convey the string into an array of columns
Use string.split(",") to separate the string into columns

```ruby
lines = File.readlines"event_attendees.csv"
lines.each do |line|
  columns = line.split(",")
  puts columns
end
```

Within our array of columns we want to access our 'first_Name'
This would be the third column ie, the array's second element `columns[2]`

```ruby
lines = File.readlines "event_attendees.csv"
lines.each do |line|
  columns = line.split(",")
  name = columns[2] #search for entries under names
  puts name
end
```

The header row is useful for understanding what attribute its respective
 column of values point to but does not itself represent an actual attendee
We have the option of deleting the header row but that would make
 archiving difficult.
Another option is to ignore the first row when we display the names: to
 skip the line when it exactly matches our current header

```ruby
lines = File.readlines "event_attendees.csv"
lines.each do |line|
  #below line will ignore an iteration containing that exact string
  next if line == " ,RegDate,first_Name,last_Name,Email_Address,HomePhone,Street,City,State,Zipcode\n"
  columns = line.split(",")
  name = columns[2]
  puts name
end
```

A problem with this solution is that the cotnent of our header row
 can change in the future. Or even additional columns could be added
 and existing ones updated.
 We could instead, specify the index of our lines and then ignore the first

```ruby
lines = File.readlines "event_attendees.csv"
row_index = 0 #an abstract variable that acts as a counter for "rows"
lines.each do |line|
  row_index = row_index + 1 #every line is indexed
  next if row_index == 1 #the first iteration and therefore line is ignored
  columns = line.split(".")
  name = columns[2]
  puts name
end
```

This is such a COMMON OPERATION in arrays that we use Array#eachwithindex:

```ruby
lines = File.readlines "event_attendees.csv"
lines.each_with_index do |line, index| #each iteration is indexed
  next if index == 0 #the iterations start from 0 which is the first row
  columns = line.split(",")
  name = columns[2]
  puts name
end
```

This CSV parser we have created may run into problems when the CSV file
 is generated or manipulated by another source.
Other features we have not considered:
 - that CSV files often contain comment lines (starting with #)
 - columns are unable to support a value which contain a comma chararacter
