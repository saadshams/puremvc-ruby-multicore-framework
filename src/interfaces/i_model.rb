# frozen_string_literal: true

# i_model.rb
# PureMVC Ruby Multicore

# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

module PureMVC
  module IModel
    def register_proxy(proxy)
      raise NotImplementedError, "#{self.class} must implement #register_proxy"
    end

    def retrieve_proxy(proxy_name)
      raise NotImplementedError, "#{self.class} must implement #retrieve_proxy"
    end

    def remove_proxy(proxy_name)
      raise NotImplementedError, "#{self.class} must implement #remove_proxy"
    end

    def has_proxy?(proxy_name)
      raise NotImplementedError, "#{self.class} must implement #has_proxy?"
    end
  end
end
