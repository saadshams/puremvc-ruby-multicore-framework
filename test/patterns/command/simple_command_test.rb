# frozen_string_literal: true

# simple_command_test.rb
# PureMVC Ruby Multicore

# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

require 'minitest/autorun'
require_relative '../../../src/puremvc'

class SimpleCommandTest < Minitest::Test
  def test_simple_command_execute
    vo = SimpleCommandTestVO.new(5)
    note = PureMVC::Notification.new("SimpleCommandTestNote", vo)
    command = SimpleCommandTestCommand.new
    command.execute(note)
    assert_equal 10, vo.result, "Expecting vo.result == 10"
  end
end

class SimpleCommandTestCommand < PureMVC::SimpleCommand
  include PureMVC::ICommand

  def execute(note)
    vo = note.body
    vo.result = vo.input * 2
  end
end

class SimpleCommandTestVO
  attr_accessor :input, :result

  def initialize(input)
    @input = input
  end
end
