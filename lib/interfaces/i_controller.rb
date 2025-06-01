require 'interface'
# frozen_string_literal: true

# i_controller.rb
# PureMVC Ruby Multicore
#
# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

module PureMVC
  # The interface definition for a PureMVC Controller.
  #
  # In PureMVC, an <code>IController</code> implementor
  # follows the 'Command and Controller' strategy, and
  # assumes these responsibilities:
  #
  # - Remembering which <code>ICommand</code>s
  #   are intended to handle which <code>INotifications</code>.
  # - Registering itself as an <code>IObserver</code> with
  #   the <code>View</code> for each <code>INotification</code>
  #   that it has an <code>ICommand</code> mapping for.
  # - Creating a new instance of the proper <code>ICommand</code>
  #   to handle a given <code>INotification</code> when notified by the <code>View</code>.
  # - Calling the <code>ICommand</code>'s <code>execute</code>
  #   method, passing in the <code>INotification</code>.
  #
  # @see INotification
  # @see ICommand
  IController = interface {
    # Register a particular <code>ICommand</code> class as the handler
    # for a particular <code>INotification</code>.
    #
    # @abstract This method must be implemented by the concrete command.
    # @param notification_name [String] the name of the <code>INotification</code>
    # @param factory [Proc<() -> ICommand>] the class of the ICommand
    # @return [void]
    def register_command(notification_name, &factory)
      raise NotImplementedError, "#{self.class} must implement #register_command"
    end

    # Execute the <code>ICommand</code> previously registered as the
    # handler for <code>INotification</code>s with the given notification name.
    #
    # @abstract This method must be implemented by the concrete command.
    # @param notification [INotification] the <code>INotification</code> to execute the associated <code>ICommand</code> for
    # @return [void]
    def execute_command(notification)
      raise NotImplementedError, "#{self.class} must implement #execute_command"
    end

    # Check if a Command is registered for a given Notification.
    #
    # @abstract This method must be implemented by the concrete command.
    # @param notification_name [String]
    # @return [Boolean] whether a Command is currently registered for the given <code>notificationName</code>.
    def has_command?(notification_name)
      raise NotImplementedError, "#{self.class} must implement #has_command?"
    end

    # Remove a previously registered <code>ICommand</code> to <code>INotification</code> mapping.
    #
    # @abstract This method must be implemented by the concrete command.
    # @param notification_name [String] the name of the <code>INotification</code> to remove the <code>ICommand</code> mapping for
    # @return [void]
    def remove_command(notification_name)
      raise NotImplementedError, "#{self.class} must implement #remove_command"
    end

  }
end
