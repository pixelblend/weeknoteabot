require_relative 'spec_helper'
require 'mailer'

describe Mailer do
  it 'exists' do
    Mailer.new.wont_be_nil
  end
end
