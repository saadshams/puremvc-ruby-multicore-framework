# frozen_string_literal: true

# facade_test.rb
# PureMVC Ruby Multicore

# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

require 'minitest/autorun'
require_relative '../../../lib/puremvc'

include PureMVC

# Test the PureMVC Facade class.
#
# @see FacadeTestVO
# @see FacadeTestCommand
class FacadeTest < Minitest::Test
  # Tests the Facade Multiton Factory Method
  def test_get_instance
    # Test Factory Method
    facade = Facade.get_instance('FacadeTestKey1') { |key| Facade.new(key) }

    # test assertions
    refute_nil facade, 'Expecting instance not nil'
    assert_kind_of Facade, facade, 'Expecting instance implements IFacade'
  end

  # Tests Command registration and execution via the Facade.
  #
  # This test gets a Multiton Facade instance
  # and registers the FacadeTestCommand class
  # to handle 'FacadeTest' Notifications.
  #
  # It then sends a notification using the Facade.
  # Success is determined by evaluating
  # a property on an object placed in the body of
  # the Notification, which will be modified by the Command.
  def test_register_command_and_send_notification
    # Create the Facade, register the FacadeTestCommand to
    # handle 'FacadeTest' notifications
    facade = Facade.get_instance('FacadeTestKey2') { |key| Facade.new(key) }
    facade.register_command('FacadeTestNote') { FacadeTestCommand.new }

    # Send notification. The Command associated with the event
    # (FacadeTestCommand) will be invoked and will multiply
    # the vo.input value by 2 and set the result on vo.result
    vo = FacadeTestVO.new(32)
    facade.send_notification('FacadeTestNote', vo)

    # test assertions
    assert_equal 64, vo.result, 'Expecting vo.result == 64'
  end

  # Tests Command removal via the Facade.
  #
  # This test gets a Multiton Facade instance
  # and registers the FacadeTestCommand class
  # to handle 'FacadeTest' Notifications. Then it removes the command.
  #
  # It then sends a Notification using the Facade.
  # Success is determined by evaluating
  # a property on an object placed in the body of
  # the Notification, which will NOT be modified by the Command.
  def test_register_and_remove_command_and_send_notification
    # Create the Facade, register the FacadeTestCommand to
    # handle 'FacadeTest' events
    facade = Facade.get_instance('FacadeTestKey3') { |key| Facade.new(key) }
    facade.register_command('FacadeTestNote') { FacadeTestCommand.new }
    facade.remove_command('FacadeTestNote')

    # Send notification. The Command associated with the event
    # (FacadeTestCommand) will NOT be invoked, and will NOT multiply
    # the vo.input value by 2
    vo = FacadeTestVO.new(32)
    facade.send_notification('FacadeTestNote', vo)

    # test assertions 
    refute_equal 64, vo.result, 'Expecting vo.result != 64'
  end

  # Tests the registering and retrieving of Model proxies via the Facade.
  #
  # Tests `register_proxy` and `retrieve_proxy` in the same test.
  # These methods cannot currently be tested separately
  # in any meaningful way other than to show that the
  # methods do not throw exception when called.
  def test_facade_register_and_retrieve_proxy
    # register a proxy and retrieve it.
    facade = Facade.get_instance('FacadeTestKey4') { |key| Facade.new(key) }
    facade.register_proxy(Proxy.new('colors',  %w[red green blue]))
    proxy = facade.retrieve_proxy('colors')

    # retrieve data from proxy
    data = proxy&.data

    # test assertions
    refute_nil data, 'Expecting data not nil'
    assert_equal 3, data.size, 'Expecting data.size == 3'
    assert_equal 'red', data[0], "Expecting data[0] == 'red'"
    assert_equal 'green', data[1], "Expecting data[1] == 'green'"
    assert_equal 'blue', data[2], "Expecting data[2] == 'blue'"
  end

  # Tests the removing Proxies via the Facade.
  def test_register_and_remove_proxy
    # register a proxy, remove it, then try to retrieve it
    facade = Facade.get_instance('FacadeTestKey5') { |key| Facade.new(key) }
    proxy = Proxy.new('sizes', [7, 13, 21])
    facade.register_proxy(proxy)

    # remove the proxy
    removed_proxy = facade.remove_proxy('sizes')

    # assert that we removed the appropriate proxy
    assert_equal 'sizes', removed_proxy.name, "Expecting removed_proxy == 'sizes'"

    # make sure we can no longer retrieve the proxy from the model
    proxy = facade.retrieve_proxy('sizes')

    # test assertions
    assert_nil proxy, 'Expecting proxy is nil'
  end

  # Tests registering, retrieving and removing Mediators via the Facade.
  def test_register_retrieve_and_remove_mediator
    # register a mediator, remove it, then try to retrieve it
    facade = Facade.get_instance('FacadeTestKey6') { |key| Facade.new(key) }
    facade.register_mediator(Mediator.new(Mediator::NAME, Object.new))

    # retrieve the mediator
    refute_nil facade.retrieve_mediator(Mediator::NAME), 'Expecting mediator is not nil'

    # remove the mediator
    removed_mediator = facade.remove_mediator(Mediator::NAME)

    # assert that we have removed the appropriate mediator
    assert_equal Mediator::NAME, removed_mediator.name, 'Expecting removed_mediator.name == Mediator.NAME'

    # assert that the mediator is no longer retrievable
    assert_nil facade.retrieve_mediator(Mediator::NAME), 'Expecting facade.retrieve_mediator(Mediator::NAME)'
  end

  # Tests the has_proxy Method
  def test_has_proxy
    # register a Proxy
    facade = Facade.get_instance('FacadeTestKey7') { |key| Facade.new(key) }
    facade.register_proxy(Proxy.new('hasProxyTest', [1, 2, 3]))

    # assert that the model.has_proxy method returns true
    # for that proxy name
    assert_equal true, facade.has_proxy?('hasProxyTest'), "Expecting facade.has_proxy?('hasProxyTest') == true"
  end

  # Tests the has_mediator Method
  def test_has_mediator
    # register a Mediator
    facade = Facade.get_instance('FacadeTestKey8') { |key| Facade.new(key) }
    facade.register_mediator(Mediator.new('facadeHasMediatorTest', Object.new))

    # assert that the facade.hasMediator method returns true
    # for that mediator name
    assert_equal true, facade.has_mediator?('facadeHasMediatorTest'), "Expecting facade.has_mediator?('facadeHasMediatorTest')"

    facade.remove_mediator('facadeHasMediatorTest')

    # assert that the facade.hasMediator method returns false
    # for that mediator name
    assert_equal false, facade.has_mediator?('facadeHasMediatorTest'), "Expecting facade.has_mediator?('facadeHasMediatorTest')"
  end

  # Test has_command method.
  def facade_has_command
    # register the ControllerTestCommand to handle 'hasCommandTest' notes
    facade = Facade.get_instance('FacadeTestKey10') { |key| Facade.new(key) }
    facade.register_command('facadeHasCommandTest') { FacadeTestCommand.new }

    # test that has_command returns true for hasCommandTest notifications
    assert_equal true, facade.has_command?('facadeHasCommandTest'), "Expecting facade.has_command?('facadeHasCommandTest')"

    # Remove the Command from the Controller
    facade.remove_command('facadeHasCommandTest')

    # test that has_command returns false for hasCommandTest notifications
    assert_equal true, facade.has_command?('facadeHasCommandTest'), "Expecting facade.has_command?('facadeHasCommandTest')"
  end

  # Tests the has_core and remove_core methods
  def test_has_core_and_remove_core
    # assert that the Facade.has_core method returns false first
    assert_equal false, Facade.has_core?('FacadeTestKey11'), "Expecting Facade.has_core('FacadeTestKey11')"

    # register a Core
    Facade.get_instance('FacadeTestKey11') { |key| Facade.new(key) }

    # assert that the Facade.has_core method returns true now that a Core is registered
    assert_equal true, Facade.has_core?('FacadeTestKey11'), "Expecting Facade.has_core('FacadeTestKey11')"

    # remove the Core
    Facade.remove_core('FacadeTestKey11')

    # assert that the Facade.has_core method returns false now that the core has been removed.
    assert_equal false, Facade.has_core?('FacadeTestKey11'), "Expecting facade.has_core('FacadeTestKey11')"
  end

end

# A SimpleCommand subclass used by FacadeTest.
#
# @see FacadeTest
# @see FacadeTestVO
class FacadeTestCommand < SimpleCommand
  # Fabricate a result by multiplying the input by 2
  #
  # @param notification [Notification] the Notification carrying the FacadeTestVO
  def execute(notification)
    vo = notification.body

    # Fabricate a result
    vo.result = 2 * vo.input
  end
end

# A utility class used by FacadeTest.
#
# @see FacadeTest
# @see FacadeTestCommand
class FacadeTestVO

  attr_accessor :input, :result

  # Constructor
  #
  # @param input [Integer] the number to be fed to the FacadeTestCommand
  def initialize(input)
    @input = input
  end
end