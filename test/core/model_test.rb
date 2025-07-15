# frozen_string_literal: true

# model_test.rb
# PureMVC Ruby Multicore

# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

require 'minitest/autorun'
require_relative '../../lib/puremvc'

include PureMVC

# Test the PureMVC Model class.
class ModelTest < Minitest::Test
  # Tests the Model Multiton Factory Method
  def test_get_instance
    # Test Factory Method
    model = Model.get_instance('ModelTestKey1')  { |key| Model.new(key) }

    # test assertions
    refute_nil model, 'Expecting instance not nil'
  end

  # Tests the proxy registration and retrieval methods.
  #
  # Tests <code>register_proxy</code> and <code>retrieve_proxy</code> in the same test.
  # These methods cannot currently be tested separately
  # in any meaningful way other than to show that the
  # methods do not throw exception when called.
  def test_register_and_retrieve_proxy
    # register a proxy and retrieve it.
    model = Model.get_instance('ModelTestKey2') { |key| Model.new(key) }
    model.register_proxy(Proxy.new('colors', %w[red green blue]))
    proxy = model.retrieve_proxy('colors')
    data = proxy&.data

    # test assertions
    refute_nil data, 'Expecting data not nil'
    assert_kind_of Array, data, 'Expecting data type is Array'
    assert_equal 3, data&.length, 'Expecting data.length == 3'
    assert_equal 'red', data[0], "Expecting data[0] == 'red'"
    assert_equal 'green', data[1], "Expecting data[1] == 'green'"
    assert_equal 'blue', data[2], "Expecting data[2] == 'blue'"
  end

  # Tests the proxy removal method.
  def test_register_and_remove_proxy
    # register a proxy, remove it, then try to retrieve it
    model = Model.get_instance('ModelTestKey3') { |key| Model.new(key) }
    model.register_proxy(Proxy.new('sizes', [7, 13, 21]))

    # remove the proxy
    removed_proxy = model.remove_proxy('sizes')

    # assert that we removed the appropriate proxy
    assert_equal 'sizes', removed_proxy&.name, "Expecting removed_proxy.name == 'sizes'" # Method invocation 'name' may produce 'NoMethodError'

    # ensure that the proxy is no longer retrievable from the model
    proxy = model.retrieve_proxy('sizes')

    # test assertions
    assert_nil proxy, 'Expecting proxy is nil'
  end

  # Tests the has_proxy? Method
  def test_has_proxy
    # register a proxy
    model = Model.get_instance('ModelTestKey4') { |key| Model.new(key) }
    model.register_proxy(Proxy.new('aces', %w[clubs spades hearts diamonds]))

    # assert that the model.hasProxy method returns true
    # for that proxy name
    assert_equal true, model.has_proxy?('aces'), "Expecting model.has_proxy?('aces') == true"

    # remove the proxy
    model.remove_proxy('aces')

    # assert that the model.hasProxy method returns false
    # for that proxy name
    assert_equal false, model.has_proxy?('aces'), "Expecting model.has_proxy?('aces') == false"
  end

  # Tests that the Model calls the onRegister and onRemove methods
  def test_on_register_and_on_remove
    # Get a Multiton View instance
    model = Model.get_instance('ModelTestKey5') { |key| Model.new(key) }

    # Create and register the test mediator
    proxy = ModelTestProxy.new
    model.register_proxy(proxy)

    # assert that on_register was called, and the proxy responded by setting its data accordingly
    assert_equal ModelTestProxy::ON_REGISTER_CALLED, proxy.data, 'Expecting proxy.data == ModelTestProxy::ON_REGISTER_CALLED'

    # Remove the component
    model.remove_proxy(ModelTestProxy::NAME)

    # assert that on_remove was called, and the proxy responded by setting its data accordingly
    assert_equal ModelTestProxy::ON_REMOVE_CALLED, proxy.data, 'Expecting proxy.data == ModelTestProxy::ON_REMOVE_CALLED'
  end
end

class ModelTestProxy < Proxy

  NAME = 'ModelTestProxy'
  ON_REGISTER_CALLED = 'onRegister Called'
  ON_REMOVE_CALLED = 'onRemove Called'

  def initialize(name = nil, data = nil)
    super(NAME, '')
  end

  def on_register
    self.data = ON_REGISTER_CALLED
  end

  def on_remove
    self.data = ON_REMOVE_CALLED
  end
end
