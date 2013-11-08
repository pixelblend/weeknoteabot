require 'net/http'
require 'json'

module FetchFromWhereabouts
  URL = 'http://where.prototype0.net/api/1/users.json?auth_token=XJzcxr4rqEyQ7q8b2BXh'

  def self.fetch
    self.request.collect do |c|
      c['email']
    end.compact
  end

  def self.request
    json = Net::HTTP.get(URI(URL))
    JSON.parse(json)
  end
end
