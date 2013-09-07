module Preek
  #Lets monkey patch to have a default action with arguments!
  module DefaultCommand
    def dispatch(meth, given_args, given_opts, config)
      meth = retrieve_command_name(given_args)
      command = all_commands[normalize_command_name(meth)]
      unless command
        given_args.unshift meth
        meth = default_command
        command = all_commands[meth]
      end
      if given_args.empty? && command.name == default_command
        handle_argument_error(command, nil, given_args, nil)
      end
      super
    end
  end
end