# frozen_string_literal: true
require 'interface'

# i_proxy.rb
# PureMVC Ruby Multicore
#
# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

module PureMVC
  # The interface definition for a PureMVC Proxy.
  #
  # In PureMVC, <code>IProxy</code> implementors assume these responsibilities:
  # - Implement a common method which returns the name of the Proxy.
  # - Provide methods for setting and getting the data object.
  #
  # Additionally, <code>IProxy</code>s typically:
  # - Maintain references to one or more pieces of model data.
  # - Provide methods for manipulating that data.
  # - Generate <code>INotifications</code> when their model data changes.
  # - Expose their name called <code>NAME</code>, if they are not instantiated multiple times.
  # - Encapsulate interaction with local or remote services used to fetch and persist model data.
  #
  # @see INotifier
  IProxy = interface {
    required_methods :name,
                     :data,
                     :on_register,
                     :on_remove

    # @return [String] The proxy name
    def name
      raise NotImplementedError, "#{self.class} must implement #name"
    end

    # @return [Object, nil] The data managed by the proxy, or nil if none set.
    def data
      raise NotImplementedError, "#{self.class} must implement #data"
    end

    # Called by the Model when the Proxy is registered
    # @return [void]
    def on_register
      raise NotImplementedError, "#{self.class} must implement #on_register"
    end

    # Called by the Model when the Proxy is removed
    # @return [void]
    def on_remove
      raise NotImplementedError, "#{self.class} must implement #on_remove"
    end
  }
end
