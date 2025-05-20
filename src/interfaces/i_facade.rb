# frozen_string_literal: true

# i_facade.rb
# PureMVC Ruby Multicore

# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

module PureMVC
  module IFacade
    def register_proxy(proxy)
      raise NotImplementedError, "#{self.class} must implement #register_proxy"
    end

    def retrieve_proxy(proxy_name)
      raise NotImplementedError, "#{self.class} must implement #retrieve_proxy"
    end

    def has_proxy?(proxy_name)
      raise NotImplementedError, "#{self.class} must implement #has_proxy?"
    end

    def remove_proxy(proxy_name)
      raise NotImplementedError, "#{self.class} must implement #remove_proxy"
    end

    def register_command(notification_name, &factory)
      raise NotImplementedError, "#{self.class} must implement #register_command"
    end

    def has_command?(notification_name)
      raise NotImplementedError, "#{self.class} must implement #has_command?"
    end

    def remove_command(notification_name)
      raise NotImplementedError, "#{self.class} must implement #remove_command"
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

    def notify_observers(notification)
      raise NotImplementedError, "#{self.class} must implement #notify_observers"
    end

  end
end
