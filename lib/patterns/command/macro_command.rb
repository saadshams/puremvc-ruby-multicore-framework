# frozen_string_literal: true

# macro_command.rb
# PureMVC Ruby Multicore
#
# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

require_relative '../../interfaces/i_command'

module PureMVC
  # A base ICommand implementation that executes other ICommand instances.
  #
  # A MacroCommand maintains a list of ICommand class references called SubCommands.
  #
  # When <code>execute</code>is called, the MacroCommand instantiates and calls <code>execute</code>on each of its SubCommands in turn.
  # Each SubCommand will be passed a reference to the original INotification that was passed to the MacroCommand's <code>execute</code>method.
  #
  # Unlike SimpleCommand, your subclass should not override <code>execute</code> but instead override <code>initialize_macro_command</code>
  # calling <code>add_sub_command</code>once for each SubCommand to be executed.
  #
  # @see Controller
  # @see Notification
  # @see SimpleCommand
  class MacroCommand < Notifier
    include ICommand

    # Constructor.
    #
    # You should not need to define a constructor,
    # instead, override the <code>initialize_macro_command</code> method.
    #
    # If your subclass does define a constructor,
    # be sure to call <code>super</code>
    def initialize
      @sub_commands = []
      initialize_macro_command
    end

    # Initialize the MacroCommand.
    #
    # In your subclass, override this method to
    # initialize the MacroCommand's SubCommand list with
    # ICommand factory references, like this:
    #
    # @example
    #   def initialize_macro_command
    #     add_sub_command  { FirstCommand.new }
    #     add_sub_command  { SecondCommand.new }
    #     add_sub_command  { ThirdCommand.new }
    #   end
    #
    # Note that SubCommands may be any ICommand implementor;
    # MacroCommands or SimpleCommands are both acceptable.
    # @return [void]
    def initialize_macro_command

    end

    # Add a SubCommand.
    # SubCommands will be called in First In/First Out (FIFO) order.
    #
    # @param factory [Proc<() -> ICommand>] A block or callable that returns an instance of ICommand when called.
    # @return [void]
    def add_sub_command(&factory)
      @sub_commands << factory
    end

    # Execute this MacroCommand's SubCommands.
    #
    # The SubCommands will be called in First In/First Out (FIFO) order.
    #
    # @param notification [INotification] the notification object to be passed to each SubCommand.
    # @return [void]
    def execute(notification)
      while @sub_commands.any?
        factory = @sub_commands.shift
        command = factory.call
        command.initialize_notifier(@multiton_key)
        command.execute(notification)
      end
    end

  end

end
