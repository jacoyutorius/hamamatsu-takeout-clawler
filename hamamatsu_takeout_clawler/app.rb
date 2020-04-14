require 'json'
require "./libs/clawler/machimeshi"
require "./libs/clawler/takeout-hamamatsu"
require "./libs/clawler/mochikaeru"
require "./libs/models/takeoutable-shop"

def lambda_handler(event:, context:)
  data = []
  data.concat(takeout_hamamatsu, machimeshi)
  
  update(data)

  {
    statusCode: 200,
    body: {
      data: data
    }.to_json
  }
end

def update data
  data.each do |row|
    record = ::HamamatsuTakeout::Models::TakeoutableShop.find(name: row[:name], site: row[:site])
    
    if record
    else
      record = ::HamamatsuTakeout::Models::TakeoutableShop.new
      record.name = row[:name]
      record.site = row[:site]
      record.url = row[:url]
      record.description = row[:description]
      record.save
    end
    
    sleep 0.5
    puts record
  end
end

private

def machimeshi
  ::HamamatsuTakeout::Clawler::Machimeshi.new.scrape_shops
end

def takeout_hamamatsu
  ::HamamatsuTakeout::Clawler::TakeoutHamamatsu.new.scrape_shops
end

def mochikaeru
  ::HamamatsuTakeout::Clawler::Mochikaeru.new.scrape_shops
end

lambda_handler(event: nil, context: nil)