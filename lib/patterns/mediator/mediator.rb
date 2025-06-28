# frozen_string_literal: true

# mediator.rb
# PureMVC Ruby Multicore
#
# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

module PureMVC
  # A base <code>IMediator</code> implementation.
  #
  # @see View
  class Mediator < Notifier

    # The name of the <code>Mediator</code>.
    #
    # Typically, a <code>Mediator</code> will be written to serve
    # one specific control or group controls and so,
    # will not have a need to be dynamically named.
    NAME = "Mediator"
    public_constant :NAME

    # @return [String] The name of the Mediator.
    attr_reader :name

    # @return [Object, nil] The component associated with this Mediator.
    attr_accessor :component

    # Initializes a new Mediator instance.
    #
    # @param name [String | nil] the name of the mediator
    # @param component [Object, nil] the component this mediator manages
    def initialize(name = nil, component = nil)
      @name = name || NAME
      @component = component
    end

    # Returns an array of notification names this mediator is interested in.
    #
    # @return [Array<String>] list of notification names
    def list_notification_interests
      []
    end

    # Handles a notification.
    #
    # @param notification [_INotification] the notification to handle
    # @return [void]
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
