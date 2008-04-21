#!/usr/bin/env ruby
require 'rubygems'
require 'hpricot'
require 'activesupport'
require 'rss/maker'
require 'net/http'
require 'rack'

class HackerNews
  def call(env)
    blog = Hpricot.parse(Net::HTTP.get(URI.parse('http://news.ycombinator.com')))
    main_table = (blog / 'td').find {|td| td.attributes['class'] == 'title' }.parent.parent
    
    feed = RSS::Maker.make('1.0') do |rss|
      rss.channel.about         = "Hacker News"
      rss.channel.title         = "Hacker News"
      rss.channel.description   = "Hacker News"
      rss.channel.link          = "http://news.ycombinator.com"
      (main_table / 'tr td.title a').each do |link|
        next if link.attributes['rel'] == 'nofollow'
        item              = rss.items.new_item
        item.author       = (link.parent.parent.next_sibling / 'td a').first.inner_text
        comments_link     = (link.parent.parent.next_sibling / 'td a').last.attributes['href']
        comments_number   = (link.parent.parent.next_sibling / 'td a').last.inner_text.split.first
        item.title        = link.inner_text
        item.link         = link.attributes['href'] =~ /^http/ ? link.attributes['href'] : "http://news.ycombinator.com/#{link.attributes['href']}"
        article_cache     = File.join(File.dirname(__FILE__), 'cache', item.link.gsub(/:|\/|=|&|\[|\]|\?/, '_'))
        if File.exist?(article_cache)
          article = File.read(article_cache)
        else
          article = `links -dump #{item.link}`
          File.open(article_cache, 'w') {|f| f.write article }
        end
        item.description  = " <pre>#{article} </pre><p><a href='#{comments_link}'>#{comments_number} Comments</a></p>"
      end
    end.to_s

    [200, {"Content-Type"=>"text/xml"}, feed]
  end

end

Rack::Handler::Mongrel.run(HackerNews.new, {:Host => "127.0.0.1", :Port => 7025})
