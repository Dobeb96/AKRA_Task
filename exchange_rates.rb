require 'json'
require 'net/http'

EXCHANGE_API_URL = 'https://api.exchangeratesapi.io/latest'
class ExchangeRates
  def initialize
    uri = URI(EXCHANGE_API_URL)
    json_api = Net::HTTP.get(uri)
    @api = JSON.parse(json_api)

    print_all_currencies(order: :desc)
  end

  private

  # OPTIONS: order: [:asc / :desc]
  def print_all_currencies(options)
    sorting = options[:order]

    sorted_rates = @api['rates'].map {|k, _| k }.sort
    sorted_rates.reverse! if sorting == :desc

    puts 'Comma separated list of currencies:'
    puts sorted_rates.join(', ')
  end

  def print_extremum_rates

  end

  def save_to_file

  end
end

ExchangeRates.new
