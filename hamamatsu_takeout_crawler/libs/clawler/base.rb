require "nokogiri"
require 'open-uri'
require 'uri'

module HamamatsuTakeout
  module Clawler
    class Base
      attr_accessor :page_max

      def initialize(params)
        @page_max = params.fetch(:page_max, 10)
      end

      def self.run!(params={})
        instance = self.new(params)
        shop_urls = instance.scrape_shops
        shop_urls.map do |page|
          # p "name: #{page[:name]}"
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
        end.compact
      end

      def html_document(url)
        charset = nil

        html = open(url) do |f| 
          charset = f.charset
          f.read
        end

        Nokogiri::HTML.parse(html, nil, charset)
      rescue => exception
        p "#{url}: #{exception.message}"
        nil
      end

      def pages
        []
      end
    end
  end
end