require_relative "./base"
require "nkf"

module HamamatsuTakeout
  module Clawler
    class Machimeshi < Base
      def scrape_details(page)
        address_node = page[:document].css(".postContents > section.content > p")[0]
        address = format_address(address_node)
        return nil if address.nil?

        map_node = page[:document].css(".postContents > section.content > p > a")[0]
        phone_node = page[:document].css(".postContents > section.content > p > a")[1]
        description = format_description(page[:document].css(".postContents > section.content"))
        geocode = fetch_geocode(address)

        {
          name: page[:name],
          url: page[:url],
          site: page[:site],
          address: address,
          map_url: format_map_address(map_node),
          phone: phone_node&.text,
          description: description,
          latitude: geocode[0],
          longitude: geocode[1]
        }
       rescue => error
        p "#{page} #{error}"
        nil
      end

      def scrape_shops
        html_documents.map do |html_document|
          html_document.css(".archive__contents").each_with_object([]) do |node, array|
            title_node = node.css(".heading.heading-secondary > a")
            desc_node = node.css(".phrase.phrase-secondary")
            detail_url = title_node.attribute("href").value
  
            array.push(
              {
                name: title_node.text,
                url: detail_url,
                description: desc_node.text.gsub(/\r|\n|\s*/, ''),
                site: base_url,
                document: html_document(detail_url)
              }
            )
          end
        end.flatten
      end

      def base_url
        @base_url ||= "https://machimeshi.net/category/take-out/"
      end

      private

      def format_address(address_node)
        text = address_node.text
        text&.gsub!('【Googleマップを開く】', '')
            &.gsub!(/〒\d{3}-\d{4}/, "")
            &.tr('０-９ａ-ｚＡ-Ｚ','0-9a-zA-Z') 
            &.strip
      rescue => ex
        p "#format_address: #{ex.message}"
        ''
      end

      def format_description(description_node)
        description_node.map do |node|
          node.text.gsub(/(\r|\t)/, "")     
        end.join.split("\n").reject(&:empty?)
      end

      def format_map_address(map_node)
        map_node.attribute("href").value
      rescue => ex
        p "#format_map_address: #{ex.message}"
        ''
      end

      def pages
        (1..page_max).map{|i| "page/#{i}" }
      end
    end
  end
end

if __FILE__ == $0
  puts ::HamamatsuTakeout::Clawler::Machimeshi.run!(page_max: 1)
end
