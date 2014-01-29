require 'thor'
require 'preek/version'
require 'preek/default_command'

module Preek

  # whoop whoop
  class CLI < Thor
    include Thor::Actions
    extend DefaultCommand

    desc 'version', 'Shows version'
    def version(*)
      say VERSION
    end

    default_command :smell
    desc 'smell FILE(S)|DIR', 'Shorthand: preek [FILES]'
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


    def smell(*files)
      Examiner.new(files, excludes, reporter: reporter, output: output).perform
    end

    desc 'git', 'Run Preek on git changes'
    def git
      files = `git status -s`
      if $?.exitstatus == 0 && !files.empty?
        args = files.scan(/[ M?]+ (.*)/)
        smell *args.flatten
      end
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
