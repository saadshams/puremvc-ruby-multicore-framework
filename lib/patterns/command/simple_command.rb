# frozen_string_literal: true

# simple_command.rb
# PureMVC Ruby Multicore
#
# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

module PureMVC
  # A base <code>ICommand</code>implementation.
  #
  # Subclasses should override the <code>execute</code>method, where business logic
  # will handle the <code>INotification</code>.
  #
  # @see Controller
  # @see Notification
  # @see MacroCommand
  class SimpleCommand # < Notifier

    # Fulfill the use-case initiated by the given <code>INotification</code>.
    #
    # In the Command Pattern, an application use-case typically begins with some user action,
    # which results in an <code>INotification</code>being broadcast, handled by business logic in the
    # <code>execute</code>method of an <code>ICommand</code>.
    #
    # @param notification [_INotification] the notification to handle
    # @return [void]
    def execute(notification)

    end

  end

end
