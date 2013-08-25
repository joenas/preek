require 'thor'

require 'preek/version'
require 'preek/smell_collector'
require 'preek/smell_reporter'

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
                  desc: 'include IrresponsibleModule smell in output.'
    def smell(*args)
      Preek::Smell(args, excludes)
    end

  private
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
