require_relative '../spec_helper'

require 'contributors'

describe Contributors do
  it 'writes to cache on creation' do
    ContributorsCache.expects(:write).once
    Contributors.new(['dan@bbc.co.uk'])
  end

  describe 'members' do
    subject { Contributors.new(['dan@bbc.co.uk']) }

    it 'tells you if an email address is a contributor' do
      subject.member?('dan@BBC.co.uk').must_equal true
      subject.member?('dave@notBBC.co.uk').must_equal false
    end
  end

  describe 'submitters' do
    subject { Contributors.new(['dan@bbc.co.uk', 'tracy@bbc.co.uk']) }

    it 'returns a contributor list with a compiler' do
      contributors = subject.submitted! 'tracy@bbc.co.uk'
      contributors.submitters.must_equal ['tracy@bbc.co.uk']
    end

    it 'returns nonsubmission list' do
      contributors = subject.submitted! 'tracy@bbc.co.uk'
      contributors.non_submitters.must_equal ['dan@bbc.co.uk']
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

    it 'keeps submitter and members state when updating' do
      contributors = subject.submitted!('dan@bbc.co.uk')
                     .compiler!('tracy@bbc.co.uk')

      contributors.submitters.must_equal ['dan@bbc.co.uk']
      contributors.members.must_equal ['dan@bbc.co.uk', 'tracy@bbc.co.uk']
    end

    it 'prevents non-contributors from owning' do
      contributors = subject.compiler! 'someone@NOTbbc.co.uk'
      contributors.compiler?('someone@NOTbbc.co.uk').must_equal false

      contributors.compiler?.must_equal false
    end
  end
end
