require 'nokogiri'
require 'open-uri'
require 'cgi'

module Scraper
  BASE_URL = 'https://www.ultimate-guitar.com/search.php'

  def get_page(page_url)
    Nokogiri::HTML( open(page_url, 'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.854.0 Safari/535.2') )
  end
end

class Search
  include Scraper

  def initialize(query, page)
    @query_string = CGI::escape(query)
    page_url = "#{BASE_URL}?search_type=title&value=#{@query_string}&page=#{page}"
    @output = self.get_page(page_url)
  end

  def results
    @output.search("#npd77").remove
    rows = @output.css('.tresults').css('tr').drop(1)
    rows.map! { |row| Result.new(row) }
    add_artist!(rows)
    reject_fake_tabs!(rows)
  end

  def page_links
    page_anchors = @output.css('.paging').css('b, a')

    page_anchors.map do |p|
      if p.name == 'a'
        page_number = p[:href].match(/&page=\d*/).to_s
        p[:href] = "/results?query=#{@query_string}#{page_number}"
      end

      if p.text.match /(next|prev)/i
        p.text.strip
        p.children.css('img').remove
      end
    end
    page_anchors
  end

  private

  def add_artist!(rows)
    # This hack makes up for many of the artist cells being blank on
    # UG's search results (since UG groups the results by artist)
    artist_name = ''
    rows.each do |r|
      r.artist == "\u00A0" ? r.artist = artist_name : artist_name = r.artist
    end

    return self
  end

  def reject_fake_tabs!(rows)
    rows.reject! {|r| r.item_type.match /(pro|power|video)/i}
  end
end

class Result
  attr_accessor :artist, :item_type

  def initialize(row)
    @row = row
    @artist = @row.css('td')[0].text.strip
    # Chords or tab
    @item_type = @row.css('td')[3].text.strip
  end

  def title
    title = @row.css('td')[1].css('a').first
    { text: title.text, href: title[:href] }
  end

end

class Tab
  include Scraper

  def initialize(tab_url)
    @output = self.get_page(tab_url)
  end

  def content
    @output.css('#cont').css('pre')[1].to_s
  end
end
