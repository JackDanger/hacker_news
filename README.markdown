h1. Hacker News

This is a scraper for http://news.ycombinator.com.  It shows just how little Ruby is required to run a powerful web filter.

What it does:

  * Fetches the YCombinator news page
  * HPricot's it into pieces
  * Builds an RSS feed
  * Uses `links` to parse the destination article page and include the main text inline
  * Runs as a stand-alone server thanks to Rack and Mongrel
