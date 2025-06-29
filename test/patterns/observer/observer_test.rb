# frozen_string_literal: true

# observer_test.rb
# PureMVC Ruby Multicore

# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

require 'minitest/autorun'
require_relative '../../../lib/puremvc'

include PureMVC

# Tests PureMVC Observer class.
#
# Since the Observer encapsulates the interested object's
# callback information.
class ObserverTest < Minitest::Test
  def setup
    # A test variable that proves the notify method was
    # executed with 'self' as its execution context
    @observer_test_var = nil
  end

  # Tests observer class when initialized by accessor methods.
  def test_observer_accessors
    # Create an observer with null args, then
    # use accessors to set notification method and context
    observer = Observer.new
    observer.context = self
    observer.notify = method(:observer_test_method)

    # create a test event, setting a payload value and notify
    # the observer with it. since the observer is this class
    # and the notification method is observerTestMethod,
    # a successful notification will result in our local
    # observerTestVar being set to the value we pass in
    # on the note body.
    note = Notification.new("ObserverTestNote", 10)
    observer.notify_observer(note)

    # test assertions
    assert_equal 10, @observer_test_var, "Expecting @observer_test_var = 10"
  end

  def test_observer_constructor
    # Create observer passing in notification method and context
    observer = Observer.new(method(:observer_test_method), self)

    # create a test note, setting a body value and notify
    # the observer with it. since the observer is this class
    # and the notification method is observerTestMethod,
    # a successful notification will result in our local
    # observerTestVar being set to the value we pass in
    # on the note body.

    note = Notification.new("ObserverTestNote", 5)
    observer.notify_observer(note)

    # test assertions
    assert_equal 5, @observer_test_var, "Expecting @observer_test_var = 5"
  end

  # Tests the compareNotifyContext method of the Observer class
  def test_compare_notify_context
    # Create an observer passing in notification method and context
    observer = Observer.new(method(:observer_test_method), self)

    neg_test_object = Object.new

    # test assertions
    assert_equal false, observer.compare_notify_context?(neg_test_object), "Expecting observer.compare_notify_context(neg_test_object) == false"
    assert_equal true, observer.compare_notify_context?(self), "Expecting observer.compare_notify_context(self) == true"
  end

  # A function that is used as the observer notification
  # method. It multiplies the input number by the
  # observerTestVar value
  def observer_test_method(notification)
    @observer_test_var = notification.body
  end
end
