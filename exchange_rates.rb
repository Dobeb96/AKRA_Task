require 'json'
require 'net/http'

EXCHANGE_API_URL = 'https://api.exchangeratesapi.io/latest'
class ExchangeRates
  def initialize
    uri = URI(EXCHANGE_API_URL)
    json_api = Net::HTTP.get(uri)
    @api = JSON.parse(json_api)
  end

  private
  def print_all_currencies

  end

  def print_extremum_rates

  end

  def save_to_file

  end
end

ExchangeRates.new
