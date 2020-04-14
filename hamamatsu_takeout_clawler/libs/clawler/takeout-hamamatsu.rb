require_relative "./base"

module HamamatsuTakeout
  module Clawler
    class TakeoutHamamatsu < Base
      def scrape_shops
        html_documents.map do |html_document|
          html_document.css(".item.top-item").each_with_object([]) do |node, array|
            title_node = node.css(".item-title > a")
            desc_node = node.css(".item-text")
  
            array.push(
              {
                name: parse_title(title_node),
                url: title_node.attribute("href").value,
                description: desc_node.text.gsub(/\r|\n|\s*/, ''),
                site: base_url
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


