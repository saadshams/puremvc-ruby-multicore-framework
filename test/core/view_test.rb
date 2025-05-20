# frozen_string_literal: true

# view_test.rb
# PureMVC Ruby Multicore

# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

require 'minitest/autorun'
require_relative '../../src/puremvc'

class ViewTest < Minitest::Test

  NOTE1 = "Notification1"
  NOTE2 = "Notification2"
  NOTE3 = "Notification3"
  NOTE4 = "Notification4"
  NOTE5 = "Notification5"
  NOTE6 = "Notification6"

  attr_accessor :last_notification, :on_register_called, :on_remove_called, :counter
  private attr_accessor :view_test_var

  def setup
    @view_test_var = 0
    @last_notification = ""
    @on_register_called = false
    @on_remove_called = false
    @counter = 0
  end

  def test_get_instance
    view = PureMVC::View.get_instance("ViewTestKey1") { |key| PureMVC::View.new(key) }

    refute_nil view, "Expecting instance not nil"
    assert_kind_of PureMVC::IView, view, "Expecting instance implements IView"
  end

  def test_register_and_notify_observer
    view = PureMVC::View.get_instance("ViewTestKey2") { |key| PureMVC::View.new(key) }

    observer = PureMVC::Observer.new(method(:view_test_method), self)

    view.register_observer("ViewTestNote", observer)

    notification = PureMVC::Notification.new("ViewTestNote", 10)
    view.notify_observers(notification)

    assert_equal 10, @view_test_var, "Expecting @view_test_var == 10"
  end

  def view_test_method(notification)
    @view_test_var = notification.body
  end

  def test_register_and_retrieve_mediator
    view = PureMVC::View.get_instance("ViewTestKey3") { |key| PureMVC::View.new(key) }
    view_test_mediator = ViewTestMediator.new(self)
    view.register_mediator(view_test_mediator)

    mediator = view.retrieve_mediator(ViewTestMediator::NAME)

    assert_kind_of ViewTestMediator, mediator, "Expecting mediator is ViewTestMediator"
  end

  def test_has_mediator
    view = PureMVC::View.get_instance("ViewTestKey4") { |key| PureMVC::View.new(key) }
    mediator = PureMVC::Mediator.new("hasMediatorTest", self)
    view.register_mediator(mediator)

    assert_equal true, view.has_mediator?("hasMediatorTest"), "Expecting view.has_mediator?('hasMediatorTest')"
    view.remove_mediator("hasMediatorTest")

    assert_equal false, view.has_mediator?("hasMediatorTest"), "Expecting view.has_mediator?('hasMediatorTest')"
  end

  def test_register_and_remove_mediator
    view = PureMVC::View.get_instance("ViewTestKey5") { |key| PureMVC::View.new(key) }

    mediator = PureMVC::Mediator.new("testing", self)
    view.register_mediator(mediator)

    removed_mediator = view.remove_mediator("testing")

    assert_equal "testing", removed_mediator.name, "Expecting removed_mediator.name == 'testing'"

    assert_nil view.retrieve_mediator('testing'), "Expecting view.retrieve_mediator('testing') == nil"
  end

  def test_on_register_and_on_remove
    view = PureMVC::View.get_instance("ViewTestKey6") { |key| PureMVC::View.new(key) }
    mediator = ViewTestMediator4.new(self)
    view.register_mediator(mediator)

    assert_equal true, @on_register_called, "Expecting @on_register_called == 'true'"

    view.remove_mediator(ViewTestMediator::NAME)

    assert_equal false, @on_remove_called, "Expecting @on_remove_called == 'false'"
  end

  def test_successive_register_and_remove_mediator
    view = PureMVC::View.get_instance("ViewTestKey7") { |key| PureMVC::View.new(key) }
    view.register_mediator(ViewTestMediator.new(self))

    assert_kind_of ViewTestMediator, view.retrieve_mediator(ViewTestMediator::NAME), "Expecting view.retrieve_mediator(ViewTestMediator.NAME) is ViewTestMediator"

    view.remove_mediator(ViewTestMediator::NAME)

    assert_nil view.retrieve_mediator(ViewTestMediator::NAME), "Expecting view.retrieve_mediator(ViewTestMediator::NAME) == nil"

    assert_nil view.remove_mediator(ViewTestMediator::NAME), "Expecting view.remove_mediator(ViewTestMediator::NAME) doesn't crash"

    view.register_mediator(ViewTestMediator.new(self))

    assert_kind_of ViewTestMediator, view.retrieve_mediator(ViewTestMediator::NAME), "Expecting view.retrieve_mediator(ViewTestMediator.NAME) is ViewTestMediator"

    view.remove_mediator(ViewTestMediator::NAME)

    assert_nil view.retrieve_mediator(ViewTestMediator::NAME), "Expecting view.retrieve_mediator(ViewTestMediator::NAME) == nil"
  end

  def test_remove_mediator_and_subsequent_notify
    view = PureMVC::View.get_instance("ViewTestKey8") { |key| PureMVC::View.new(key) }

    view.register_mediator(ViewTestMediator2.new(self))

    view.notify_observers(PureMVC::Notification.new(NOTE1))

    assert_equal NOTE1, @last_notification, "Expecting @last_notification == NOTE1"

    view.notify_observers(PureMVC::Notification.new(NOTE2))

    assert_equal NOTE2, @last_notification, "Expecting @last_notification == NOTE2"

    view.remove_mediator(ViewTestMediator2::NAME)

    assert_nil view.retrieve_mediator(ViewTestMediator2::NAME), "Expecting view.retrieve_mediator(ViewTestMediator2.NAME) == nil"

    @last_notification = nil

    view.notify_observers(PureMVC::Notification.new(NOTE1))

    refute_equal NOTE1, @last_notification, "Expecting @last_notification != NOTE1"

    view.notify_observers(PureMVC::Notification.new(NOTE2))
    refute_equal NOTE2, @last_notification, "Expecting @last_notification != NOTE2"
  end

  def test_remove_one_of_two_mediators_and_subsequent_notify
    view = PureMVC::View.get_instance("ViewTestKey9") { |key| PureMVC::View.new(key) }

    view.register_mediator(ViewTestMediator2.new(self))
    view.register_mediator(ViewTestMediator3.new(self))

    view.notify_observers(PureMVC::Notification.new(NOTE1))
    assert_equal NOTE1, @last_notification, "Expecting @last_notification == NOTE1"

    view.notify_observers(PureMVC::Notification.new(NOTE2))
    assert_equal NOTE2, @last_notification, "Expecting @last_notification == NOTE2"

    view.notify_observers(PureMVC::Notification.new(NOTE3))
    assert_equal NOTE3, @last_notification, "Expecting @last_notification == NOTE3"

    view.remove_mediator(ViewTestMediator2::NAME)

    assert_nil view.retrieve_mediator(ViewTestMediator2::NAME), "view.retrieve_mediator(ViewTestMediator2::NAME) == nil"

    @last_notification = nil

    view.notify_observers(PureMVC::Notification.new(NOTE1))
    refute_equal NOTE1, @last_notification, "Expecting @last_notification != NOTE1"

    view.notify_observers(PureMVC::Notification.new(NOTE2))
    refute_equal NOTE2, @last_notification, "Expecting @last_notification != NOTE2"

    view.notify_observers(PureMVC::Notification.new(NOTE3))
    assert_equal NOTE3, @last_notification, "Expecting @last_notification != NOTE3"
  end

  def test_mediator_reregistration
    view = PureMVC::View.get_instance("ViewTestKey10") { |key| PureMVC::View.new(key) }

    view.register_mediator(ViewTestMediator5.new(self))

    view.register_mediator(ViewTestMediator5.new(self))

    @counter = 0
    view.notify_observers(PureMVC::Notification.new(NOTE5))
    assert_equal 1, @counter, "Expecting @counter == 1"

    view.remove_mediator(ViewTestMediator5::NAME)

    assert_nil view.retrieve_mediator(ViewTestMediator5::NAME), "Expecting view.retrieve_mediator(ViewTestMediator5::NAME) == nil"

    @counter = 0
    view.notify_observers(PureMVC::Notification.new(NOTE5))
    assert_equal 0, @counter, "Expecting @counter == 0"
  end

  def test_modify_observer_list_during_notification
    view = PureMVC::View.get_instance("ViewTestKey11") { |key| PureMVC::View.new(key) }

    view.register_mediator(ViewTestMediator6.new("ViewTestMediator6/1", self))
    view.register_mediator(ViewTestMediator6.new("ViewTestMediator6/2", self))
    view.register_mediator(ViewTestMediator6.new("ViewTestMediator6/3", self))
    view.register_mediator(ViewTestMediator6.new("ViewTestMediator6/4", self))
    view.register_mediator(ViewTestMediator6.new("ViewTestMediator6/5", self))
    view.register_mediator(ViewTestMediator6.new("ViewTestMediator6/6", self))
    view.register_mediator(ViewTestMediator6.new("ViewTestMediator6/7", self))
    view.register_mediator(ViewTestMediator6.new("ViewTestMediator6/8", self))

    @counter = 0
    view.notify_observers(PureMVC::Notification.new(NOTE6))
    assert_equal 8, @counter, "Expecting @counter == 8"

    @counter = 0
    view.notify_observers(PureMVC::Notification.new(NOTE6))
    assert_equal 0, @counter, "Expecting @counter == 0"
  end

end

class ViewTestMediator < PureMVC::Mediator
  NAME = "ViewTestMediator"

  def initialize(view)
    super(NAME, view)
  end

  def list_notification_interests
    %w[ABC, DEF, GHI]
  end
end

class ViewTestMediator2 < PureMVC::Mediator
  NAME = "ViewTestMediator2"

  def initialize(view)
    super(NAME, view)
  end

  def list_notification_interests
    [ViewTest::NOTE1, ViewTest::NOTE2]
  end

  def handle_notification(notification)
    self.view.last_notification = notification.name
  end
end

class ViewTestMediator3 < PureMVC::Mediator
  NAME = "ViewTestMediator3"

  def initialize(view = nil)
    super(NAME, view)
  end

  def list_notification_interests
    [ViewTest::NOTE3]
  end

  def handle_notification(notification)
    self.view.last_notification = notification.name
  end
end

class ViewTestMediator4 < PureMVC::Mediator
  NAME = "ViewTestMediator4"

  def initialize(view)
    super(NAME, view)
  end

  def on_register
    self.view.on_register_called = true
  end

  def on_remove
    self.view.on_remove_called = true
  end
end

class ViewTestMediator5 < PureMVC::Mediator
  NAME = "ViewTestMediator5"

  def initialize(view)
    super(NAME, view)
  end

  def list_notification_interests
    [ViewTest::NOTE5]
  end

  def handle_notification(notification)
    self.view.counter += 1
  end
end

class ViewTestMediator6 < PureMVC::Mediator
  NAME = "ViewTestMediator6"

  def initialize(name, view)
    super(name, view)
  end

  def list_notification_interests
    [ViewTest::NOTE6]
  end

  def handle_notification(notification)
    facade.remove_mediator(self.name)
  end

  def on_remove
    self.view.counter += 1
  end
end
