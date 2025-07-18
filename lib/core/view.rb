# frozen_string_literal: true
# typed: true

# view.rb
# PureMVC Ruby Multicore
#
# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

module PureMVC
  # A Multiton <code>IView</code> implementation.
  #
  # In PureMVC, the <code>IView</code> class assumes these responsibilities:
  #
  # - Maintains a cache of <code>IMediator</code>instances.
  # - Provides methods for registering, retrieving, and removing <code>IMediators</code>.
  # - Notifies <code>IMediators</code>when they are registered or removed.
  # - Manages the observer lists for each <code>INotification</code>in the application.
  # - Provides a method for attaching <code>IObservers</code>to an <code>INotification</code>'s observer list.
  # - Provides a method for broadcasting an <code>INotification</code>.
  # - Notifies the <code>IObservers</code>of a given <code>INotification</code>when it is broadcast.
  #
  # @see Mediator
  # @see Observer
  # @see Notification
  class View

    MULTITON_MSG = 'View instance for this Multiton key already constructed!'
    private_constant :MULTITON_MSG

    class << self
      # The Multiton IModel instanceMap.
      # @return [Hash{String => IView}]
      def instance_map = (@instance_map ||= {})

      # Mutex used to synchronize access to the instance map for thread safety.
      # @return [Mutex]
      def mutex = (@mutex ||= Mutex.new)

      # View Multiton Factory method.
      #
      # @param key [String] the unique key identifying the Multiton instance
      # @param factory [^(String) -> _IView] the unique key passed to the factory block
      # @return [_IView] the Multiton instance of <code>View</code>
      def get_instance(key, &factory)
        mutex.synchronize do
          instance_map[key] ||= factory.call(key)
        end
      end

      # Remove an <code>IView</code> instance.
      #
      # @param key [String] the key of the <code>IView</code> instance to remove
      def remove_view(key)
        mutex.synchronize do
          instance_map.delete(key)
        end
      end

    end

    # Constructor.
    #
    # This <code>IView</code> implementation is a Multiton,
    # so you should not call the constructor directly.
    # Instead, call the static Multiton factory method <code>View.get_instance(multiton_key) { |key| View.new(key) }</code>.
    #
    # @param key [String]
    # @raise [RuntimeError] if an instance for this Multiton key has already been constructed.
    def initialize(key)
      raise MULTITON_MSG if self.class.instance_map[key]

      self.class.instance_map[key] = self
      # The Multiton Key for this Core
      # @type var multiton_key: String
      @multiton_key = key
      # Mapping of Notification names to Observer lists
      # @type var observer_map: Hash[String, Array[_IObserver]]
      @observer_map = {}
      # Mutex used to synchronize access to the observer_map
      # @type var observer_mutex: Mutex
      @observer_mutex = Mutex.new
      # Mapping of Mediator names to Mediator instances
      # @type var mediator_map: Hash[String, _IMediator]
      @mediator_map = {}
      # Mutex used to synchronize access to the mediator_map
      # @type var mediator_mutex: Mutex
      @mediator_mutex = Mutex.new
      initialize_view
    end

    # Initialize the Multiton <code>View</code> instance.
    #
    # Called automatically by the constructor, this
    # is your opportunity to initialize the Multiton
    # instance in your subclass without overriding the
    # constructor.
    def initialize_view; end

    # Register an <code>IObserver</code> to be notified
    # of <code>INotifications</code> with a given name.
    #
    # @param notification_name [String] the name of the <code>INotifications</code> to notify this <code>IObserver</code> of
    # @param observer [IObserver] the <code>IObserver</code> to register
    def register_observer(notification_name, observer)
      @observer_mutex.synchronize do
        observers = (@observer_map[notification_name] ||= [])
        observers << observer
      end
    end

    # Notify the <code>IObservers</code> for a particular <code>INotification</code>.
    #
    # All previously attached <code>IObservers</code> for this <code>INotification</code>'s
    # list are notified and are passed a reference to the <code>INotification</code> in
    # the order in which they were registered.
    #
    # @param notification [INotification] the <code>INotification</code> to notify <code>IObservers</code> of.
    def notify_observers(notification)
      # @type var observers: Array[_IObserver]?
      observers = nil
      @observer_mutex.synchronize do
        # Get a reference to the observers list for this notification name
        # Iteration safe, copy observers from reference array to working array,
        # since the reference array may change during the notification loop
        observers = @observer_map[notification.name].dup
      end
      # Notify Observers from the working array
      observers&.each { |observer| observer.notify_observer(notification) }
    end

    # Remove the observer for a given notifyContext from an observer list for a given Notification name.
    #
    # @param notification_name [String] which observer list to remove from
    # @param notify_context [Object] remove the observer with this object as its notifyContext
    def remove_observer(notification_name, notify_context)
      @observer_mutex.synchronize do
        # the observer list for the notification under inspection
        # @type var observers: Array[_IObserver]?
        observers = @observer_map[notification_name]
        # find and remove the sole Observer for the given notify_context
        # there can only be one Observer for a given notify_context
        # in any given Observer list, so remove it
        observers&.reject! { |observer| observer.compare_notify_context?(notify_context) }
        # Also, when a Notification's Observer list length falls to
        # zero, delete the notification key from the observer map
        @observer_map.delete(notification_name) if observers&.empty?
      end
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
    def register_mediator(mediator)
      # @type exists [Boolean]
      exists = false
      @mediator_mutex.synchronize do
        # do not allow re-registration (you must to removeMediator first)
        exists = @mediator_map.key?(mediator.name)
        unless exists
          # Register the Mediator for retrieval by name
          @mediator_map[mediator.name] = mediator
        end
      end

      return if exists

      mediator.initialize_notifier(@multiton_key)

      # Create Observer referencing this mediator's handleNotification method
      # @type observer [IObserver]
      observer = Observer.new(mediator.method(:handle_notification), mediator)

      # Get Notification interests, if any.
      # @type interests [Array<String>]
      interests = mediator.list_notification_interests
      # Register Mediator as Observer for its list of Notification interests
      interests.each { |interest| register_observer(interest, observer) }

      # alert the mediator that it has been registered
      mediator.on_register
    end

    # Retrieve an <code>IMediator</code> from the <code>View</code>.
    #
    # @param mediator_name [String] the name of the <code>IMediator</code> instance to retrieve.
    # @return [IMediator, nil] the <code>IMediator</code> instance previously registered with the given <code>mediatorName</code>.
    def retrieve_mediator(mediator_name)
      @mediator_mutex.synchronize do
        @mediator_map[mediator_name]
      end
    end

    # Check if a Mediator is registered or not.
    #
    # @param mediator_name [String] the name of the mediator to check.
    # @return [Boolean] whether a Mediator is registered with the given <code>mediatorName</code>.
    def has_mediator?(mediator_name)
      @mediator_mutex.synchronize do
        @mediator_map.key?(mediator_name)
      end
    end

    # Remove an <code>IMediator</code> from the <code>View</code>.
    #
    # @param mediator_name [String] name of the <code>IMediator</code> instance to be removed.
    # @return [IMediator, nil] the <code>IMediator</code> that was removed from the <code>View</code>, or nil if none found.
    def remove_mediator(mediator_name)
      # @type var mediator: _IMediator?
      mediator = nil
      @mediator_mutex.synchronize do
        # retrieve the named mediator and delete from the mediator map
        mediator = @mediator_map.delete(mediator_name)
      end
      return unless mediator

      # for every notification this mediator is interested in...
      # @type var interests: Array[String]
      interests = mediator.list_notification_interests
      # remove the observer linking the mediator
      # to the notification interest
      interests.each { |interest| remove_observer(interest, mediator) }

      # alert the mediator that it has been removed
      mediator.on_remove
      mediator
    end

  end

end
