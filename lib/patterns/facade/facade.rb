# frozen_string_literal: true

# facade.rb
# PureMVC Ruby Multicore
#
# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

module PureMVC
  # A base Multiton <code>IFacade</code> implementation.
  #
  # @see Model
  # @see View
  # @see Controller
  class Facade

    # Message Constants
    MULTITON_MSG = 'Facade instance for this Multiton key already constructed!'
    private_constant :MULTITON_MSG

    class << self
      # The Multiton IFacade instanceMap.
      # @return [Hash{String => IFacade}]
      def instance_map = (@instance_map ||= {})

      # Mutex used to synchronize access to the instance map for thread safety.
      # @return [Mutex]
      def mutex = (@mutex ||= Mutex.new)

      # Facade Multiton Factory method.
      #
      # @param key [String] the unique key identifying the Multiton instance
      # @param factory [^(String) -> _IFacade] the unique key passed to the factory block
      # @return [IFacade] the Multiton instance of the Facade
      def get_instance(key, &factory)
        mutex.synchronize do
          instance_map[key] ||= factory.call(key)
        end
      end

      # Check if a Core is registered or not.
      #
      # @param key [String] the multiton key for the Core in question
      # @return [Boolean] whether a Core is registered with the given <code>key</code>.
      def has_core?(key)
        instance_map.key?(key)
      end

      # Remove a Core.
      #
      # Removes the Model, View, Controller, and Facade
      # instances associated with the given key.
      #
      # @param key [String] the key of the Core to remove
      def remove_core(key)
        mutex.synchronize do
          Model.remove_model(key)
          View.remove_view(key)
          Controller.remove_controller(key)
          instance_map.delete(key)
        end
      end
    end

    # Constructor.
    #
    # This <code>IFacade</code> implementation is a Multiton, so you should not call the constructor
    # directly. Instead, use the static factory method and pass the unique key for this instance with factory:
    # <code>PureMVC::Facade.get_instance(key) { |key| PureMVC::Facade.new(key) }</code>.
    #
    # @param key [String]
    # @raise [RuntimeError] if an instance for this Multiton key has already been constructed.
    def initialize(key)
      raise MULTITON_MSG if self.class.instance_map[key]

      self.class.instance_map[key] = self
      @model = @view = @controller = nil
      initialize_notifier(key)
      initialize_facade
    end

    # Initialize the Multiton <code>Facade</code> instance.
    #
    # This method is called automatically by the constructor. Override it in your
    # subclass to perform any subclass-specific initialization.
    #
    # @note Be sure to call <code>super.initialize_facade</code> when overriding.
    def initialize_facade
      initialize_model
      initialize_controller
      initialize_view
    end

    # Initialize the <code>Controller</code>.
    #
    # Called by the <code>initialize_facade</code> method.
    #
    # Override this method in your subclass of <code>Facade</code> if one or both of the following are true:
    # - You wish to initialize a different <code>IController</code>.
    # - You have <code>Commands</code> to register with the <code>Controller</code> at startup.
    #
    # If you don't want to initialize a different <code>IController</code>, call <code>super.initialize_controller()</code>
    # at the beginning of your method, then register <code>Command</code>s.
    def initialize_controller
      @controller = Controller.get_instance(@multiton_key) { |key| Controller.new(key) }
    end

    # Initialize the <code>Model</code>.
    #
    # Called by the <code>initializeFacade</code> method.
    #
    # Override this method in your subclass of <code>Facade</code> if one or both of the following are true:
    # - You wish to initialize a different <code>IModel</code>.
    # - You have <code>Proxy</code>s to register with the Model that do not retrieve a reference to the <code>Facade</code> at construction time.
    #
    # If you don't want to initialize a different <code>IModel</code>, call <code>super.initialize_model()</code> at the beginning of your method, then register <code>Proxy</code>s.
    #
    # Note: This method is <i>rarely</i> overridden; in practice you are more likely to use a <code>Command</code> to create and register <code>Proxy</code>s with the <code>Model</code>,
    # since <code>Proxy</code>s with mutable data will likely need to send <code>INotification</code>s and thus will likely want to fetch a reference to the <code>Facade</code> during their construction.
    def initialize_model
      @model = Model.get_instance(@multiton_key) { |key| Model.new(key) }
    end

    # Initialize the <code>View</code>.
    #
    # Called by the <code>initializeFacade</code> method.
    #
    # Override this method in your subclass of <code>Facade</code> if one or both of the following are true:
    # - You wish to initialize a different <code>IView</code>.
    # - You have <code>Observers</code> to register with the <code>View</code>.
    #
    # If you don't want to initialize a different <code>IView</code>, call <code>super.initialize_view()</code> at the beginning of your method, then register <code>IMediator</code> instances.
    #
    # Note: This method is <i>rarely</i> overridden; in practice you are more likely to use a <code>Command</code> to create and register <code>Mediator</code>s with the <code>View</code>, #
    # since <code>IMediator</code> instances will need to send <code>INotification</code>s and thus will likely want to fetch a reference to the <code>Facade</code> during their construction.
    def initialize_view
      @view = View.get_instance(@multiton_key) { |key| View.new(key) }
    end

    # Register an <code>ICommand</code> with the <code>Controller</code> by Notification name.
    #
    # @param notification_name [String] the name of the <code>INotification</code> to associate the <code>ICommand</code> with
    # @param factory [^<() -> ICommand>] a reference to the Class of the <code>ICommand</code>
    def register_command(notification_name, &factory)
      @controller&.register_command(notification_name, &factory)
    end

    # Check if a Command is registered for a given Notification
    #
    # @param notification_name [String] The name of the Notification to check
    # @return [Boolean] whether a Command is currently registered for the given <code>notification_name</code>.
    def has_command?(notification_name)
      !!@controller&.has_command?(notification_name)
    end

    # Remove a previously registered <code>ICommand</code> to <code>INotification</code> mapping from the Controller.
    #
    # @param notification_name [String] the name of the <code>INotification</code> to remove the <code>ICommand</code> mapping for
    def remove_command(notification_name)
      @controller&.remove_command(notification_name)
    end

    # Register an <code>IProxy</code> with the <code>Model</code> by name.
    #
    # @param proxy [IProxy] the <code>IProxy</code> instance to be registered with the <code>Model</code>.
    def register_proxy(proxy)
      @model&.register_proxy(proxy)
    end

    # Retrieve an <code>IProxy</code> from the <code>Model</code> by name.
    #
    # @param proxy_name [String] the name of the proxy to be retrieved.
    # @return [IProxy, nil] the <code>IProxy</code> instance previously registered with the given <code>proxy_name</code>, or nil if not found.
    def retrieve_proxy(proxy_name)
      @model&.retrieve_proxy(proxy_name)
    end

    # Check if a Proxy is registered
    #
    # @param proxy_name [String] the name of the Proxy
    # @return [Boolean] whether a Proxy is currently registered with the given <code>proxyName</code>.
    def has_proxy?(proxy_name)
      !!@model&.has_proxy?(proxy_name)
    end

    # Remove an <code>IProxy</code> from the <code>Model</code> by name.
    #
    # @param proxy_name [String] the <code>IProxy</code> to remove from the <code>Model</code>.
    # @return [IProxy, nil] the <code>IProxy</code> that was removed from the <code>Model</code>, or nil if none was found.
    def remove_proxy(proxy_name)
      @model&.remove_proxy(proxy_name)
    end

    # Register an <code>IMediator</code> with the <code>View</code>.
    #
    # @param mediator [IMediator] a reference to the <code>IMediator</code>
    def register_mediator(mediator)
      @view&.register_mediator(mediator)
    end

    # Retrieve an <code>IMediator</code> from the <code>View</code>.
    #
    # @param mediator_name [String] the name of the <code>IMediator</code> to retrieve
    # @return [IMediator, nil] the <code>IMediator</code> previously registered with the given <code>mediator_name</code>, or nil if not found
    def retrieve_mediator(mediator_name)
      @view&.retrieve_mediator(mediator_name)
    end

    # Check if a Mediator is registered or not
    #
    # @param mediator_name [String] the name of the Mediator
    # @return [Boolean] whether a Mediator is registered with the given <code>mediator_name</code>.
    def has_mediator?(mediator_name)
      !!@view&.has_mediator?(mediator_name)
    end

    # Remove an <code>IMediator</code> from the <code>View</code>.
    #
    # @param mediator_name [String] name of the <code>IMediator</code> to be removed.
    # @return [IMediator, nil] the <code>IMediator</code> that was removed from the <code>View</code>, or nil if none found.
    def remove_mediator(mediator_name)
      @view&.remove_mediator(mediator_name)
    end

    # Notify <code>Observer</code>s.
    #
    # This method is left public mostly for backward compatibility
    # and to allow you to send custom notification classes using the facade.
    #
    # Usually you should call <code>send_notification</code>
    # and pass the parameters, never having to
    # construct the notification yourself.
    #
    # @param notification [INotification] the notification to have the <code>View</code> notify <code>Observers</code> of.
    def notify_observers(notification)
      @view&.notify_observers(notification)
    end

    # Create and send an <code>INotification</code>.
    #
    # Keeps us from having to construct new notification instances in our implementation code.
    #
    # @param name [String] the name of the notification to send
    # @param body [Object, nil] the body of the notification (optional)
    # @param type [String, nil] the type of the notification (optional)
    def send_notification(name, body = nil, type = nil)
      notify_observers(Notification.new(name, body, type))
    end

    # Set the Multiton key for this facade instance.
    #
    # This is not meant to be called directly. It is invoked internally by the
    # constructor when <code>get_instance</code> is called. However, it must be public
    # to implement <code>INotifier</code>.
    #
    # @param key [String] the multiton key for this instance
    def initialize_notifier(key)
      @multiton_key = key
    end


  end

end
