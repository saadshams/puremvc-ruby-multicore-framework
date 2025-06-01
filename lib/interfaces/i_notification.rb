# frozen_string_literal: true
require 'interface'

# i_notification.rb
# PureMVC Ruby Multicore
#
# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

module PureMVC
  # The interface definition for a PureMVC Notification.
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
  # in Flex/Flash/AIR. Generally, <code>IMediator</code> implementors
  # place event listeners on their view components, which they
  # then handle in the usual way. This may lead to the broadcast of <code>Notification</code>s to
  # trigger <code>ICommand</code>s or to communicate with other <code>IMediators</code>.
  # <code>IProxy</code> and <code>ICommand</code>
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
  # @see IView
  # @see IObserver
  INotification = interface {
    # @return [String] the name of the notification
    def name
      raise NotImplementedError, "#{self.class} must implement #name"
    end

    # @return [Object, nil] the body of the notification
    def body
      raise NotImplementedError, "#{self.class} must implement #body"
    end

    # @return [String, nil] the type of the notification
    def type
      raise NotImplementedError, "#{self.class} must implement #type"
    end

    # Get the string representation of the <code>INotification</code> instance
    #
    # @return [String]
    def to_s
      raise NotImplementedError, "#{self.class} must implement #to_s"
    end
  }
end
