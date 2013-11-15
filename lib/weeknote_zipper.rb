require 'zipruby'
require 'tempfile'

class WeeknoteZipper
  def initialize(files)
    @files = differentiate_filenames(files)
  end

  def zip!
    zip_file = Tempfile.new(['weeknote_zipper', '.zip'])

    Zip::Archive.open(zip_file.path, Zip::CREATE) do |ar|
      @files.each { |f| add_file_to_archive(f, ar) }
    end

    zip_file
  end

  private
  def add_file_to_archive(file, archive)
    file_object = file[:file]
    file_object.rewind

    archive.add_buffer(file[:name], file_object.read)
  end

  def differentiate_filenames(files)
    filenames = files.collect {|f| f[:name]} rescue []
    return files if filenames.length == filenames.uniq.length

    unique_names = []

    files.collect do |f|
      attempts = 0
      begin
        name = differentiate_filename(f[:name], attempts)
        attempts += 1
      end while unique_names.include?(name)

      unique_names << name

      f.merge({:name => name})
    end
  end

  def differentiate_filename(filename, attempts)
    if attempts > 0
      file_before_extension = File.basename(filename, '.*')
      file_extension = File.extname(filename)

      "#{file_before_extension}_#{attempts}#{file_extension}"
    else
      filename
    end
  end
end
