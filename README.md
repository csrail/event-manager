##Learning Goals
* manipulate file input and output
* read content from a CSV (comma separated value) file
* transform CSV into a standardized format
* utilize data to contact a remote service
* populate a template with user data
* manipulate strings
* access Sunlight's Congressional API through Sunlight Congress gem
* use ERB for templating

Scenario:
Your friend runs a non-profit org around political activism.
A number of people have registered for an upcoming event.
You have been asked to help engage these future attendees.

A CSV file stores tabular data (numbers and text) in plain-text form. The CSV format is readable by a large number of applications thereby making it a popular option for portability.

Trying to define our own templating language has drawbacks.
Using FIRST_NAME and LEGISLATORS to find and replace might occur if the text
appears in any of our tempaltes. This code is not exemplary, we are inviting disaster to occur.

Ruby has a template language called ERB.
ERB is Ruby code that can be added to any plain text document for the purposes of generating document information details and/or flow control.

Defining an ERB template is extremely similar to our existing template.
The only difference is we are using escape sequence tags that allow us to insert any variables, methods or ruby code we want to execute.
The most common sequence tags we use are:
 - <%= ruby code to sexcute and show output %>
 - <% ruby code will execute but not show output %>
 
 ```ruby
 require 'erb'

meaning_of_life = 42

question = "The Answer to the Ultimate Question of Life, the Universe, and Everything is <%= meaning_of_life %>"
template = ERB.new question

results = template.result(binding)
puts results
```

The above code loads the ERB library.
We create a new ERB template with the `question` string. The question string contains ERB tags that will show the results of the variable meaning_of_life. We send the `result` message to the template with `binding`

The method [binding](http://www.rubydoc.info/stdlib/core/Kernel#binding-instance_method) returns a special object.
This object is an instance of [Binding](http://www.rubydoc.info/stdlib/core/Binding). 
A instance of binding knows all about the current state of variables and methods within the given scope. In this case, `binding` here knows about the variable `meaning_of_life`.
Using the keyword `binding` acts as a duck type, giving flexibility to the template as the results will be different depending on how the binding was defined.

Now that we are using ERB, our form_letter.html needs to be updated.


The first use of ERB tags is quite simple: <%= name%>

The second, used to display legislators is quite different.
We are using the ERB tag that does not output the results to define
the beginning of the block and also the end of the block:

beginning of block:
<% legislators.each do |legislator| %>

end of block:
<% end %>

We then also output the results within the block using <%= %>