require_relative "./base"

module HamamatsuTakeout
  module Clawler
    class TakeoutHamamatsu < Base
      def scrape_details page
        address_node = page[:document].css(".single-contents > p > a")[0]
        phone_node = page[:document].css(".single-contents > p > a")[1]
        description = format_description(page[:document].css(".single-contents > p"))

        {
          name: page[:name],
          url: page[:url],
          site: page[:site],
          address: format_address(address_node),
          map_url: address_node.attribute("href").value,
          phone: phone_node&.text,
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

      def format_address(address_node)
        text = address_node.text
        prefix = text.start_with?("浜松市") ? "静岡県" : ""
        "#{prefix}#{text}"
      end

      def format_description(description_node)
        desc = description_node.map(&:text).reject(&:empty?)

        # 最初の要素がblank, 2番目の要素が店名なので削除
        desc.shift(2)
        desc
      end

      def pages
        (1..page_max).map{|i| "page/#{i}" }
      end
    end
  end
end

# puts ::HamamatsuTakeout::Clawler::TakeoutHamamatsu.run!

