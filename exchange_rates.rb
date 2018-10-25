require 'json'
require 'net/http'
require 'digest'

class ExchangeRates
  EXCHANGE_API_URL = 'https://api.exchangeratesapi.io/latest'

  def initialize
    uri = URI(EXCHANGE_API_URL)
    @api_json = Net::HTTP.get(uri)
    @api = JSON.parse(@api_json)
  end

  # The default ordering without any arguments is ascending
  # POSSIBLE OPTIONS: ( order: [:asc|:desc] )
  def currencies(options = {})
    sorting = options[:order]
    sorted_currencies = @api['rates'].map {|k, _| k}.sort
    sorted_currencies.reverse! if sorting == :desc
    sorted_currencies
  end

  def maximum_rate
    sorted_rates.last
  end

  def minimum_rate
    sorted_rates.first
  end

  def save_to_file
    data_hash = Digest::MD5.hexdigest(@api_json)
    File.write("#{data_hash}.json", @api_json)
  end

  private

  def sorted_rates
    @api['rates'].sort_by {|_, v| v}
  end
end

exchange_rates = ExchangeRates.new

puts "Comma separated list of currencies:"
puts exchange_rates.currencies(order: :desc).join(', ')
puts "Highest rate %s, lowest rate %s" % [exchange_rates.maximum_rate.join(': '), exchange_rates.minimum_rate.join(': ')]
exchange_rates.save_to_file && puts('Saved to file!')
