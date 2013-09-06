require 'thor'
require 'preek/version'

module Preek

  # whoop whoop
  class CLI < Thor
    include Thor::Actions

    def self.dispatch(meth, given_args, given_opts, config)
      meth = given_args[0]
      given_args.unshift 'smell' unless self.all_tasks[meth]
      puts self.all_tasks[meth]
      puts given_args.inspect
      super(meth, given_args, given_opts, config)
    end


    # def initialize(args=[], options={}, config={})
    #   current_command = config[:current_command]
    #   unless respond_to? current_command.name
    #     puts "not a command"
    #     smell_command = self.class.all_tasks['smell']
    #     #puts smell_command
    #     config[:current_command] = smell_command
    #     puts config[:current_command]
    #   end
    #   super(args, options, config)
    # end

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


    def smell(files)
      Examiner.new(args, excludes, reporter: reporter, output: output).perform
    end

  private

    def invoke
      puts "tralalla"
    end

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
