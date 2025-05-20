# frozen_string_literal: true

# facade.rb
# PureMVC Ruby Multicore

# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

require_relative '../../interfaces/i_facade'

module PureMVC
  class Facade
    include IFacade

    MULTITON_MSG = "Facade instance for this Multiton key already constructed!"
    private_constant :MULTITON_MSG

    @instance_map = {}
    @mutex = Mutex.new

    class << self
      # @!attribute [r] instance_map
      # @return [Hash] A map of instances keyed by multiton keys.
      protected attr_accessor :instance_map

      def get_instance(key, &factory)
        @mutex.synchronize do
          @instance_map[key] ||= factory.call(key)
        end
      end

      def has_core(key)
        @instance_map.key?(key)
      end

      def remove_core(key)
        @mutex.synchronize do
          Model::remove_model(key)
          View::remove_view(key)
          Controller::remove_controller(key)
          @instance_map.delete(key)
        end
      end
    end

    def initialize(key)
      raise MULTITON_MSG if self.class.send(:instance_map)[key]
      self.class.send(:instance_map)[key] = self
      @model = @view = @controller = nil
      initialize_notifier(key)
      initialize_facade
    end

    def initialize_facade
      initialize_model
      initialize_controller
      initialize_view
    end

    def initialize_controller
      @controller = Controller::get_instance(@multiton_key) { |key| Controller.new(key) }
    end

    def initialize_model
      @model = Model::get_instance(@multiton_key) { |key| Model.new(key) }
    end

    def initialize_view
      @view = View::get_instance(@multiton_key) { |key| View.new(key) }
    end

    def initialize_notifier(key)
      @multiton_key = key
    end

    def register_command(notification_name, &factory)
      @controller&.register_command(notification_name, &factory)
    end

    def has_command?(notification_name)
      @controller&.has_command?(notification_name)
    end

    def remove_command(notification_name)
      @controller&.remove_command(notification_name)
    end

    def register_proxy(proxy)
      @model&.register_proxy(proxy)
    end

    def retrieve_proxy(proxy)
      @model&.retrieve_proxy(proxy)
    end

    def has_proxy?(notification_name)
      !!@model&.has_proxy?(notification_name)
    end

    def remove_proxy(proxy_name)
      @model&.remove_proxy(proxy_name)
    end

    def register_mediator(mediator)
      @view&.register_mediator(mediator)
    end

    def retrieve_mediator(mediator)
      @view&.retrieve_mediator(mediator)
    end

    def has_mediator?(mediator)
      !!@view&.has_mediator?(mediator)
    end

    def remove_mediator(mediator)
      @view&.remove_mediator(mediator)
    end

    def notify_observers(notification)
      @view&.notify_observers(notification)
    end

    def send_notification(name, body = nil, type = nil)
      notify_observers(Notification.new(name, body, type))
    end

  end

end
