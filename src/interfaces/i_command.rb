# frozen_string_literal: true

# i_command.rb
# PureMVC Ruby Multicore

# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

module PureMVC
  # The interface definition for a PureMVC Command.
  #
  # @see PureMVC::INotification
  module ICommand
    # Execute the <code>ICommand</code>'s logic to handle a given <code>INotification</code>.
    #
    # @abstract This method must be implemented by the concrete command.
    # @param notification [PureMVC::INotification] an INotification to handle.
    def execute(notification)
      raise NotImplementedError, "#{self.class} must implement #execute"
    end
  end
end
