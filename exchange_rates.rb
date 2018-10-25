require 'json'
require 'net/http'
require 'digest'

class ExchangeRates
  EXCHANGE_API_URL = 'https://api.exchangeratesapi.io/latest'

  def initialize
    uri = URI(EXCHANGE_API_URL)
    api_json = Net::HTTP.get(uri)
    @api = JSON.parse(api_json)

    puts "Comma separated list of currencies:\n%s" % currencies(order: :desc).join(', ')
    puts "Highest rate (%s), lowest rate (%s)" % [maximum_rate.join(': '), minimum_rate.join(': ')]
    save_to_file(api_json) && puts('Saved to file!')
  end

  private

  # REQUIRED OPTIONS: (order: [:asc / :desc])
  def currencies(options)
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

  def sorted_rates
    @api['rates'].sort_by {|_, v| v}
  end

  def save_to_file(data)
    data_hash = Digest::MD5.hexdigest(data)
    File.write("#{data_hash}.json", data)
  end
end

ExchangeRates.new
