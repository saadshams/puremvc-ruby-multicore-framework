# frozen_string_literal: true

# i_notification.rb
# PureMVC Ruby Multicore

# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

module PureMVC
  module INotification
    def name
      raise NotImplementedError, "#{self.class} must implement #name"
    end

    def body
      raise NotImplementedError, "#{self.class} must implement #body"
    end

    def type
      raise NotImplementedError, "#{self.class} must implement #type"
    end

    def to_s
      raise NotImplementedError, "#{self.class} must implement #to_s"
    end
  end
end
