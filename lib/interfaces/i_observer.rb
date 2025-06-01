# frozen_string_literal: true
require 'interface'

# i_observer.rb
# PureMVC Ruby Multicore
#
# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

module PureMVC
  # The interface definition for a PureMVC Observer.
  #
  # In PureMVC, <code>IObserver</code> implementors assume these responsibilities:
  # - Encapsulate the notification (callback) method of the interested object.
  # - Encapsulate the notification context (this) of the interested object.
  # - Provide methods for setting the interested object's notification method and context.
  # - Provide a method for notifying the interested object.
  #
  # PureMVC does not rely upon underlying event
  # models such as the one provided with Flash,
  # and ActionScript 3 does not have an inherent
  # event model.
  #
  # The Observer Pattern as implemented within
  # PureMVC exists to support event-driven communication
  # between the application and the actors of the
  # MVC triad.
  #
  # An Observer is an object that encapsulates information
  # about an interested object with a notification method that
  # should be called when an <code>INotification</code> is broadcast. The Observer then
  # acts as a proxy for notifying the interested object.
  #
  # Observers can receive <code>Notification</code>s by having their
  # <code>notifyObserver</code> method invoked, passing
  # in an object implementing the <code>INotification</code> interface, such
  # as a subclass of <code>Notification</code>.
  #
  # @see IView
  # @see INotification
  IObserver = interface {
    # Notify the interested object.
    #
    # @param notification [INotification] the <code>INotification</code> to pass to the interested object's notification method
    # @return [void]
    def notify_observer(notification)
      raise NotImplementedError, "#{self.class} must implement #notify_observer"
    end

    # Compare the given object to the notification context object.
    #
    # @param object [Object] the object to compare.
    # @return [Boolean] indicating if the notification context and the object are the same.
    def compare_notify_context?(object)
      raise NotImplementedError, "#{self.class} must implement #compare_notify_context?"
    end
  }
end
