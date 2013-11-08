require_relative '../spec_helper'

require 'fetch_from_whereabouts'

describe FetchFromWhereabouts do
  subject { FetchFromWhereabouts }

  before do
    subject.stubs(:request).returns([{'email' => 'dan@bbc.co.uk'}, {}])
  end

  it 'fetches a list of contributors from whereabouts' do
    contributors = subject.fetch

    contributors.length.must_equal 1
    contributors.first.must_equal 'dan@bbc.co.uk'
  end
end
