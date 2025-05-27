# frozen_string_literal: true

# controller.rb
# PureMVC Ruby Multicore
#
# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

require_relative '../interfaces/i_controller'

module PureMVC
  # A Multiton <code>IController</code> implementation.
  #
  # In PureMVC, the <code>Controller</code> class follows the
  # 'Command and Controller' strategy and assumes these responsibilities:
  #
  # * Remembering which <code>ICommand</code>s are intended to handle which <code>INotifications</code>.
  # * Registering itself as an <code>IObserver</code> with the <code>View</code> for each <code>INotification</code>
  #   that has an <code>ICommand</code> mapping.
  # * Creating a new instance of the proper <code>ICommand</code> to handle a given <code>INotification</code> when notified by the <code>View</code>.
  # * Calling the <code>ICommand</code>'s <code>execute</code> method, passing in the <code>INotification</code>.
  #
  # Your application must register <code>ICommands</code> with the <code>Controller</code>.
  #
  # The simplest way is to subclass <code>Facade</code>, and use its <code>initializeController</code> method
  # to add your registrations.
  #
  # @see View
  # @see Observer
  # @see Notification
  # @see SimpleCommand
  # @see MacroCommand
  class Controller
    include IController

    # Message Constants
    MULTITON_MSG = "Controller instance for this Multiton key already constructed!"
    private_constant :MULTITON_MSG

    class << self
      # The Multiton IController instanceMap.
      # @return [Hash{String => IController}]
      def instance_map = (@instance_map ||= {})

      # Mutex used to synchronize access to the instance map for thread safety.
      # @return [Mutex]
      def mutex = (@mutex ||= Mutex.new)

      # Gets an instance using the provided factory block
      #
      # @param key [String] the unique key identifying the Multiton instance
      # @param factory [Proc<(String) -> IController>] the unique key passed to the factory block
      # @return [IController] The controller instance created by the factory
      def get_instance(key, &factory)
        mutex.synchronize do
          instance_map[key] ||= factory.call(key)
        end
      end

      # Remove an IController instance
      #
      # @param key [String] the multiton key of the IController instance to remove
      # @return [void]
      def remove_controller(key)
        mutex.synchronize do
          instance_map.delete(key)
        end
      end
    end

    # Constructor.
    #
    # This IController implementation is a Multiton, so you should not call the constructor
    # directly. Instead, call the static factory method, passing the unique key for this instance:
    # <code>PureMVC::Controller.getInstance(key) { |key| PureMVC::Controller.new(key) }</code>
    #
    # @param key [String]
    # @raise [RuntimeError] if an instance for this Multiton key has already been constructed
    def initialize(key)
      raise MULTITON_MSG if self.class.instance_map[key]
      self.class.instance_map[key] = self
      # The Multiton Key for this Core
      @multiton_key = key
      # Local reference to View
      @view = nil
      # Mapping of Notification names to Command factories
      # @type Hash[String, () -> ICommand]
      @command_map = {}
      # Mutex used to synchronize access to the @command_map
      @command_mutex = Mutex.new
      initialize_controller
    end

    # Initialize the Multiton Controller instance.
    #
    # Called automatically by the constructor.
    #
    # Note that if you are using a subclass of View
    # in your application, you should also subclass Controller
    # and override the initialize_controller method in the
    # following way:
    #
    # @example
    #   # ensure that the Controller is talking to my IView implementation
    #   def initialize_controller
    #     @view = MyView::get_instance(key) { |key| MyView.new(key) }
    #   end
    #
    # @return [void]
    protected def initialize_controller
      @view = View::get_instance(@multiton_key) { |key| View.new(key) }
    end

    # Register a particular ICommand class as the handler for a particular INotification.
    #
    # If an ICommand has already been registered to handle INotifications with this name,
    # it is replaced by the new ICommand.
    #
    # The Observer for the new ICommand is only created if this is the first time
    # an ICommand has been registered for this notification name.
    #
    # @param notification_name [String] the name of the INotification
    # @param factory [Proc<() -> ICommand>] the factory to produce an instance of the ICommand
    # @return [void]
    def register_command(notification_name, &factory)
      @command_mutex.synchronize do
        if @command_map[notification_name].nil?
          @view&.register_observer(notification_name, Observer.new(method(:execute_command), self))
        end
        @command_map[notification_name] = factory
      end
    end

    # If an ICommand has previously been registered to handle the given INotification, then it is executed.
    #
    # @param notification [INotification] the notification to handle
    # @return [void]
    def execute_command(notification)
      # @type factory [() -> ICommand | nil]
      factory = nil
      @command_mutex.synchronize do
        factory = @command_map[notification.name]
      end
      return if factory.nil?

      command = factory.call
      command.initialize_notifier(@multiton_key)
      command.execute(notification)
    end

    # Check if a Command is registered for a given Notification.
    #
    # @param notification_name [String] the name of the Notification
    # @return [Boolean] whether a Command is currently registered for the given notification_name
    def has_command?(notification_name)
      @command_mutex.synchronize do
        @command_map.has_key?(notification_name)
      end
    end

    # Remove a previously registered ICommand to INotification mapping.
    #
    # @param notification_name [String] the name of the INotification to remove the ICommand mapping for
    # @return [void]
    def remove_command(notification_name)
      @command_mutex.synchronize do
        command = @command_map[notification_name]
        # if the Command is registered...
        if command
          # remove the observer
          @view&.remove_observer(notification_name, self)
          # remove the command
          @command_map.delete(notification_name)
        end
      end
    end

  end
end
