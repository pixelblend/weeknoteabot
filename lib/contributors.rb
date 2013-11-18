require 'set'
require 'values'

class Contributors < Value.new(:members, :compiler, :submitters)
  def initialize(members=[], compiler=false, submitters=[])
    members    ||= Set.new(members.collect(&:downcase))
    submitters ||= Set.new(submitters.collect(&:downcase))
    compiler   = compiler == false ? compiler : compiler.downcase

    super(members, compiler, submitters)
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
      Contributors.new(@members, email)
    else
      self
    end
  end

  def submitted?(email)
    @submitters.include?(email.downcase)
  end

  def submitted!(email)
    if member?(email)
      Contributors.new(@members, @compiler, @submitters << email)
    else
      self
    end
  end

  def non_submitters
    @members - @submitters
  end
end
