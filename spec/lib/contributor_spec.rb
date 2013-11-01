require_relative '../spec_helper'

require 'contributor'

describe Contributor do
  subject { Contributor.new }

  describe 'members' do
    before do
      subject.stubs(:request).returns([{'email' => 'dan@bbc.co.uk'}])
    end

    it 'fetches a list of contributors from whereabouts' do
      subject.all.length.must_equal 1
      subject.all.first.must_equal 'dan@bbc.co.uk'
    end

    it 'tells you if an email address comes from a contributor' do
      subject.member?('dan@BBC.co.uk').must_equal true
      subject.member?('dave@notBBC.co.uk').must_equal false
    end
  end

  describe 'compiler' do
    before do
      subject.stubs(:request).returns([
        {'email' => 'dan@bbc.co.uk'},
        {'email' => 'tracy@bbc.co.uk'},
      ])
    end

    it 'sets a contributor as compiler' do
      subject.compiler = 'tracy@bbc.co.uk'

      subject.compiler.must_equal 'tracy@bbc.co.uk'
      subject.compiler?.must_equal true
      subject.compiler?('tracy@bbc.co.uk').must_equal true
      subject.compiler?('dan@bbc.co.uk').must_equal false
    end

    it 'prevents non-contributors from owning' do
      subject.compiler = 'someone@NOTbbc.co.uk'
      subject.compiler?('someone@NOTbbc.co.uk').must_equal false

      subject.compiler?.must_equal false
    end
  end
end
