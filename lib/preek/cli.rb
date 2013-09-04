require 'thor'
require 'preek/version'

module Preek

  # whoop whoop
  class CLI < Thor
    include Thor::Actions

    desc 'version', 'Shows version'
    def version(*)
      say VERSION
    end

    desc 'smell FILE(S)|DIR', 'Pretty format Reek output'

    method_option :irresponsible,
                  type: :boolean,
                  aliases: '-i',
                  desc: 'Include IrresponsibleModule smell in output.'

    method_option :compact,
                  type: :boolean,
                  aliases: '-c',
                  desc: 'Compact output.'

    method_option :verbose,
                  type: :boolean,
                  aliases: '-v',
                  desc: 'Report files with no smells.'


    def smell(*args)
      Examiner.new(args, excludes, reporter: reporter, output: output).perform
    end

  private

    def reporter
      options[:verbose] ? VerboseReport : QuietReport
    end

    def output
      options[:compact] ? CompactOutput : Output
    end

    def _aliases
      {
        irresponsible: 'IrresponsibleModule'
      }
    end

    def includes
      options.keys.map {|key| _aliases[key.to_sym] }
    end

    def excludes
      (exclude_list - includes)
    end

    def exclude_list
      %w(IrresponsibleModule)
    end
  end
end
