# frozen_string_literal: true
require 'interface'

# i_facade.rb
# PureMVC Ruby Multicore
#
# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

module PureMVC
  # The interface definition for a PureMVC Facade.
  #
  # The Facade Pattern suggests providing a single
  # class to act as a central point of communication
  # for a subsystem.
  #
  # In PureMVC, the Facade acts as an interface between
  # the core MVC actors (<code>Model</code>, <code>View</code>, <code>Controller</code>) and
  # the rest of your application.
  #
  # @see IModel
  # @see IView
  # @see IController
  # @see ICommand
  # @see INotification
  IFacade = interface {
    required_methods :register_command,
                     :has_command?,
                     :remove_command,
                     :register_proxy,
                     :retrieve_proxy,
                     :has_proxy?,
                     :remove_proxy,
                     :register_mediator,
                     :retrieve_mediator,
                     :has_mediator?,
                     :remove_mediator,
                     :notify_observers

    implements INotifier

    # Register an <code>ICommand</code> with the <code>Controller</code>.
    #
    # @param notification_name [String] the name of the <code>INotification</code> to associate the <code>ICommand</code> with.
    # @param factory [Proc<() -> ICommand>] the factory to produce an instance of the ICommand
    def register_command(notification_name, &factory)
      raise NotImplementedError, "#{self.class} must implement #register_command"
    end

    # Check if a Command is registered for a given Notification
    #
    # @param notification_name [String]
    # @return [Boolean] whether a Command is currently registered for the given <code>notification_name</code>.
    def has_command?(notification_name)
      raise NotImplementedError, "#{self.class} must implement #has_command?"
    end

    # Remove a previously registered <code>ICommand</code> to <code>INotification</code> mapping from the Controller.
    #
    # @param notification_name [String] the name of the <code>INotification</code> to remove the <code>ICommand</code> mapping for
    def remove_command(notification_name)
      raise NotImplementedError, "#{self.class} must implement #remove_command"
    end

    # Register an <code>IProxy</code> with the <code>Model</code> by name.
    #
    # @param proxy [IProxy] the <code>IProxy</code> to be registered with the <code>Model</code>.
    def register_proxy(proxy)
      raise NotImplementedError, "#{self.class} must implement #register_proxy"
    end

    # Retrieve a <code>IProxy</code> from the <code>Model</code> by name.
    #
    # @param proxy_name [String] the name of the <code>IProxy</code> instance to be retrieved.
    # @return [IProxy] the <code>IProxy</code> previously registered by <code>proxy_name</code> with the <code>Model</code>.
    def retrieve_proxy(proxy_name)
      raise NotImplementedError, "#{self.class} must implement #retrieve_proxy"
    end

    # Check if a Proxy is registered
    #
    # @param proxy_name [String]
    # @return [Boolean] whether a Proxy is currently registered with the given <code>proxy_name</code>.
    def has_proxy?(proxy_name)
      raise NotImplementedError, "#{self.class} must implement #has_proxy?"
    end

    # Remove an <code>IProxy</code> instance from the <code>Model</code> by name.
    #
    # @param proxy_name [String] the <code>IProxy</code> to remove from the <code>Model</code>.
    # @return [IProxy] the <code>IProxy</code> that was removed from the <code>Model</code>
    def remove_proxy(proxy_name)
      raise NotImplementedError, "#{self.class} must implement #remove_proxy"
    end

    # Register an <code>IMediator</code> instance with the <code>View</code>.
    #
    # @param mediator [IMediator] a reference to the <code>IMediator</code> instance
    def register_mediator(mediator)
      raise NotImplementedError, "#{self.class} must implement #register_mediator"
    end

    # Retrieve an <code>IMediator</code> instance from the <code>View</code>.
    #
    # @param mediator_name [String] the name of the <code>IMediator</code> instance to retrieve
    # @return [IMediator] the <code>IMediator</code> previously registered with the given <code>mediator_name</code>.
    def retrieve_mediator(mediator_name)
      raise NotImplementedError, "#{self.class} must implement #retrieve_mediator"
    end

    # Check if a Mediator is registered or not
    #
    # @param mediator_name [String]
    # @return [Boolean] whether a Mediator is registered with the given <code>mediator_name</code>.
    def has_mediator?(mediator_name)
      raise NotImplementedError, "#{self.class} must implement #has_mediator?"
    end

    # Remove an <code>IMediator</code> instance from the <code>View</code>.
    #
    # @param mediator_name [String] name of the <code>IMediator</code> instance to be removed.
    # @return [IMediator] the <code>IMediator</code> instance previously registered with the given <code>mediator_name</code>.
    def remove_mediator(mediator_name)
      raise NotImplementedError, "#{self.class} must implement #remove_mediator"
    end

    # Notify <code>Observer</code>s.
    #
    # This method is left public mostly for backward
    # compatibility and to allow you to send custom
    # notification classes using the facade.
    #
    # Usually you should call sendNotification
    # and pass the parameters, never having to
    # construct the notification yourself.
    #
    # @param notification [INotification] the <code>INotification</code> to have the <code>View</code> notify <code>Observers</code> of.
    def notify_observers(notification)
      raise NotImplementedError, "#{self.class} must implement #notify_observers"
    end

  }
end
