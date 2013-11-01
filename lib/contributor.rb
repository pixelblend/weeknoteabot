require 'net/http'
require 'json'
require 'set'

class Contributor
  WHEREABOUTS = 'http://where.prototype0.net/api/1/users.json?auth_token=XJzcxr4rqEyQ7q8b2BXh'
  attr_accessor :compiler

  def all
    @contributors ||= Set.new(fetch)
  end

  def member?(email)
    all.include?(email.downcase)
  end

  def compiler=(email)
    if self.member?(email)
      @compiler = email
    else
      false
    end
  end

  def compiler?(email=nil)
    if email.nil?
      !compiler.nil?
    else
      compiler == email.downcase
    end
  end

  private
  def fetch
    request.collect do |c|
      c['email'].downcase
    end
  end

  def request
    json = Net::HTTP.get(URI(WHEREABOUTS))
    JSON.parse(json)
  end
end
