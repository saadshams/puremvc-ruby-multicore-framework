# frozen_string_literal: true

# observer.rb
# PureMVC Ruby Multicore

# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

require_relative '../../interfaces/i_observer'

module PureMVC
  # A base <code>IObserver</code> implementation.
  #
  # An <code>Observer</code> is an object that encapsulates information
  # about an interested object with a method that should
  # be called when a particular <code>INotification</code> is broadcast.
  #
  # In PureMVC, the <code>Observer</code> class assumes these responsibilities:
  # - Encapsulate the notification (callback) method of the interested object.
  # - Encapsulate the notification context (<code>self</code>) of the interested object.
  # - Provide methods for setting the notification method and context.
  # - Provide a method for notifying the interested object.
  #
  # @see PureMVC::View
  # @see PureMVC::Notification
  class Observer
    include IObserver

    # @return [Method] notify The callback method to be called on notification.
    attr_accessor :notify

    # @return [Object] context The object context for the callback.
    attr_accessor :context

    # Initialize an Observer with a notify method and context.
    #
    # @param notify [Method, nil] the callback method to invoke on notification.
    # @param context [Object, nil] the object context for the callback.
    def initialize(notify = nil, context = nil)
      @notify = notify
      @context = context
    end

    # Calls the notify method with the given notification.
    #
    # @param notification [INotification] the notification to send.
    # @return [void]
    def notify_observer(notification)
      @notify&.call(notification)
    end

    # Compares the given object with the Observer's context.
    #
    # @param object [Object] the object to compare.
    # @return [Boolean] true if the given object is the same as the context.
    def compare_notify_context?(object)
      object.equal?(@context)
    end

  end
end
