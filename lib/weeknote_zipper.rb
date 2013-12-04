require 'zipruby'
require 'tempfile'

class WeeknoteZipper
  def initialize(files)
    @files = differentiate_filenames(files)
  end

  def zip!
    $logger.info("Zipping #{@files.count} files")
    zip_file = Tempfile.new(['weeknote_zipper', '.zip'])

    zip = Zip::Archive.open_buffer(Zip::CREATE) do |ar|
      @files.each { |f| add_file_to_archive(f, ar) }
    end

    zip_file.write(zip)

    count = zip.length

    zip_file.rewind
    $logger.info("Archive #{zip_file.path}, #{count} bytes")
    zip_file
  end

  private
  def add_file_to_archive(file, archive)
    file_object = file[:file]
    file_object.rewind

    $logger.info("Adding file #{file[:name]}, #{file_object.read.length} bytes")
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
