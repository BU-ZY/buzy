require 'rubygems'
require 'open-uri'
require 'nokogiri'

PAGE_URL = "http://www.bu.edu/eng/current-students/ingalls/status/output.html"

page = Nokogiri::HTML(open(PAGE_URL))
#data = page.search('div#results')
data = page.css("strong")

# Only using people in room to determine busyness for now
people = data[0].text.to_i

def isBusy(people)
	if people > 100
		return 100
	else
		return people
	end
end

puts isBusy(people)

#puts "Ingalls is currently "+isBusy(people)+"\n"
