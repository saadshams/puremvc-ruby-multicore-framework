# frozen_string_literal: true

# proxy.rb
# PureMVC Ruby Multicore

# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

require_relative '../../interfaces/i_proxy'

module PureMVC
  # A base <code>IProxy</code> implementation.
  #
  # In PureMVC, <code>Proxy</code> classes are used to manage parts of the application's data model.
  #
  # A <code>Proxy</code> might simply manage a reference to a local data object, in which case
  # interacting with it might involve setting and getting of its data in a synchronous fashion.
  #
  # <code>Proxy</code> classes are also used to encapsulate the application's interaction with
  # remote services to save or retrieve data. In this case, we adopt an asynchronous idiom:
  # setting data (or calling a method) on the <code>Proxy</code> and listening for a <code>Notification</code>
  # to be sent when the <code>Proxy</code> has retrieved the data from the service.
  #
  # @see PureMVC::Model
  class Proxy < Notifier
    include IProxy

    # The name of the <code>Proxy</code>.
    NAME = "Proxy"

    # @return [String] The proxy name
    attr_reader :name

    # @return [Object] The data managed by the proxy
    attr_accessor :data

    # @param [String] name the name of the proxy (defaults to <code>NAME</code>)
    # @param [Object, nil] data optional data to be managed by the proxy
    def initialize(name = NAME, data = nil)
      @name =  name
      @data = data
    end

    # Called by the Model when the Proxy is registered
    # @return [void]
    def on_register

    end

    # Called by the Model when the Proxy is removed
    # @return [void]
    def on_remove

    end

  end
end
