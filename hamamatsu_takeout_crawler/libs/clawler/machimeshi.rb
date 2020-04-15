require_relative "./base"

module HamamatsuTakeout
  module Clawler
    class Machimeshi < Base
      def scrape_details(page)
        address_node = page[:document].css(".postContents > section.content > p")[0]
        map_node = page[:document].css(".postContents > section.content > p > a")[0]
        phone_node = page[:document].css(".postContents > section.content > p > a")[1]
        description = page[:document].css(".postContents > section.content").map(&:text).join.split("\n").reject(&:empty?)

        {
          name: page[:name],
          url: page[:url],
          site: page[:site],
          address: address_node.text,
          map_url: map_node.attribute("href").value,
          phone: phone_node.text,
          description: description
        }
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

      def pages
        (1..3).map{|i| "page/#{i}" }     
      end
    end
  end
end

# puts ::HamamatsuTakeout::Clawler::Machimeshi.run!
