require_relative "./base"

module HamamatsuTakeout
  module Clawler
    class TakeoutHamamatsu < Base
      def scrape_details page
        address_node = page[:document].css(".single-contents > p > a")[0]
        phone_node = page[:document].css(".single-contents > p > a")[1]
        description = page[:document].css(".single-contents > p").map(&:text).reject(&:empty?)

        {
          name: page[:name],
          url: page[:url],
          site: page[:site],
          address: address_node.text,
          map_url: address_node.attribute("href").value,
          phone: phone_node.text,
          description: description
        }
      end

      def scrape_shops
        html_documents.map do |html_document|
          html_document.css(".item.top-item").each_with_object([]) do |node, array|
            title_node = node.css(".item-title > a")
            desc_node = node.css(".item-text")
            detail_url = title_node.attribute("href").value
  
            array.push(
              {
                name: parse_title(title_node),
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
        @base_url ||= "https://take-out-hamamatsu.com/"
      end

      private

      def parse_title(node)
        text = node.text
        text.gsub(/（浜松市）|のテイクアウト/, '')
      end

      def pages
        (1..3).map{|i| "page/#{i}" }    
      end
    end
  end
end

# puts ::HamamatsuTakeout::Clawler::TakeoutHamamatsu.run! 

