require 'json'
require 'net/http'
require 'digest'

EXCHANGE_API_URL = 'https://api.exchangeratesapi.io/latest'
class ExchangeRates
  def initialize
    uri = URI(EXCHANGE_API_URL)
    api_json = Net::HTTP.get(uri)
    @api = JSON.parse(api_json)

    print_all_currencies(order: :desc)
    print_extremum_rates
    save_to_file(api_json)
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
    sorted_rates = @api['rates'].sort_by {|_, v| v }
    puts "Highest rate #{sorted_rates.last.join(': ')}, lowest rate #{sorted_rates.first.join(': ')}"
  end

  def save_to_file(data)
    data_hash = Digest::MD5.hexdigest(data)
    File.write("#{data_hash}.json", data) && puts('Saved to file!')
  end
end

ExchangeRates.new
