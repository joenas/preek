module Preek
  require 'preek/version'
  require 'preek/smell_collector'
  require 'preek/smell_reporter'

  def self.Smell(filenames, excludes = [])
    files, not_files = filenames.partition { |file| File.exists? file }
    smelly_files = SmellCollector.new(files, excludes).smelly_files
    SmellReporter.new(smelly_files, not_files).print_result
  end
end