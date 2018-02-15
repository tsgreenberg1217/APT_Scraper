require 'Nokogiri'
require 'open-uri'
require 'HTTParty'
require 'Pry'
require 'JSON'
require 'csv'


page = HTTParty.get('https://miami.craigslist.org/search/apa?min_bedrooms=3&max_bedrooms=2&availabilityMode=0&sale_date=all+dates')
parsed_page = Nokogiri::HTML(page)

# for names
names = parsed_page.css('.result-row').css('.result-info').css('.result-title').css('.hdrlnk').map{|x| x.text}
# for links
links = parsed_page.css('.content').css('.rows').css('.result-row').css('.result-info a').map{|l| l['href'] if l['href'].length>1}.reject{|w| w == nil}

listings = Hash.new
names.length.times do |i|
  listings[i+1] = {'name' => names[i], 'link' => links[i]}
end

CSV.open("data.csv", "wb") {|csv| listings.to_a.each {|elem| csv << elem} }

# Pry.start(binding)
