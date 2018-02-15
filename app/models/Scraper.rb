require 'Nokogiri'
require 'open-uri'
require 'HTTParty'
require 'Pry'
require 'JSON'
require 'csv'

class APTScraper
  def initialize(city)
    @page = HTTParty.get("https://#{city}.craigslist.org/search/apa?min_bedrooms=3&max_bedrooms=2&availabilityMode=0&sale_date=all+dates")
    @parsed_page = Nokogiri::HTML(@page)
  end

  def get_listingsCSV
    names = @parsed_page.css('.result-row').css('.result-info').css('.result-title').css('.hdrlnk').map{|x| x.text}
    links = @parsed_page.css('.content').css('.rows').css('.result-row').css('.result-info a').map{|l| l['href'] if l['href'].length>1}.reject{|w| w == nil}
      CSV.open("listings.csv", "wb") do |csv|
        csv << ['entry', 'listing', 'url']
        names.length.times do |i|
          csv << [i+1,names[i],links[i]]
        end
      end
  end
end
s = APTScraper.new('miami')
s.get_listingsCSV

# Pry.start(binding)
