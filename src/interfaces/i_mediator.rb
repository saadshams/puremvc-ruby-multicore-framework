# frozen_string_literal: true

# i_mediator.rb
# PureMVC Ruby Multicore

# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

module PureMVC
  module IMediator
    def name
      raise NotImplementedError, "#{self.class} must implement #name"
    end

    def data
      raise NotImplementedError, "#{self.class} must implement #data"
    end

    def on_register
      raise NotImplementedError, "#{self.class} must implement #on_register"
    end

    def on_remove
      raise NotImplementedError, "#{self.class} must implement #on_remove"
    end
  end
end
