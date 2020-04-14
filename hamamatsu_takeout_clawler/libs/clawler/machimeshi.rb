require_relative "./base"

module HamamatsuTakeout
  module Clawler
    class Machimeshi < Base
      def scrape_shops
        html_documents.map do |html_document|
          html_document.css(".archive__contents").each_with_object([]) do |node, array|
            title_node = node.css(".heading.heading-secondary > a")
            desc_node = node.css(".phrase.phrase-secondary")
  
            array.push(
              {
                name: title_node.text,
                url: title_node.attribute("href").value,
                description: desc_node.text.gsub(/\r|\n|\s*/, ''),
                site: base_url
              }
            )
          end
        end.flatten
      end

      def base_url
        @base_url ||= "https://machimeshi.net/category/take-out/"
      end

      def pages
        (1..3).map{|i| "page/#{i}" }     
      end
    end
  end
end


