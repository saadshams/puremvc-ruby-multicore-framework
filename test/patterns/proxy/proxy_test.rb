# frozen_string_literal: true

# proxy_test.rb
# PureMVC Ruby Multicore

# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

require 'minitest/autorun'
require_relative '../../../src/puremvc'

class ProxyTest < Minitest::Test
  def test_name_accessor
    proxy = PureMVC::Proxy.new
    assert_equal PureMVC::Proxy::NAME, proxy.name
    assert_nil proxy.data

    proxy = PureMVC::Proxy.new("TestProxy")
    assert_equal "TestProxy", proxy.name
    assert_nil proxy.data
  end

  def test_data_accessors
    proxy = PureMVC::Proxy.new("colors")
    proxy.data = %w[red green blue]
    data = proxy.data

    assert_equal 3, data.length, "Expecting data.length == 3"
    assert_equal "red", data[0], "Expecting data[0] == 'red'"
    assert_equal "green", data[1], "Expecting data[1] == 'green'"
    assert_equal "blue", data[2], "Expecting data[2] == 'blue'"
  end

  def test_constructor
    proxy = PureMVC::Proxy.new("colors", %w[red green blue])
    data = proxy.data

    refute_nil proxy, "Expecting proxy not nil"
    assert_equal "colors", proxy.name, "Expecting proxy.name == 'colors'"
    assert_equal 3, data.size, "Expecting data.length == 3"
    assert_equal "red", data[0], "Expecting data[0] == 'red'"
    assert_equal "green", data[1], "Expecting data[1] == 'green'"
    assert_equal "blue", data[2], "Expecting data[2] == 'blue'"
  end

end
