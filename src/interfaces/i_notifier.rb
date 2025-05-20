# frozen_string_literal: true

# i_notifier.rb
# PureMVC Ruby Multicore

# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

module PureMVC
  module INotifier
    def send_notification(name, body = nil, type = nil)
      raise NotImplementedError, "#{self.class} must implement #send_notification"
    end

    def initialize_notifier(key)
      raise NotImplementedError, "#{self.class} must implement #initialize_notifier"
    end
  end
end
