require_relative '../spec_helper'
require 'weeknote_submissions'
require 'mail'
require 'pathname'

describe WeeknoteSubmissions do
  subject { WeeknoteSubmissions.instance }

  before do
    subject.clear!
  end

  let(:email) do
    Mail.new do
      to 'weeknotabot@gmail.com'
      from 'dan@bbc.co.uk'
      subject 'My Weeknotes'

      body "This is what I did..."
    end
  end

  it "parses emails" do
    parsed = subject.add(email)
    parsed.must_equal({
      :from => 'dan@bbc.co.uk',
      :body => 'This is what I did...',
      :attachments => []
    })
  end

  it "compiles emails" do
    parsed = subject.add(email)

    comp = subject.compile!
    comp[:messages].length.must_equal 1
    comp[:attachments].length.must_equal 0
  end

  describe "emails with attachments" do
    let(:email) do
      Mail.new do
        to 'weeknotabot@gmail.com'
        from 'dan@bbc.co.uk'
        subject 'My Weeknotes'

        body "This is what I did..."
        add_file File.join(File.dirname(__FILE__)+'/../../README.mdown')
      end
    end

    it 'stores attachments' do
      parsed = subject.add(email)
      parsed[:attachments].length.must_equal 1
      attached = parsed[:attachments].first
      attached[:name].must_equal 'README.mdown'
      attached[:file].must_be_instance_of File
    end

    it 'flattens submitted attachments' do
      subject.add(email)
      subject.attachments.length.must_equal 1
      attached = subject.attachments.first

      attached[:name].must_equal 'README.mdown'
      attached[:file].must_be_instance_of File
    end

    it 'deletes attachments on clear' do
      parsed = subject.add(email)
      attached = parsed[:attachments][0][:file]
      attached_path = Pathname.new(attached)
      attached_path.exist?.must_equal true

      subject.clear!

      attached_path.exist?.must_equal false
    end
  end
end
