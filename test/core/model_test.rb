# frozen_string_literal: true

# model_test.rb
# PureMVC Ruby Multicore

# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

require 'minitest/autorun'
require_relative '../../src/puremvc'

class ModelTest < Minitest::Test
  def test_get_instance
    model = PureMVC::Model.get_instance("ModelTestKey1")  { |key| PureMVC::Model.new(key) }

    refute_nil model, "Expecting instance not nil"
    assert_kind_of PureMVC::IModel, model, "Expecting instance implements IModel"
  end

  def test_register_and_retrieve_proxy
    model = PureMVC::Model.get_instance("ModelTestKey2") { |key| PureMVC::Model.new(key) }
    model.register_proxy(PureMVC::Proxy.new("colors", %w[red green blue]))
    proxy = model.retrieve_proxy("colors")
    data = proxy.data

    refute_nil data, "Expecting data not nil"
    assert_kind_of Array, data, "Expecting data type is Array"
    assert_equal 3, data.length, "Expecting data.length == 3"
    assert_equal "red", data[0], "Expecting data[0] == 'red'"
    assert_equal "green", data[1], "Expecting data[1] == 'green'"
    assert_equal "blue", data[2], "Expecting data[2] == 'blue'"
  end

  def test_register_and_remove_proxy
    model = PureMVC::Model.get_instance("ModelTestKey3") { |key| PureMVC::Model.new(key) }
    model.register_proxy(PureMVC::Proxy.new("sizes", [7, 13, 21]))

    removed_proxy = model.remove_proxy("sizes")

    assert_equal "sizes", removed_proxy.name, "Expecting removed_proxy.name == 'sizes'"

    proxy = model.retrieve_proxy("sizes")
    assert_nil proxy, "Expecting proxy is nil"
  end

  def test_has_proxy
    model = PureMVC::Model.get_instance("ModelTestKey4") { |key| PureMVC::Model.new(key) }
    model.register_proxy(PureMVC::Proxy.new("aces", %w[clubs spades hearts diamonds]))

    assert_equal true, model.has_proxy?("aces"), "Expecting model.has_proxy?('aces') == true"

    model.remove_proxy("aces")

    assert_equal false, model.has_proxy?("aces"), "Expecting model.has_proxy?('aces') == false"
  end

  def test_on_register_and_on_remove
    model = PureMVC::Model.get_instance("ModelTestKey5") { |key| PureMVC::Model.new(key) }
    proxy = ModelTestProxy.new
    model.register_proxy(proxy)

    assert_equal ModelTestProxy::ON_REGISTER_CALLED, proxy.data, "Expecting proxy.data == ModelTestProxy::ON_REGISTER_CALLED"

    model.remove_proxy(ModelTestProxy::NAME)

    assert_equal ModelTestProxy::ON_REMOVE_CALLED, proxy.data, "Expecting proxy.data == ModelTestProxy::ON_REMOVE_CALLED"
  end
end

class ModelTestProxy < PureMVC::Proxy

  NAME = "ModelTestProxy"
  ON_REGISTER_CALLED = "onRegister Called"
  ON_REMOVE_CALLED = "onRemove Called"

  def initialize(name = nil, data = nil)
    super(NAME, "")
  end

  def on_register
    self.data = ON_REGISTER_CALLED
  end

  def on_remove
    self.data = ON_REMOVE_CALLED
  end
end