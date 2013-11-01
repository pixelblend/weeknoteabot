require 'net/http'
require 'json'
require 'set'

class Contributor
  WHEREABOUTS = 'http://where.prototype0.net/api/1/users.json?auth_token=XJzcxr4rqEyQ7q8b2BXh'
  attr_accessor :owner

  def all
    @contributors ||= Set.new(fetch)
  end

  def member?(email)
    all.include?(email.downcase)
  end

  def owner=(email)
    if self.member?(email)
      @owner = email
    else
      false
    end
  end

  def owner?(email=nil)
    if email.nil?
      !owner.nil?
    else
      owner == email.downcase
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
