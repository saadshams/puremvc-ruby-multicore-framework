# frozen_string_literal: true

# notifier_test.rb
# PureMVC Ruby Multicore

# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

require 'minitest/autorun'
require_relative '../../../src/puremvc'

class NotifierTest < Minitest::Test
  def test_notifier
    notifier = PureMVC::Notifier.new
    notifier.initialize_notifier("FacadeTestKey1")

    refute_nil notifier, "Expecting instance not nil"
    refute_nil notifier.facade, "Expecting notifier.facade not nil"
  end

  def test_register_and_execute_command
    notifier = PureMVC::Notifier.new
    notifier.initialize_notifier("FacadeTestKey2")
    notifier.facade.register_command("NotifierTest") { NotifierTestCommand.new }

    vo = NotifierTestVO.new(12)
    note = PureMVC::Notification.new("NotifierTest", vo)
    notifier.facade.send_notification(note.name, note.body, note.type)

    assert_equal 24, vo.result, "Expecting vo.result == 24"
  end
end

class NotifierTestCommand < PureMVC::SimpleCommand
  def execute(notification)
    vo = notification.body
    vo.result = 2 * vo.input
  end
end

class NotifierTestVO

  attr_accessor :input, :result

  def initialize(input)
    @input = input
  end
end
