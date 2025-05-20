# frozen_string_literal: true

# controller.rb
# PureMVC Ruby Multicore

# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

require_relative '../interfaces/i_controller'

module PureMVC
  class Controller
    include IController

    MULTITON_MSG = "Controller instance for this Multiton key already constructed!"
    private_constant :MULTITON_MSG

    @instance_map = {}
    @mutex = Mutex.new

    class << self
      protected attr_accessor :instance_map

      # Gets an instance using the provided factory block
      #
      # @param [Proc] factory A factory block that creates an {IController} instance
      # @yieldparam name [String] The name parameter passed to the factory block
      # @yieldreturn [IController] An instance of IController or its subclasses
      # @return [IController] The controller instance created by the factory
      def get_instance(key, &factory)
        @mutex.synchronize do
          @instance_map[key] ||= factory.call(key)
        end
      end

      def remove_controller(key)
        @mutex.synchronize do
          @instance_map.delete(key)
        end
      end
    end

    def initialize(key)
      raise MULTITON_MSG if self.class.send(:instance_map)[key]
      self.class.send(:instance_map)[key] = self
      @multiton_key = key
      @view = nil
      @command_map = {}
      @command_mutex = Mutex.new
      initialize_controller
    end

    protected def initialize_controller
      @view = View::get_instance(@multiton_key) { |key| PureMVC::View.new(key) }
    end

    def register_command(notification_name, &factory)
      if @command_map[notification_name].nil?
        @view&.register_observer(notification_name, Observer.new(method(:execute_command), self))
      end
      @command_map[notification_name] = factory
    end

    def execute_command(notification)
      factory = @command_map[notification.name]
      return if factory.nil?

      command = factory.call
      command.initialize_notifier(@multiton_key)
      command.execute(notification)
    end

    def has_command?(notification_name)
      @command_mutex.synchronize do
        @command_map.has_key?(notification_name)
      end
    end

    def remove_command(notification_name)
      @command_mutex.synchronize do
        command = @command_map[notification_name]
        if command
          @view&.remove_observer(notification_name, self)
          @command_map.delete(notification_name)
        end
      end
    end

  end
end
