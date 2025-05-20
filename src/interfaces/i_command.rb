# frozen_string_literal: true

# i_command.rb
# PureMVC Ruby Multicore

# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

module PureMVC
  module ICommand
    def execute(notification)
      raise NotImplementedError, "#{self.class} must implement #execute"
    end
  end
end
