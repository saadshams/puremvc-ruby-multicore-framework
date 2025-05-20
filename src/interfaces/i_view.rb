# frozen_string_literal: true

# i_view.rb
# PureMVC Ruby Multicore

# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

module PureMVC
  module IView
    def register_observer(notification_name, observer)
      raise NotImplementedError, "#{self.class} must implement #register_observer"
    end

    def remove_observer(notification_name, notify_context)
      raise NotImplementedError, "#{self.class} must implement #remove_observer"
    end

    def notify_observers(notification)
      raise NotImplementedError, "#{self.class} must implement #notify_observers"
    end

    def register_mediator(mediator)
      raise NotImplementedError, "#{self.class} must implement #register_mediator"
    end

    def retrieve_mediator(mediator_name)
      raise NotImplementedError, "#{self.class} must implement #retrieve_mediator"
    end

    def has_mediator?(mediator_name)
      raise NotImplementedError, "#{self.class} must implement #has_mediator?"
    end

    def remove_mediator(mediator_name)
      raise NotImplementedError, "#{self.class} must implement #remove_mediator"
    end
  end
end
