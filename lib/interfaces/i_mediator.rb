# frozen_string_literal: true

# i_mediator.rb
# PureMVC Ruby Multicore
#
# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

module PureMVC
  ##
  # The interface definition for a PureMVC <code>IMediator</code>.
  #
  # In PureMVC, <code>IMediator</code> implementors assume these responsibilities:
  #
  # * Implement a common method that returns a list of all <code>INotification</code>s
  #   the <code>IMediator</code> has interest in.
  # * Implement a notification callback method.
  # * Implement methods that are called when the <code>IMediator</code> is registered or removed from the <code>View</code>.
  #
  # Additionally, <code>IMediator</code>s typically:
  #
  # * Act as an intermediary between one or more view components such as text boxes or list controls,
  #   maintaining references and coordinating their behavior.
  # * In Flash-based apps, this is often the place where event listeners are
  #   added to view components and their handlers implemented.
  # * Respond to and generate <code>INotifications</code>, interacting with the rest of the PureMVC app.
  #
  # When an <code>IMediator</code> is registered with the <code>IView</code>,
  # the <code>IView</code> will call the <code>IMediator</code>'s <code>list_notification_interests</code> method.
  # The <code>IMediator</code> will return an <code>Array</code> of <code>INotification</code> names
  # which it wishes to be notified about.
  #
  # The <code>IView</code> will then create an <code>Observer</code> object
  # encapsulating that <code>IMediator</code>'s <code>handle_notification</code> method
  # and register it as an Observer for each <code>INotification</code> name returned by <code>list_notification_interests</code>.
  #
  # @see INotification
  module IMediator
    # @return [String] The name of the Mediator.
    def name
      raise NotImplementedError, "#{self.class} must implement #name"
    end

    # @return [Object, nil] The view component associated with this Mediator.
    def view
      raise NotImplementedError, "#{self.class} must implement #view"
    end
    # List <code>INotification</code> interests.
    #
    # @return [Array] an <code>Array</code> of the <code>INotification</code> names this <code>IMediator</code> has an interest in.
    def list_notification_interests
      raise NotImplementedError, "#{self.class} must implement #list_notification_interests"
    end

    # Handle an <code>INotification</code>.
    #
    # @param notification [INotification] the <code>INotification</code> to be handled
    # @return [void]
    def handle_notification(notification)
      raise NotImplementedError, "#{self.class} must implement #handle_notification"
    end

    # Called by the View when the Mediator is registered.
    # @return [void]
    def on_register
      raise NotImplementedError, "#{self.class} must implement #on_register"
    end

    # Called by the View when the Mediator is removed.
    # @return [void]
    def on_remove
      raise NotImplementedError, "#{self.class} must implement #on_remove"
    end
  end
end
