require 'json'
require "./libs/clawler/machimeshi"
require "./libs/clawler/takeout-hamamatsu" 
require "./libs/models/takeoutable-shop"
require "logger"

$logger = Logger.new(STDOUT)

def lambda_handler(event:, context:)
  update(shop_data)
end

def update(shop_data)
  shop_data.each do |row|
    record = ::HamamatsuTakeout::Models::TakeoutableShop.find(name: row[:name], site: row[:site])
    record ||= ::HamamatsuTakeout::Models::TakeoutableShop.new

    record.name = row[:name]
    record.site = row[:site]
    record.url = row[:url]
    record.map_url = row[:map_url]
    record.address = row[:address]
    record.phone = row[:phone]
    record.description = row[:description]
    record.latitude = row[:latitude]
    record.longitude = row[:longitude]
    record.updated_at = Time.now
    result = record.save
    
    sleep 0.3
    $logger.info("#{row[:name]}, #{row[:site]}")
  end
end

private

def shop_data
  # @shop_data ||= [].concat(takeout_hamamatsu, machimeshi)
  @shop_data ||= [].concat(takeout_hamamatsu)
end

def machimeshi
  ::HamamatsuTakeout::Clawler::Machimeshi.run!
end

def takeout_hamamatsu
  ::HamamatsuTakeout::Clawler::TakeoutHamamatsu.run!
end

lambda_handler(event: nil, context: nil)
