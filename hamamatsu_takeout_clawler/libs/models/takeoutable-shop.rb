require "aws-record"

module HamamatsuTakeout
  module Models
    class TakeoutableShop
      include Aws::Record

      string_attr :name, hash_key: true
      string_attr :site, range_key: true
      string_attr :url
      string_attr :description

      set_table_name "TakeoutableShops"
    end
  end
end

# pp ::HamamatsuTakeout::Models::TakeoutableShop.scan.to_a