require 'template'

class NagEmail
  def initialize(non_submitters)
    @to = non_submitters
  end

  def write
    return nil if @to.empty?
    {
      :to => @to,
      :subject => 'Please write your weeknotes',
      :body => Template.render('nag')
    }
  end
end
