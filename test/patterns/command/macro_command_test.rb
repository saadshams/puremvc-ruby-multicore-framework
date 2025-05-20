# frozen_string_literal: true

# macro_command_test.rb
# PureMVC Ruby Multicore

# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

require 'minitest/autorun'
require_relative '../../../src/puremvc'

class MacroCommandTest < Minitest::Test
  def test_macro_command_execute
    vo = MacroCommandTestVO.new(5)

    note = PureMVC::Notification.new("MacroCommendTest", vo)

    command = MacroCommandTestCommand.new
    command.execute(note)

    assert_equal 10, vo.result1, "Expecting vo.result1 == 10"
    assert_equal 25, vo.result2, "Expecting vo.result2 == 25"
  end
end

class MacroCommandTestCommand < PureMVC::MacroCommand
  def initialize_macro_command
    add_sub_command { MacroCommandSub1Command.new }
    add_sub_command { MacroCommandSub2Command.new }
  end
end

class MacroCommandSub1Command < PureMVC::SimpleCommand
  def execute(notification)
    vo = notification.body
    vo.result1 = 2 * vo.input
  end
end

class MacroCommandSub2Command < PureMVC::SimpleCommand
  def execute(notification)
    vo = notification.body
    vo.result2 = vo.input * vo.input
  end
end

class MacroCommandTestVO

  attr_accessor :input, :result1, :result2

  def initialize(input)
    @input = input
  end
end