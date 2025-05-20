# frozen_string_literal: true

# controller_test.rb
# PureMVC Ruby Multicore

# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

require 'minitest/autorun'
require_relative '../../src/puremvc'

class ControllerTest < Minitest::Test
  def test_get_instance
    controller = PureMVC::Controller::get_instance("ControllerTestKey1") { |key| PureMVC::Controller.new(key) }

    refute_nil controller, "Expecting instance not nil"
    assert_kind_of PureMVC::IController, controller, "Expecting instance implements IController"
  end

  def test_register_and_execute_command
    controller = PureMVC::Controller::get_instance("ControllerTestKey2") { |key| PureMVC::Controller.new(key) }
    controller.register_command("ControllerTest") { ControllerTestCommand.new }

    vo = ControllerTestVO.new(12)
    note = PureMVC::Notification.new("ControllerTest", vo)

    controller.execute_command(note)
    assert_equal 24, vo.result, "Expecting vo.result == 24"
  end

  def test_register_and_remove_command
    controller = PureMVC::Controller::get_instance("ControllerTestKey3") { |key| PureMVC::Controller.new(key) }
    controller.register_command("ControllerRemoveTest") { ControllerTestCommand.new }

    vo = ControllerTestVO.new(12)
    note = PureMVC::Notification.new("ControllerRemoveTest", vo)

    controller.execute_command(note)

    assert_equal 24, vo.result, "Expecting vo.result == 24"

    vo.result = 0

    controller.remove_command("ControllerRemoveTest")

    controller.execute_command(note)

    assert_equal 0, vo.result, "Expecting vo.result == 0"
  end

  def test_has_command
    controller = PureMVC::Controller::get_instance("ControllerTestKey4") { |key| PureMVC::Controller.new(key) }
    controller.register_command("hasCommandTest") { ControllerTestCommand.new }

    assert_equal true, controller.has_command?("hasCommandTest"), "Expecting controller.has_command?('hasCommandTest') == true"

    controller.remove_command("hasCommandTest")

    assert_equal false, controller.has_command?("hasCommandTest"), "Expecting controller.has_command?('hasCommandTest') == false"
  end

  def test_reregister_and_execute_command
    controller = PureMVC::Controller::get_instance("ControllerTestKey5") { |key| PureMVC::Controller.new(key) }
    controller.register_command("ControllerTest2") { ControllerTestCommand2.new }

    controller.remove_command("ControllerTest2")

    controller.register_command("ControllerTest2") { ControllerTestCommand2.new }

    vo = ControllerTestVO.new(12)
    note = PureMVC::Notification.new("ControllerTest2", vo)

    view = PureMVC::View.get_instance("ControllerTestKey5")

    view.notify_observers(note)

    assert_equal 24, vo.result, "Expecting vo.result == 24"

    view.notify_observers(note)

    assert_equal 48, vo.result, "Expecting vo.result == 48"
  end
end

class ControllerTestCommand < PureMVC::SimpleCommand
  def execute(notification)
    vo = notification.body

    vo.result = 2 * vo.input
  end
end

class ControllerTestCommand2 < PureMVC::SimpleCommand
  def execute(notification)
    vo = notification.body

    vo.result = vo.result + (2 * vo.input)
  end
end

class ControllerTestVO

  attr_accessor :input, :result

  def initialize(input)
    @input = input
    @result = 0
  end
end
