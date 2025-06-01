# frozen_string_literal: true
require 'interface'

# i_model.rb
# PureMVC Ruby Multicore
#
# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

module PureMVC
  # The interface definition for a PureMVC Model.
  #
  # In PureMVC, <code>IModel</code> implementors provide
  # access to <code>IProxy</code> objects by named lookup.
  #
  # An <code>IModel</code> assumes these responsibilities:
  #
  # - Maintain a cache of <code>IProxy</code> instances
  # - Provide methods for registering, retrieving, and removing <code>IProxy</code> instances
  IModel = interface {
    required_methods :register_proxy,
                     :retrieve_proxy,
                     :has_proxy?,
                     :remove_proxy
    # Register an <code>IProxy</code> instance with the <code>Model</code>.
    #
    # @param proxy [IProxy] an object reference to be held by the <code>Model</code>.
    def register_proxy(proxy)
      raise NotImplementedError, "#{self.class} must implement #register_proxy"
    end

    # Retrieve an <code>IProxy</code> instance from the <code>Model</code>.
    #
    # @param proxy_name [String]
    # @return [IProxy] the <code>IProxy</code> instance previously registered with the given <code>proxyName</code>.
    def retrieve_proxy(proxy_name)
      raise NotImplementedError, "#{self.class} must implement #retrieve_proxy"
    end

    # Check if a <code>Proxy</code> is registered.
    #
    # @param proxy_name [String]
    # @return [Boolean] whether a <code>Proxy</code> is currently registered with the given <code>proxyName</code>.
    def has_proxy?(proxy_name)
      raise NotImplementedError, "#{self.class} must implement #has_proxy?"
    end

    # Remove an <code>IProxy</code> instance from the <code>Model</code>.
    #
    # @param proxy_name [String] name of the <code>IProxy</code> instance to be removed.
    # @return [IProxy] the <code>IProxy</code> that was removed from the <code>Model</code>.
    def remove_proxy(proxy_name)
      raise NotImplementedError, "#{self.class} must implement #remove_proxy"
    end

  }

end
