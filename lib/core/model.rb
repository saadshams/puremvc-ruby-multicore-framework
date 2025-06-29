# frozen_string_literal: true
# typed: true

# model.rb
# PureMVC Ruby Multicore
#
# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

module PureMVC
  # A Multiton <code>IModel</code> implementation.
  #
  # In PureMVC, the <code>Model</code> class provides access to model objects (Proxies) by named lookup.
  #
  # The <code>Model</code> assumes these responsibilities:
  #
  # - Maintains a cache of <code>IProxy</code> instances.
  # - Provides methods for registering, retrieving, and removing <code>IProxy</code> instances.
  #
  # Your application must register <code>IProxy</code> instances with the <code>Model</code>. Typically,
  # an <code>ICommand</code> is used to create and register <code>IProxy</code> instances after the <code>Facade<code>
  # has initialized the Core actors.
  #
  # @see Proxy
  # @see IProxy
  class Model

    # Message Constants
    MULTITON_MSG = "Model instance for this Multiton key already constructed!"
    private_constant :MULTITON_MSG

    class << self
      # The Multiton IModel instanceMap.
      # @return [Hash{String => IModel}]
      def instance_map = (@instance_map ||= {})

      # Mutex used to synchronize access to the instance map for thread safety.
      # @return [Mutex]
      private def mutex = (@mutex ||= Mutex.new)

      # <code>Model</code> Multiton Factory method.
      #
      # @param key [String] the unique key identifying the Multiton instance
      # @param factory [^(String) -> IModel] the unique key passed to the factory block
      # @return [IModel] the instance for this Multiton key
      def get_instance(key, &factory)
        mutex.synchronize do
          instance_map[key] ||= factory.call(key)
        end
      end

      # Remove an IModel instance
      #
      # @param key [String] the multiton key of the IModel instance to remove
      def remove_model(key)
        mutex.synchronize do
          instance_map.delete(key)
        end
      end
    end

    # Constructor.
    #
    # This <code>IModel</code> implementation is a Multiton,
    # so you should not call the constructor directly, but instead call
    # the static Multiton Factory method <code>PureMVC::Model.get_instance(key) { |key| PureMVC::Model.new(key) }</code>.
    #
    # @param key [String]
    # @raise [RuntimeError] Error if an instance for this Multiton key has already been constructed.
    def initialize(key)
      raise MULTITON_MSG if self.class.instance_map[key]
      self.class.instance_map[key] = self
      @multiton_key = key
      @proxy_map = {}
      @proxy_mutex = Mutex.new
      initialize_model
    end

    # Initialize the <code>Model</code> instance.
    #
    # Called automatically by the constructor, this
    # is your opportunity to initialize the Multiton
    # instance in your subclass without overriding the
    # constructor.
    protected def initialize_model

    end

    # Register an <code>IProxy</code> with the <code>Model</code>.
    #
    # @param proxy [_IProxy] an <code>IProxy</code> to be held by the <code>Model</code>.
    def register_proxy(proxy)
      proxy.initialize_notifier(@multiton_key)
      @proxy_mutex.synchronize do
        @proxy_map[proxy.name] = proxy
      end
      proxy.on_register
    end

    # Retrieve an <code>IProxy</code> from the <code>Model</code>.
    #
    # @param proxy_name [String] the name of the proxy to retrieve.
    # @return [_IProxy, nil] the <code>IProxy</code> instance previously registered with the given <code>proxy_name</code>, or nil if none found.
    def retrieve_proxy(proxy_name)
      @proxy_mutex.synchronize do
        @proxy_map[proxy_name]
      end
    end

    # Check if a Proxy is registered.
    #
    # @param proxy_name [String] the name of the proxy to check.
    # @return [Boolean] whether a Proxy is currently registered with the given <code>proxy_name</code>.
    def has_proxy?(proxy_name)
      @proxy_mutex.synchronize do
        @proxy_map.has_key?(proxy_name)
      end
    end

    # Remove an <code>IProxy</code> from the <code>Model</code>.
    #
    # @param proxy_name [String] name of the <code>IProxy</code> instance to be removed.
    # @return [_IProxy, nil] the <code>IProxy</code> that was removed from the <code>Model</code>, or nil if none found.
    def remove_proxy(proxy_name)
      # @type var proxy: _IProxy?
      proxy = nil
      @proxy_mutex.synchronize do
        proxy = @proxy_map.delete(proxy_name)
      end
      proxy&.on_remove
      proxy
    end

  end
end
