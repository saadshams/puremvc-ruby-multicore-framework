# frozen_string_literal: true

# model.rb
# PureMVC Ruby Multicore

# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

require_relative '../interfaces/i_model'

module PureMVC
  class Model
    include IModel

    MULTITON_MSG = "Model instance for this Multiton key already constructed!"
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

      def remove_model(key)
        @mutex.synchronize do
          @instance_map.delete(key)
        end
      end
    end

    def initialize(key)
      raise MULTITON_MSG if self.class.send(:instance_map)[key]
      self.class.send(:instance_map)[key] = self
      @multiton_key = key
      @proxy_map = {}
      @proxy_mutex = Mutex.new
      initialize_model
    end

    protected def initialize_model

    end

    def register_proxy(proxy)
      @proxy_mutex.synchronize do
        proxy.initialize_notifier(@multiton_key)
        @proxy_map[proxy.name] = proxy
        proxy.on_register
      end
    end

    def retrieve_proxy(proxy_name)
      @proxy_mutex.synchronize do
        @proxy_map[proxy_name]
      end
    end

    def has_proxy?(proxy_name)
      @proxy_mutex.synchronize do
        @proxy_map.has_key?(proxy_name)
      end
    end

    def remove_proxy(proxy_name)
      @proxy_mutex.synchronize do
        proxy = @proxy_map[proxy_name]
        if proxy
          @proxy_map.delete(proxy_name)
          proxy.on_remove
        end
        proxy
      end
    end
  end
end
