# frozen_string_literal: true

# controller_test.rb
# PureMVC Ruby Multicore

# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

require 'minitest/autorun'
require_relative '../../lib/puremvc'

include PureMVC

# Test the PureMVC Controller class.
#
# @see ControllerTestVO
# @see ControllerTestCommand
class ControllerTest < Minitest::Test
  # Tests the Controller Multiton Factory Method
  def test_get_instance
    # Test Factory Method
    controller = Controller.get_instance('ControllerTestKey1') { |key| Controller.new(key) }

    # test assertions
    refute_nil controller, 'Expecting instance not nil'
  end

  # Tests Command registration and execution.
  #
  # This test gets a Multiton <code>Controller</code> instance
  # and registers the <code>ControllerTestCommand</code> class
  # to handle 'ControllerTest' Notifications.
  #
  # It then constructs such a <code>Notification</code> and tells the
  # <code>Controller</code> to execute the associated <code>Command</code>.
  # Success is determined by evaluating a property
  # on an object passed to the <code>Command</code>, which will
  # be modified when the <code>Command</code> executes.
  def test_register_and_execute_command
    # Create the controller, register the ControllerTestCommand to handle 'ControllerTest' notes
    controller = Controller.get_instance('ControllerTestKey2') { |key| Controller.new(key) }
    controller.register_command('ControllerTest') { ControllerTestCommand.new }

    # Create a 'ControllerTest' note
    vo = ControllerTestVO.new(12)
    note = Notification.new('ControllerTest', vo)

    # Tell the controller to execute the Command associated with the note
    # the ControllerTestCommand invoked will multiply the vo.input value
    #by 2 and set the result on vo.result
    controller.execute_command(note)

    # test assertions
    assert_equal 24, vo.result, 'Expecting vo.result == 24'
  end

  # Tests Command registration and removal.
  # Tests that once a Command is registered and verified
  # working, it can be removed from the Controller.
  def test_register_and_remove_command
    # Create the controller, register the ControllerTestCommand to handle 'ControllerTest' notes
    controller = Controller.get_instance('ControllerTestKey3') { |key| Controller.new(key) }
    controller.register_command('ControllerRemoveTest') { ControllerTestCommand.new }

    # Create a 'ControllerTest' note
    vo = ControllerTestVO.new(12)
    note = Notification.new('ControllerRemoveTest', vo)

    # Tell the controller to execute the Command associated with the note
    # the ControllerTestCommand invoked will multiply the vo.input value
    # by 2 and set the result on vo.result
    controller.execute_command(note)

    # test assertions
    assert_equal 24, vo.result, 'Expecting vo.result == 24'

    # Reset result
    vo.result = 0

    # Remove the Command from the Controller
    controller.remove_command('ControllerRemoveTest')

    # Tell the controller to execute the Command associated with the
    # note. This time, it should not be registered, and our vo result
    # will not change
    controller.execute_command(note)

    # test assertions
    assert_equal 0, vo.result, 'Expecting vo.result == 0'
  end

  # Test has_command method.
  def test_has_command
    # register the ControllerTestCommand to handle 'hasCommandTest' notes
    controller = Controller.get_instance('ControllerTestKey4') { |key| Controller.new(key) }
    controller.register_command('hasCommandTest') { ControllerTestCommand.new }

    # test that hasCommand returns true for hasCommandTest notifications
    assert_equal true, controller.has_command?('hasCommandTest'), "Expecting controller.has_command?('hasCommandTest') == true"

    # Remove the Command from the Controller
    controller.remove_command('hasCommandTest')

    # test that hasCommand returns false for hasCommandTest notifications
    assert_equal false, controller.has_command?('hasCommandTest'), "Expecting controller.has_command?('hasCommandTest') == false"
  end

  # Tests Removing and Reregistering a Command
  #
  # Tests that when a <code>Command</code> is re-registered that it isn't fired twice.
  # This involves, minimally, registration with the controller but
  # notification via the <code>View</code>, rather than direct execution of
  # the <code>Controller</code>'s <code>execute_command</code> method as is done above in
  # test_register_and_remove.
  def test_reregister_and_execute_command
    # Fetch the controller, register the ControllerTestCommand2 to handle 'ControllerTest2' notes
    controller = Controller.get_instance('ControllerTestKey5') { |key| Controller.new(key) }
    controller.register_command('ControllerTest2') { ControllerTestCommand2.new }

    # Remove the Command from the Controller
    controller.remove_command('ControllerTest2')

    # Re-register the Command with the Controller
    controller.register_command('ControllerTest2') { ControllerTestCommand2.new }

    # Create a 'ControllerTest2' note
    vo = ControllerTestVO.new(12)
    note = Notification.new('ControllerTest2', vo)

    # retrieve a reference to the View from the same core.
    view = View.get_instance('ControllerTestKey5') { |key| View.new(key) }

    # send the Notification
    view.notify_observers(note)

    # test assertions
    # if the command is executed once the value will be 24
    assert_equal 24, vo.result, 'Expecting vo.result == 24'

    # Prove that accumulation works in the VO by sending the notification again
    view.notify_observers(note)

    # if the command is executed twice the value will be 48
    assert_equal 48, vo.result, 'Expecting vo.result == 48'
  end
end

# A SimpleCommand subclass used by ControllerTest.
#
# @see ControllerTest
# @see ControllerTestVO
class ControllerTestCommand < SimpleCommand
  # Fabricate a result by multiplying the input by 2
  #
  # @param notification [INotification] the note carrying the ControllerTestVO
  def execute(notification)
    vo = notification.body

    # Fabricate a result
    vo.result = 2 * vo.input
  end
end

# A SimpleCommand subclass used by ControllerTest.
#
# @see ControllerTest
# @see ControllerTestVO
class ControllerTestCommand2 < SimpleCommand
  # Fabricate a result by multiplying the input by 2 and adding to the existing result
  #
  # This tests accumulation effect that would show if the command were executed more than once.
  # @param notification [INotification] the note carrying the ControllerTestVO
  def execute(notification)
    vo = notification.body

    vo.result = vo.result + (2 * vo.input)
  end
end

# A utility class used by ControllerTest.
#
# @see ControllerTest
# @see ControllerTestCommand
class ControllerTestVO

  attr_accessor :input, :result

  # Constructor.
  #
  # @param input [Integer] the number to be fed to the ControllerTestCommand
  def initialize(input)
    @input = input
    @result = 0
  end
end
