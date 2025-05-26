# frozen_string_literal: true

# proxy_test.rb
# PureMVC Ruby Multicore

# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

require 'minitest/autorun'
require_relative '../../../src/puremvc'

# Test the PureMVC Proxy class.
#
# @see PureMVC::IProxy
# @see PureMVC::Proxy
class ProxyTest < Minitest::Test
  # Tests getting the name using Proxy class accessor method. Setting can only be done in constructor.
  def test_name_accessor
    # Create a new Proxy with a default name
    proxy = PureMVC::Proxy.new
    assert_equal PureMVC::Proxy::NAME, proxy.name

    # test assertions
    assert_nil proxy.data

    # Create a new Proxy and use constructor to set the proxy name
    proxy = PureMVC::Proxy.new("TestProxy")

    # test assertions
    assert_equal "TestProxy", proxy.name
    assert_nil proxy.data
  end

  # Tests setting and getting the data using Proxy class accessor methods.
  def test_data_accessors
    # Create a new Proxy and use accessors to set the data
    proxy = PureMVC::Proxy.new("colors")
    proxy.data = %w[red green blue]
    data = proxy.data

    # test assertions
    assert_equal 3, data.length, "Expecting data.length == 3"
    assert_equal "red", data[0], "Expecting data[0] == 'red'"
    assert_equal "green", data[1], "Expecting data[1] == 'green'"
    assert_equal "blue", data[2], "Expecting data[2] == 'blue'"
  end

  # Tests setting the name and body using the Notification class Constructor.
  def test_constructor
    # Create a new Proxy using the Constructor to set the name and data
    proxy = PureMVC::Proxy.new("colors", %w[red green blue])
    data = proxy.data

    # test assertions
    refute_nil proxy, "Expecting proxy not nil"
    assert_equal "colors", proxy.name, "Expecting proxy.name == 'colors'"
    assert_equal 3, data.size, "Expecting data.length == 3"
    assert_equal "red", data[0], "Expecting data[0] == 'red'"
    assert_equal "green", data[1], "Expecting data[1] == 'green'"
    assert_equal "blue", data[2], "Expecting data[2] == 'blue'"
  end

end
