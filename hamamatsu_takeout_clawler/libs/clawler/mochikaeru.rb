require_relative "./base"

module HamamatsuTakeout
  module Clawler
    class Mochikaeru < Base
      def scrape_shops
        html_documents.map do |html_document|
          pp html_document
          html_document.css(".row > div.flex.page-3").each_with_object([]) do |node, array|
            title_node = node.css(".v-card.v-sheet > a")
            # desc_node = node.css(".phrase.phrase-secondary")
  
            array.push(
              {
                name: title_node.text,
                url: title_node.attribute("href").value,
                # description: desc_node.text.gsub(/\r|\n|\s*/, '')
              }
            )
          end
        end.flatten
      end

      def base_url
        @base_url ||= "https://www.mochikaeru.com/shops"
      end

      def pages
        []   
      end
    end
  end
end


