require 'preek/ext/smell_warning'
require 'preek/smell_file'
require 'preek/smell_klass'
module Preek
  class VerboseReport
    def self.verbose?
      true
    end

    def initialize(examiner, output)
      @examiner, @output = examiner, output
    end

    def report
      print_header
      if @examiner.smelly?
        report_smells
      else
        report_success
      end
    end

    private

    def print_header
      @output.print_line
      @output.blue :file, "#{@examiner.description}\n"
    end

    def smell_file
      SmellFile.new(@examiner)
    end

    def report_smells
      smell_file.klasses do |klass|
        @output.green :class, klass.name
        @output.red :smells, ''
        klass.smells.each &print_smell
      end
    end

    def print_smell
      lambda {|smell| @output.status nil, smell }
    end

    def print_klass_smells(smells)
      smells.each {|smell| @output.status nil, smell }
    end

    def report_success
      @output.green :success, "No smells detected.\n"
    end
  end

  class QuietReport < VerboseReport
    def self.verbose?
      false
    end

    def report
      print_header && report_smells if @examiner.smelly?
    end
  end
end