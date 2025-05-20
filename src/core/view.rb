# frozen_string_literal: true

# view.rb
# PureMVC Ruby Multicore

# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

require_relative '../interfaces/i_view'

module PureMVC
  class View
    include IView

    MULTITON_MSG = "View instance for this Multiton key already constructed!"
    private_constant :MULTITON_MSG

    @instance_map = {}
    @mutex = Mutex.new

    class << self
      protected attr_accessor :instance_map

      def get_instance(key, &factory)
        @mutex.synchronize do
          @instance_map[key] ||= factory.call(key)
        end
      end

      def remove_view(key)
        @mutex.synchronize do
          @instance_map.delete(key)
        end
      end
    end

    def initialize(key)
      raise MULTITON_MSG if self.class.send(:instance_map)[key]
      self.class.send(:instance_map)[key] = self
      @multiton_key = key
      @mediator_map = {}
      @observer_map = {}
      initialize_view
    end

    def initialize_view

    end

    def register_observer(notification_name, observer)
      (@observer_map[notification_name] ||= []) << observer
    end

    def notify_observers(notification)
      return unless (observers_ref = Array(@observer_map[notification.name]))
      observers = observers_ref.dup
      observers.each { | observer | observer.notify_observer(notification) }
    end

    def remove_observer(notification_name, notify_context)
      observers = @observer_map[notification_name]
      observers.reject! { |observer| observer.compare_notify_context?(notify_context) }
      @observer_map.delete(notification_name) if observers.empty?
    end

    def register_mediator(mediator)
      return if @mediator_map[mediator.name]

      mediator.initialize_notifier(@multiton_key)
      @mediator_map[mediator.name] = mediator

      interests = mediator.list_notification_interests
      if interests.any?
        observer = Observer.new(mediator.method(:handle_notification), mediator)
        interests.each { |interest| register_observer(interest, observer) }
      end

      mediator.on_register
    end

    def retrieve_mediator(mediator_name)
      @mediator_map[mediator_name]
    end

    def has_mediator?(mediator_name)
      @mediator_map.has_key?(mediator_name)
    end

    def remove_mediator(mediator_name)
      mediator = @mediator_map[mediator_name]
      return unless mediator

      interests = mediator.list_notification_interests
      interests.each { |interest| remove_observer(interest, mediator) }

      @mediator_map.delete(mediator_name)
      mediator.on_remove
      mediator
    end

  end
end
