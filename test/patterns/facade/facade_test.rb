# frozen_string_literal: true

# facade_test.rb
# PureMVC Ruby Multicore

# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

require 'minitest/autorun'
require_relative '../../../src/puremvc'

class FacadeTest < Minitest::Test
  def test_get_instance
    facade = PureMVC::Facade.get_instance("FacadeTestKey1") { |key| PureMVC::Facade.new(key) }

    refute_nil facade, "Expecting instance not nil"
    assert_kind_of PureMVC::Facade, facade, "Expecting instance implements IFacade"
  end

  def test_register_command_and_send_notification
    facade = PureMVC::Facade.get_instance("FacadeTestKey2") { |key| PureMVC::Facade.new(key) }
    facade.register_command("FacadeTestNote") { FacadeTestCommand.new }

    vo = FacadeTestVO.new(32)
    facade.send_notification("FacadeTestNote", vo)

    assert_equal 64, vo.result, "Expecting vo.result == 64"
  end

  def test_register_and_remove_command_and_send_notification
    facade = PureMVC::Facade.get_instance("FacadeTestKey3") { |key| PureMVC::Facade.new(key) }
    facade.register_command("FacadeTestNote") { FacadeTestCommand.new }
    facade.remove_command("FacadeTestNote")

    vo = FacadeTestVO.new(32)
    facade.send_notification("FacadeTestNote", vo)

    refute_equal 64, vo.result, "Expecting vo.result != 64"
  end

  def test_facade_register_and_retrieve_proxy
    facade = PureMVC::Facade.get_instance("FacadeTestKey4") { |key| PureMVC::Facade.new(key) }
    facade.register_proxy(PureMVC::Proxy.new("colors",  %w[red green blue]))
    proxy = facade.retrieve_proxy("colors")

    assert_kind_of PureMVC::IProxy, proxy, "Expecting proxy is IProxy"

    data = proxy.data

    refute_nil data, "Expecting data not nil"
    assert_equal 3, data.size, "Expecting data.size == 3"
    assert_equal "red", data[0], "Expecting data[0] == 'red'"
    assert_equal "green", data[1], "Expecting data[1] == 'green'"
    assert_equal "blue", data[2], "Expecting data[2] == 'blue'"
  end

  def test_register_and_remove_proxy
    facade = PureMVC::Facade.get_instance("FacadeTestKey5") { |key| PureMVC::Facade.new(key) }
    proxy = PureMVC::Proxy.new("sizes", [7, 13, 21])
    facade.register_proxy(proxy)

    removed_proxy = facade.remove_proxy("sizes")

    assert_equal "sizes", removed_proxy.name, "Expecting removed_proxy == 'sizes'"

    proxy = facade.retrieve_proxy("sizes")

    assert_nil proxy, "Expecting proxy is nil"
  end

  def test_register_retrieve_and_remove_mediator
    facade = PureMVC::Facade.get_instance("FacadeTestKey6") { |key| PureMVC::Facade.new(key) }
    facade.register_mediator(PureMVC::Mediator.new(PureMVC::Mediator::NAME, Object.new))

    refute_nil facade.retrieve_mediator(PureMVC::Mediator::NAME), "Expecting mediator is not nil"

    removed_mediator = facade.remove_mediator(PureMVC::Mediator::NAME)

    assert_equal PureMVC::Mediator::NAME, removed_mediator.name, "Expecting removed_mediator.name == PureMVC::Mediator.NAME"

    assert_nil facade.retrieve_mediator(PureMVC::Mediator::NAME), "Expecting facade.retrieve_mediator(PureMVC::Mediator::NAME)"
  end

  def test_has_proxy
    facade = PureMVC::Facade.get_instance("FacadeTestKey7") { |key| PureMVC::Facade.new(key) }
    facade.register_proxy(PureMVC::Proxy.new("hasProxyTest", [1, 2, 3]))

    assert_equal true, facade.has_proxy?("hasProxyTest"), "Expecting facade.has_proxy?('hasProxyTest') == true"
  end

  def test_has_mediator
    facade = PureMVC::Facade.get_instance("FacadeTestKey8") { |key| PureMVC::Facade.new(key) }
    facade.register_mediator(PureMVC::Mediator.new("facadeHasMediatorTest", Object.new))

    assert_equal true, facade.has_mediator?("facadeHasMediatorTest"), "Expecting facade.has_mediator?('facadeHasMediatorTest')"

    facade.remove_mediator("facadeHasMediatorTest")

    assert_equal false, facade.has_mediator?("facadeHasMediatorTest"), "Expecting facade.has_mediator?('facadeHasMediatorTest')"
  end

  def facade_has_command
    facade = PureMVC::Facade.get_instance("FacadeTestKey10") { |key| PureMVC::Facade.new(key) }
    facade.register_command("facadeHasCommandTest") { FacadeTestCommand.new }

    assert_equal true, facade.has_command?("facadeHasCommandTest"), "Expecting facade.has_command?('facadeHasCommandTest')"

    facade.remove_command("facadeHasCommandTest")

    assert_equal true, facade.has_command?('facadeHasCommandTest'), "Expecting facade.has_command?('facadeHasCommandTest')"
  end

  def test_has_core_and_remove_core
    assert_equal false, PureMVC::Facade.has_core("FacadeTestKey11"), "Expecting Facade.has_core('FacadeTestKey11')"

    facade = PureMVC::Facade.get_instance("FacadeTestKey11") { |key| PureMVC::Facade.new(key) }
    assert_equal true, PureMVC::Facade.has_core("FacadeTestKey11"), "Expecting Facade.has_core('FacadeTestKey11')"

    PureMVC::Facade.remove_core("FacadeTestKey11")

    assert_equal false, PureMVC::Facade.has_core("FacadeTestKey11"), "Expecting facade.has_core('FacadeTestKey11')"
  end

end

class FacadeTestCommand < PureMVC::SimpleCommand
  def execute(notification)
    vo = notification.body
    vo.result = 2 * vo.input
  end
end

class FacadeTestVO

  attr_accessor :input, :result

  def initialize(input)
    @input = input
  end
end