# frozen_string_literal: true

require_relative '../../interfaces/i_mediator'

# mediator.rb
# PureMVC Ruby Multicore

# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

module PureMVC
  # A base <code>IMediator</code> implementation.
  #
  # @see PureMVC::View
  class Mediator < Notifier
    include IMediator

    # The name of the <code>Mediator</code>.
    #
    # Typically, a <code>Mediator</code> will be written to serve
    # one specific control or group controls and so,
    # will not have a need to be dynamically named.
    NAME = "Mediator"

    # @return [String] The name of the Mediator.
    attr_reader :name

    # @return [Object, nil] The view component associated with this Mediator.
    attr_accessor :view

    # Initializes a new Mediator instance.
    #
    # @param name [String] the name of the mediator (default: <code>NAME<code>)
    # @param view [Object, nil] the view component this mediator manages (default: <code>nil</code>)
    def initialize(name = NAME, view = nil)
      @name = name
      @view = view
    end

    # Returns an array of notification names this mediator is interested in.
    #
    # @return [Array<String>] list of notification names
    def list_notification_interests
      []
    end

    # Handles a notification.
    #
    # @param notification [INotification] the notification to handle
    def handle_notification(notification)

    end

    # Called when the mediator is registered.
    # @return [void]
    def on_register

    end

    # Called when the mediator is removed.
    # @return [void]
    def on_remove

    end

  end

end
