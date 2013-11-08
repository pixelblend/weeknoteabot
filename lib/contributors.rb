require 'set'
require 'values'

class Contributors < Value.new(:members, :compiler)
  def initialize(members=[], compiler=false)
    members ||= Set.new(members.collect(&:downcase))
    super(members, compiler)
  end

  def member?(email)
    @members.include?(email.downcase)
  end

  def compiler?(email=nil)
    if email.nil?
      @compiler != false
    else
      @compiler == email.downcase
    end
  end

  def compiler!(email)
    if member?(email)
      Contributors.new(@members, email.downcase)
    else
      self
    end
  end
end
