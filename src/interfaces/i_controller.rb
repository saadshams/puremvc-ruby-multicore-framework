# frozen_string_literal: true

# i_controller.rb
# PureMVC Ruby Multicore

# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

module PureMVC
  module IController
    def register_command(notification_name, &factory)
      raise NotImplementedError, "#{self.class} must implement #register_command"
    end

    def execute_command(notification)
      raise NotImplementedError, "#{self.class} must implement #execute_command"
    end

    def remove_command(notification_name)
      raise NotImplementedError, "#{self.class} must implement #remove_command"
    end

    def has_command?(notification_name)
      raise NotImplementedError, "#{self.class} must implement #has_command?"
    end
  end
end
