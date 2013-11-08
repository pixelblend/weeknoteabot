require_relative '../spec_helper'

require 'contributors'

describe Contributors do
  describe 'members' do
    subject { Contributors.new(['dan@bbc.co.uk']) }

    it 'tells you if an email address is a contributor' do
      subject.member?('dan@BBC.co.uk').must_equal true
      subject.member?('dave@notBBC.co.uk').must_equal false
    end
  end

  describe 'compiler' do
    subject { Contributors.new(['dan@bbc.co.uk', 'tracy@bbc.co.uk']) }

    it 'returns a contributor list with a compiler' do
      contributors = subject.compiler! 'tracy@bbc.co.uk'

      contributors.compiler.must_equal 'tracy@bbc.co.uk'
      contributors.compiler?.must_equal true
      contributors.compiler?('tracy@bbc.co.uk').must_equal true
      contributors.compiler?('dan@bbc.co.uk').must_equal false
    end

    it 'prevents non-contributors from owning' do
      contributors = subject.compiler! 'someone@NOTbbc.co.uk'
      contributors.compiler?('someone@NOTbbc.co.uk').must_equal false

      contributors.compiler?.must_equal false
    end
  end
end