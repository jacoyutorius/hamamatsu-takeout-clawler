require 'json'
require "./libs/models/takeoutable-shop"
require "logger"

$logger = Logger.new(STDOUT)

def lambda_handler(event:, context:)
  shop_data = ::HamamatsuTakeout::Models::TakeoutableShop.scan
  data = shop_data.map do |row|
    {
      name: row.name,
      site: row.site,
      url: row.url,
      map_url: row.map_url,
      address: row.address,
      phone: row.phone,
      description: row.description,
      updated_at: row.updated_at
    }
  end

  {
    statusCode: 200,
    body: {
      data: data
    }.to_json
  }
end

# puts lambda_handler(event: nil, context: nil)
