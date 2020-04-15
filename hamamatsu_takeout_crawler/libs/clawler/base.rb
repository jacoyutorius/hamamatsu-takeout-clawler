require "nokogiri"
require 'open-uri'
require 'uri'

module HamamatsuTakeout
  module Clawler
    class Base
      def self.run!
        instance = self.new
        shop_urls = instance.scrape_shops
        shop_urls.map do |page|
          instance.scrape_details(page)
        end
      end

      def scrape_details(page)
        raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
      end

      def scrape_shops
        raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
      end

      def base_url
        raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
      end

      private

      def html_documents
        return [html_document(base_url)] if pages.empty?

        pages.map do |page|
          html_document(URI.join(base_url, page))
        end
      end

      def html_document(url)
        charset = nil

        html = open(url) do |f| 
          charset = f.charset
          f.read
        end

        Nokogiri::HTML.parse(html, nil, charset)
      end

      def pages
        []
      end
    end
  end
end