# frozen_string_literal: true
require 'interface'

# i_view.rb
# PureMVC Ruby Multicore
#
# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

module PureMVC
  # The interface definition for a PureMVC View.
  #
  # In PureMVC, <code>IView</code> implementors assume these responsibilities:
  #
  # In PureMVC, the <code>View</code> class assumes these responsibilities:
  # - Maintain a cache of <code>IMediator</code> instances.
  # - Provide methods for registering, retrieving, and removing <code>IMediators</code>.
  # - Managing the observer lists for each <code>INotification</code> in the application.
  # - Providing a method for attaching <code>IObservers</code> to an <code>INotification</code>'s observer list.
  # - Providing a method for broadcasting an <code>INotification</code>.
  # - Notifying the <code>IObservers</code> of a given <code>INotification</code> when it is broadcast.
  IView = interface {
    required_methods :register_observer,
                     :notify_observers,
                     :remove_observer,
                     :register_mediator,
                     :retrieve_mediator,
                     :has_mediator?,
                     :remove_mediator

    # Register an <code>IObserver</code> to be notified of <code>INotifications</code> with a given name.
    #
    # @param notification_name [String] the name of the <code>INotifications</code> to notify this <code>IObserver</code> of
    # @param observer [IObserver] the <code>IObserver</code> to register
    # @return [void]
    def register_observer(notification_name, observer)
      raise NotImplementedError, "#{self.class} must implement #register_observer"
    end

    # Notify the <code>IObservers</code> for a particular <code>INotification</code>.
    #
    # All previously attached <code>IObservers</code> for this <code>INotification</code>'s
    # list are notified and are passed a reference to the <code>INotification</code> in
    # the order in which they were registered.
    #
    # @param notification [INotification] the <code>INotification</code> to notify <code>IObservers</code> of.
    # @return [void]
    def notify_observers(notification)
      raise NotImplementedError, "#{self.class} must implement #notify_observers"
    end

    # Remove a group of observers from the observer list for a given <code>Notification</code> name.
    #
    # @param notification_name [String] which observer list to remove from
    # @param notify_context [Object] remove the observers with this object as their notifyContext
    # @return [void]
    def remove_observer(notification_name, notify_context)
      raise NotImplementedError, "#{self.class} must implement #remove_observer"
    end

    # Register an <code>IMediator</code> instance with the <code>View</code>.
    #
    # Registers the <code>IMediator</code> so that it can be retrieved by name,
    # and further interrogates the <code>IMediator</code> for its
    # <code>INotification</code> interests.
    #
    # If the <code>IMediator</code> returns any <code>INotification</code>
    # names to be notified about, an <code>Observer</code> is created encapsulating
    # the <code>IMediator</code> instance's <code>handleNotification</code> method
    # and registering it as an <code>Observer</code> for all <code>INotifications</code> the
    # <code>IMediator</code> is interested in.
    #
    # @param mediator [IMediator] a reference to the <code>IMediator</code> instance
    # @return [void]
    def register_mediator(mediator)
      raise NotImplementedError, "#{self.class} must implement #register_mediator"
    end

    # Retrieve an <code>IMediator</code> from the <code>View</code>.
    #
    # @param mediator_name [String] the name of the <code>IMediator</code> instance to retrieve.
    # @return [IMediator | nil] the <code>IMediator</code> instance previously registered with the given <code>mediatorName</code>.
    def retrieve_mediator(mediator_name)
      raise NotImplementedError, "#{self.class} must implement #retrieve_mediator"
    end

    # Check if a <code>Mediator</code> is registered or not.
    #
    # @param mediator_name [String]
    # @return [Boolean] whether a <code>Mediator</code> is registered with the given <code>mediatorName</code>.
    def has_mediator?(mediator_name)
      raise NotImplementedError, "#{self.class} must implement #has_mediator?"
    end

    # Remove an <code>IMediator</code> from the <code>View</code>.
    #
    # @param mediator_name [String] name of the <code>IMediator</code> instance to be removed.
    # @return [IMediator | nil] the <code>IMediator</code> that was removed from the <code>View</code>
    def remove_mediator(mediator_name)
      raise NotImplementedError, "#{self.class} must implement #remove_mediator"
    end
  }
end
