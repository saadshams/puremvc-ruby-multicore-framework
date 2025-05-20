# frozen_string_literal: true

# i_observer.rb
# PureMVC Ruby Multicore

# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

module PureMVC
  module IObserver
    def notify_observer(notification)
      raise NotImplementedError, "#{self.class} must implement #notify_observer"
    end

    def compare_notify_context?
      raise NotImplementedError, "#{self.class} must implement #compare_notify_context?"
    end
  end
end
