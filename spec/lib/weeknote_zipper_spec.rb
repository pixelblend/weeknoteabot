require_relative '../spec_helper'

require 'weeknote_zipper'

describe WeeknoteZipper do
  it 'compresses a set of files' do
    files = [
      {:name => 'test_file_1', :file => Tempfile.new('test')},
      {:name => 'test_file_2', :file => Tempfile.new('test2')}
    ]

    zipper = WeeknoteZipper.new(files)
    zip_file = zipper.zip!

    zip_file.must_be_instance_of File

    File.extname(zip_file.path).must_equal '.zip'

    Zip::Archive.open(zip_file.path) do |archive|
      archive.num_files.must_equal 2

      archived_files = archive.map { |f| f.name }
      archived_files.must_equal %w{test_file_1 test_file_2}
    end
  end

  it 'stores data from files' do
    file_data = "HELLO I AM A FILE"
    file_to_zip = Tempfile.new('test')
    file_to_zip.write(file_data)

    files = [
      {:name => 'test.txt', :file => file_to_zip},
    ]

    zipper = WeeknoteZipper.new(files)
    zip_file = zipper.zip!

    Zip::Archive.open(zip_file.path) do |archive|
      archive.num_files.must_equal 1

      archive.each do |f|
        f.read.must_equal file_data
      end
    end
  end

  it 'renames files of the same filename' do
    files = [
      {:name => 'test.jpg', :file => Tempfile.new('test')},
      {:name => 'test.jpg', :file => Tempfile.new('test')},
      {:name => 'test.jpg', :file => Tempfile.new('test')}
    ]

    zipper = WeeknoteZipper.new(files)
    zip_file = zipper.zip!

    Zip::Archive.open(zip_file.path) do |archive|
      archive.num_files.must_equal 3

      archived_files = archive.map { |f| f.name }
      archived_files.must_equal %w{test.jpg test_1.jpg test_2.jpg}
    end
  end
end
