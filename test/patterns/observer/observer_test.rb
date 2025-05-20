# frozen_string_literal: true

# observer_test.rb
# PureMVC Ruby Multicore

# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

require 'minitest/autorun'
require_relative '../../../src/puremvc'

class ObserverTest < Minitest::Test
  def setup
    @observer_test_var = nil
  end

  def test_observer_accessors
    observer = PureMVC::Observer.new(nil, nil)
    observer.context = self
    observer.notify = method(:observer_test_method)

    note = PureMVC::Notification.new("ObserverTestNote", 10)
    observer.notify_observer(note)

    assert_equal 10, @observer_test_var, "Expecting @observer_test_var = 10"
  end

  def test_compare_notify_context
    observer = PureMVC::Observer.new(method(:observer_test_method), self)

    neg_test_object = Object.new

    assert_equal false, observer.compare_notify_context?(neg_test_object), "Expecting observer.compare_notify_context(neg_test_object) == false"
    assert_equal true, observer.compare_notify_context?(self), "Expecting observer.compare_notify_context(self) == true"
  end

  def observer_test_method(notification)
    @observer_test_var = notification.body
  end
end
