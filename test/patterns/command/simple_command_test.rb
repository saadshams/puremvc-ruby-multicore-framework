# frozen_string_literal: true

# simple_command_test.rb
# PureMVC Ruby Multicore

# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

require 'minitest/autorun'
require_relative '../../../lib/puremvc'

include PureMVC

# Test the PureMVC SimpleCommand class.
#
# @see SimpleCommandTestVO
# @see SimpleCommandTestCommand
class SimpleCommandTest < Minitest::Test
  # Tests the <code>execute</code> method of a <code>SimpleCommand</code>.
  #
  # This test creates a new <code>Notification</code>, adding a
  # <code>SimpleCommandTestVO</code> as the body.
  # It then creates a <code>SimpleCommandTestCommand</code> and invokes
  # its <code>execute</code> method, passing in the note.
  #
  # Success is determined by evaluating a property on the
  # object that was passed on the Notification body, which will
  # be modified by the <code>SimpleCommand</code>.
  def test_simple_command_execute
    # Create the VO
    vo = SimpleCommandTestVO.new(5)

    # Create the Notification (note)
    note = Notification.new('SimpleCommandTestNote', vo)

    # Create the SimpleCommand
    command = SimpleCommandTestCommand.new

    # Execute the SimpleCommand
    command.execute(note)

    # test assertions
    assert_equal 10, vo.result, 'Expecting vo.result == 10'
  end
end

# A SimpleCommand subclass used by SimpleCommandTest.
#
# @see SimpleCommandTest
# @see SimpleCommandTestVO
class SimpleCommandTestCommand < SimpleCommand
  # Fabricate a result by multiplying the input by 2
  # @param note [INotification] carrying the <code>SimpleCommandTestVO</code>
  def execute(note)
    vo = note.body

    # Fabricate a result
    vo.result = vo.input * 2
  end
end

# A utility class used by SimpleCommandTest.
#
# @see SimpleCommandTest
# @see SimpleCommandTestCommand
class SimpleCommandTestVO
  attr_accessor :input, :result

  # Constructor
  #
  # @param input [Integer] the number to be fed to the SimpleCommandTestCommand
  def initialize(input)
    @input = input
  end
end
