# frozen_string_literal: true

# notification.rb
# PureMVC Ruby Multicore
#
# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

require_relative '../../interfaces/i_notification'

module PureMVC
  # A base <code>INotification</code>implementation.
  #
  # PureMVC does not rely upon underlying event models such
  # as the one provided with Flash, and ActionScript 3 does
  # not have an inherent event model.
  #
  # The Observer Pattern as implemented within PureMVC exists
  # to support event-driven communication between the
  # application and the actors of the MVC triad.
  #
  # Notifications are not meant to be a replacement for Events
  # in Flex/Flash/Apollo. Generally, <code>IMediator</code>implementors
  # place event listeners on their view components, which they
  # then handle in the usual way. This may lead to the broadcast of <code>Notification</code>s to
  # trigger <code>ICommand</code>s or to communicate with other <code>IMediator</code>s. <code>IProxy</code>and <code>ICommand</code>
  # instances communicate with each other and <code>IMediator</code>s
  # by broadcasting <code>INotification</code>s.
  #
  # A key difference between Flash <code>Event</code>s and PureMVC
  # <code>Notification</code>s is that <code>Event</code>s follow the
  # 'Chain of Responsibility' pattern, 'bubbling' up the display hierarchy
  # until some parent component handles the <code>Event</code>, while
  # PureMVC <code>Notification</code>s follow a 'Publish/Subscribe'
  # pattern. PureMVC classes need not be related to each other in a
  # parent/child relationship to communicate with one another
  # using <code>Notification</code>s.
  #
  # @see Observer
  class Notification
    # @return [String] the name of the notification
    attr_reader :name

    # @return [Object, nil] the body of the notification
    attr_accessor :body

    # @return [String, nil] the type of the notification
    attr_accessor :type

    # The Notification class represents a message with a name, optional body, and optional type.
    #
    # @param name [String] the name of the notification
    # @param body [Object, nil] optional data to pass with the notification
    # @param type [String, nil] optional type identifier
    def initialize(name, body = nil, type = nil)
      @name = name
      @body = body
      @type = type
    end

    # Returns a string representation of the notification.
    #
    # @return [String]
    def to_s
      "Notification Name: #{@name}" \
        "\nBody: #{@body.inspect}" \
        "\nType: #{@type}"
    end

    implements INotification

  end
end
