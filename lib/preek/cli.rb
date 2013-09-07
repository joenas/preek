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
      return help if files.empty?
      Examiner.new(files, excludes, reporter: reporter, output: output).perform
    end


  # no_commands do
  #   def invoke_command(command, trailing)
  #     puts command.inspect
  #     puts trailing.inspect
  #   end
  # end

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

    # Lets monkey patch to have a default action with arguments!
    def self.dispatch(meth, given_args, given_opts, config)
      meth ||= default_command unless all_commands[given_args[0]]
      super
    end
  end
end
