module Preek
  require 'preek/version'
  require 'preek/examiner'
  require 'preek/report'
  require 'preek/output'

  def self.Smell(filenames, excludes = [])
    Examiner.new(filenames, excludes).perform
  end
end