# frozen_string_literal: true

# view_test.rb
# PureMVC Ruby Multicore

# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

require 'minitest/autorun'
require_relative '../../lib/puremvc'

class ViewTest < Minitest::Test

  NOTE1 = "Notification1"
  NOTE2 = "Notification2"
  NOTE3 = "Notification3"
  NOTE4 = "Notification4"
  NOTE5 = "Notification5"
  NOTE6 = "Notification6"

  attr_accessor :last_notification, :on_register_called, :on_remove_called, :counter
  # A test variable that proves the viewTestMethod was invoked by the View.
  private attr_accessor :view_test_var

  def setup
    @view_test_var = 0
    @last_notification = ""
    @on_register_called = false
    @on_remove_called = false
    @counter = 0
  end

  # Tests the View Multiton Factory Method
  def test_get_instance
    # Test Factory Method
    view = PureMVC::View.get_instance("ViewTestKey1") { |key| PureMVC::View.new(key) }

    # test assertions
    refute_nil view, "Expecting instance not nil"
  end

  def test_register_and_notify_observer
    # Get the Multiton View instance
    view = PureMVC::View.get_instance("ViewTestKey2") { |key| PureMVC::View.new(key) }

    # Create an observer, passing in notification method and context
    observer = PureMVC::Observer.new(method(:view_test_method), self)

    # Register Observer's interest in a particular Notification with the View
    view.register_observer("ViewTestNote", observer)

    # Create a ViewTestNote, setting
    # a body value, and tell the View to notify
    # Observers. Since the Observer is this class
    # and the notification method is viewTestMethod,
    # a successful notification will result in our local
    # viewTestVar being set to the value we pass in
    # on the note body.
    notification = PureMVC::Notification.new("ViewTestNote", 10)
    view.notify_observers(notification)

    # test assertions
    assert_equal 10, @view_test_var, "Expecting @view_test_var == 10"
  end

  # A utility method to test the notification of Observers by the view
  def view_test_method(notification)
    # set the local viewTestVar to the number on the event payload
    @view_test_var = notification.body
  end

  # Tests registering and retrieving a mediator with the View.
  def test_register_and_retrieve_mediator
    # Get the Multiton View instance
    view = PureMVC::View.get_instance("ViewTestKey3") { |key| PureMVC::View.new(key) }

    # Create and register the test mediator
    view_test_mediator = ViewTestMediator.new(self)
    view.register_mediator(view_test_mediator)

    # Retrieve the component
    mediator = view.retrieve_mediator(ViewTestMediator::NAME)

    # test assertions
    assert_kind_of ViewTestMediator, mediator, "Expecting mediator is ViewTestMediator"
  end

  # Tests the has_mediator Method
  def test_has_mediator
    # register a Mediator
    view = PureMVC::View.get_instance("ViewTestKey4") { |key| PureMVC::View.new(key) }

    # Create and register the test mediator
    mediator = PureMVC::Mediator.new("hasMediatorTest", self)
    view.register_mediator(mediator)

    # assert that the view.has_mediator method returns true
    # for that mediator name
    assert_equal true, view.has_mediator?("hasMediatorTest"), "Expecting view.has_mediator?('hasMediatorTest')"
    view.remove_mediator("hasMediatorTest")

    # assert that the view.hasMediator method returns false
    # for that mediator name
    assert_equal false, view.has_mediator?("hasMediatorTest"), "Expecting view.has_mediator?('hasMediatorTest')"
  end

  # Tests registering and removing a mediator
  def test_register_and_remove_mediator
    # Get the Multiton View instance
    view = PureMVC::View.get_instance("ViewTestKey5") { |key| PureMVC::View.new(key) }

    # Create and register the test mediator
    mediator = PureMVC::Mediator.new("testing", self)
    view.register_mediator(mediator)

    # Remove the component
    removed_mediator = view.remove_mediator("testing")

    # assert that we have removed the appropriate mediator
    assert_equal "testing", removed_mediator&.name, "Expecting removed_mediator.name == 'testing'"

    # assert that the mediator is no longer retrievable
    assert_nil view.retrieve_mediator('testing'), "Expecting view.retrieve_mediator('testing') == nil"
  end

  # Tests that the View calls the on_register and on_remove methods
  def test_on_register_and_on_remove
    # Get the Multiton View instance
    view = PureMVC::View.get_instance("ViewTestKey6") { |key| PureMVC::View.new(key) }

    # Create and register the test mediator
    mediator = ViewTestMediator4.new(self)
    view.register_mediator(mediator)

    # assert that on_register was called, and the mediator responded by setting our boolean
    assert_equal true, @on_register_called, "Expecting @on_register_called == 'true'"

    # Remove the component
    view.remove_mediator(ViewTestMediator::NAME)

    # assert that the mediator is no longer retrievable
    assert_equal false, @on_remove_called, "Expecting @on_remove_called == 'false'"
  end

  # Tests successive regster and remove of same mediator.
  def test_successive_register_and_remove_mediator
    # Get the Multiton View instance
    view = PureMVC::View.get_instance("ViewTestKey7") { |key| PureMVC::View.new(key) }

    # Create and register the test mediator,
    # but not so we have a reference to it
    view.register_mediator(ViewTestMediator.new(self))

    # test that we can retrieve it
    assert_kind_of ViewTestMediator, view.retrieve_mediator(ViewTestMediator::NAME), "Expecting view.retrieve_mediator(ViewTestMediator.NAME) is ViewTestMediator"

    # Remove the Mediator
    view.remove_mediator(ViewTestMediator::NAME)

    # test that retrieving it now returns nil
    assert_nil view.retrieve_mediator(ViewTestMediator::NAME), "Expecting view.retrieve_mediator(ViewTestMediator::NAME) == nil"

    # test that removing the mediator again once its gone doesn't cause crash
    assert_nil view.remove_mediator(ViewTestMediator::NAME), "Expecting view.remove_mediator(ViewTestMediator::NAME) doesn't crash"

    # Create and register another instance of the test mediator
    view.register_mediator(ViewTestMediator.new(self))

    assert_kind_of ViewTestMediator, view.retrieve_mediator(ViewTestMediator::NAME), "Expecting view.retrieve_mediator(ViewTestMediator.NAME) is ViewTestMediator"

    # Remove the Mediator
    view.remove_mediator(ViewTestMediator::NAME)

    # test that retrieving it now returns nil
    assert_nil view.retrieve_mediator(ViewTestMediator::NAME), "Expecting view.retrieve_mediator(ViewTestMediator::NAME) == nil"
  end

  # Tests registering a Mediator for 2 different notifications, removing the
  # Mediator from the View, and seeing that neither notification causes the
  # Mediator to be notified.
  def test_remove_mediator_and_subsequent_notify
    # Get the Multiton View instance
    view = PureMVC::View.get_instance("ViewTestKey8") { |key| PureMVC::View.new(key) }

    # Create and register the test mediator to be removed.
    view.register_mediator(ViewTestMediator2.new(self))

    # test that notifications work
    view.notify_observers(PureMVC::Notification.new(NOTE1))
    assert_equal NOTE1, @last_notification, "Expecting @last_notification == NOTE1"

    view.notify_observers(PureMVC::Notification.new(NOTE2))
    assert_equal NOTE2, @last_notification, "Expecting @last_notification == NOTE2"

    # Remove the Mediator
    view.remove_mediator(ViewTestMediator2::NAME)

    # test that retrieving it now returns nil
    assert_nil view.retrieve_mediator(ViewTestMediator2::NAME), "Expecting view.retrieve_mediator(ViewTestMediator2.NAME) == nil"

    # test that notifications no longer work
    # (ViewTestMediator2 is the one that sets lastNotification
    # on this component, and ViewTestMediator)
    @last_notification = nil

    view.notify_observers(PureMVC::Notification.new(NOTE1))
    refute_equal NOTE1, @last_notification, "Expecting @last_notification != NOTE1"

    # view.notify_observers(PureMVC::Notification.new(NOTE2))
    # refute_equal NOTE2, @last_notification, "Expecting @last_notification != NOTE2"
  end

  # Tests registering one of two registered Mediators and seeing
  # that the remaining one still responds.
  def test_remove_one_of_two_mediators_and_subsequent_notify
    # Get the Multiton View instance
    view = PureMVC::View.get_instance("ViewTestKey9") { |key| PureMVC::View.new(key) }

    # Create and register that responds to notifications 1 and 2
    view.register_mediator(ViewTestMediator2.new(self))

    # Create and register that responds to notification 3
    view.register_mediator(ViewTestMediator3.new(self))

    # test that all notifications work
    view.notify_observers(PureMVC::Notification.new(NOTE1))
    assert_equal NOTE1, @last_notification, "Expecting @last_notification == NOTE1"

    view.notify_observers(PureMVC::Notification.new(NOTE2))
    assert_equal NOTE2, @last_notification, "Expecting @last_notification == NOTE2"

    view.notify_observers(PureMVC::Notification.new(NOTE3))
    assert_equal NOTE3, @last_notification, "Expecting @last_notification == NOTE3"

    # Remove the Mediator that responds to 1 and 2
    view.remove_mediator(ViewTestMediator2::NAME)

    # test that retrieving it now returns nil
    assert_nil view.retrieve_mediator(ViewTestMediator2::NAME), "view.retrieve_mediator(ViewTestMediator2::NAME) == nil"

    # test that notifications no longer work
    # for notifications 1 and 2, but still work for 3
    @last_notification = nil

    view.notify_observers(PureMVC::Notification.new(NOTE1))
    refute_equal NOTE1, @last_notification, "Expecting @last_notification != NOTE1"

    view.notify_observers(PureMVC::Notification.new(NOTE2))
    refute_equal NOTE2, @last_notification, "Expecting @last_notification != NOTE2"

    view.notify_observers(PureMVC::Notification.new(NOTE3))
    assert_equal NOTE3, @last_notification, "Expecting @last_notification != NOTE3"
  end

  # Tests registering the same mediator twice.
  # A later notification should only elicit
  # one response. Also, since reregistration
  # was causing 2 observers to be created, ensure
  # that after removal of the mediator there will
  # be no further response.
  def test_mediator_reregistration
    # Get the Multiton View instance
    view = PureMVC::View.get_instance("ViewTestKey10") { |key| PureMVC::View.new(key) }

    # Create and register that responds to notification 5
    view.register_mediator(ViewTestMediator5.new(self))

    # try to register another instance of that mediator (uses the same NAME constant).
    view.register_mediator(ViewTestMediator5.new(self))

    # test that the counter is only incremented once (mediator 5's response)
    @counter = 0
    view.notify_observers(PureMVC::Notification.new(NOTE5))
    assert_equal 1, @counter, "Expecting @counter == 1"

    # Remove the Mediator
    view.remove_mediator(ViewTestMediator5::NAME)

    # test that retrieving it now returns nil
    assert_nil view.retrieve_mediator(ViewTestMediator5::NAME), "Expecting view.retrieve_mediator(ViewTestMediator5::NAME) == nil"

    # test that the counter is no longer incremented
    @counter = 0
    view.notify_observers(PureMVC::Notification.new(NOTE5))
    assert_equal 0, @counter, "Expecting @counter == 0"
  end

  def test_modify_observer_list_during_notification
    # Get the Multiton View instance
    view = PureMVC::View.get_instance("ViewTestKey11") { |key| PureMVC::View.new(key) }

    # Create and register several mediator instances that respond to notification 6
    # by removing themselves, which will cause the observer list for that notification
    # to change. versions prior to MultiCore Version 2.0.5 will see every other mediator
    # fails to be notified.
    view.register_mediator(ViewTestMediator6.new("ViewTestMediator6/1", self))
    view.register_mediator(ViewTestMediator6.new("ViewTestMediator6/2", self))
    view.register_mediator(ViewTestMediator6.new("ViewTestMediator6/3", self))
    view.register_mediator(ViewTestMediator6.new("ViewTestMediator6/4", self))
    view.register_mediator(ViewTestMediator6.new("ViewTestMediator6/5", self))
    view.register_mediator(ViewTestMediator6.new("ViewTestMediator6/6", self))
    view.register_mediator(ViewTestMediator6.new("ViewTestMediator6/7", self))
    view.register_mediator(ViewTestMediator6.new("ViewTestMediator6/8", self))

    # clear the counter
    @counter = 0

    # Send the notification. Each of the above mediators will respond by removing
    # themselves and incrementing the counter by 1. This should leave us with a
    # count of 8, since 8 mediators will respond.
    view.notify_observers(PureMVC::Notification.new(NOTE6))
    # verify the count is correct
    assert_equal 8, @counter, "Expecting @counter == 8"

    # clear the counter
    @counter = 0
    view.notify_observers(PureMVC::Notification.new(NOTE6))
    # verify the count is 0
    assert_equal 0, @counter, "Expecting @counter == 0"
  end

end

# A Mediator class used by ViewTest.
#
# @ see ViewTest
class ViewTestMediator < PureMVC::Mediator
  # The Mediator name
  NAME = "ViewTestMediator"

  # Constructor
  def initialize(view)
    super(NAME, view)
  end

  def list_notification_interests
    # be sure that the mediator has some Observers created
    #  to test removeMediator
    %w[ABC, DEF, GHI]
  end
end

# A Mediator class used by ViewTest.
#
# @ see ViewTest
class ViewTestMediator2 < PureMVC::Mediator
  # The Mediator name
  NAME = "ViewTestMediator2"

  # Constructor
  def initialize(view)
    super(NAME, view)
  end

  # be sure that the mediator has some Observers created
  # to test remove_mediator
  def list_notification_interests
    [ViewTest::NOTE1, ViewTest::NOTE2]
  end

  def handle_notification(notification)
    self.view.last_notification = notification.name
  end
end

# A Mediator class used by ViewTest.
#
# @ see ViewTest
class ViewTestMediator3 < PureMVC::Mediator
  # The Mediator name
  NAME = "ViewTestMediator3"

  # Constructor
  def initialize(view = nil)
    super(NAME, view)
  end

  def list_notification_interests
    # be sure that the mediator has some Observers created
    #  to test remove_mediator
    [ViewTest::NOTE3]
  end

  def handle_notification(notification)
    self.view.last_notification = notification.name
  end
end

# A Mediator class used by ViewTest.
#
# @ see ViewTest
class ViewTestMediator4 < PureMVC::Mediator
  # The Mediator name
  NAME = "ViewTestMediator4"

  # Constructor
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

# A Mediator class used by ViewTest.
#
# @ see ViewTest
class ViewTestMediator5 < PureMVC::Mediator
  # The Mediator name
  NAME = "ViewTestMediator5"

  # Constructor
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

# A Mediator class used by ViewTest.
#
# @ see ViewTest
class ViewTestMediator6 < PureMVC::Mediator
  # he Mediator base name
  NAME = "ViewTestMediator6"

  # Constructor
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
