# frozen_string_literal: true

# macro_command_test.rb
# PureMVC Ruby Multicore

# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

require 'minitest/autorun'
require_relative '../../../lib/puremvc'

include PureMVC

# Test the PureMVC MacroCommand class.
#
# @see MacroCommandTestVO
# @see MacroCommandTestCommand
class MacroCommandTest < Minitest::Test
  # Tests operation of a <code>MacroCommand</code>.
  #
  # This test creates a new <code>Notification</code>, adding a
  # <code>MacroCommandTestVO</code> as the body.
  # It then creates a <code>MacroCommandTestCommand</code> and invokes
  # its <code>execute</code> method, passing in the
  # <code>Notification</code>.
  #
  # The <code>MacroCommandTestCommand</code> has defined an
  # <code>initialize_macro_command</code> method, which is
  # called automatically by its constructor. In this method
  # the <code>MacroCommandTestCommand</code> adds 2 SubCommands
  # to itself, <code>MacroCommandTestSub1Command</code> and
  # <code>MacroCommandTestSub2Command</code>.
  #
  # The <code>MacroCommandTestVO</code> has 2 result properties,
  # one is set by <code>MacroCommandTestSub1Command</code> by
  # multiplying the input property by 2, and the other is set
  # by <code>MacroCommandTestSub2Command</code> by multiplying
  # the input property by itself.
  #
  # Success is determined by evaluating the 2 result properties
  # on the <code>MacroCommandTestVO</code> that was passed to
  # the <code>MacroCommandTestCommand</code> on the Notification
  # body.
  def test_macro_command_execute
    # Create the VO
    vo = MacroCommandTestVO.new(5)

    # Create the Notification (note)
    note = Notification.new("MacroCommendTest", vo)

    # Create the SimpleCommand
    command = MacroCommandTestCommand.new

    # Execute the SimpleCommand
    command.execute(note)

    # test assertions
    assert_equal 10, vo.result1, "Expecting vo.result1 == 10"
    assert_equal 25, vo.result2, "Expecting vo.result2 == 25"
  end
end

# A MacroCommand subclass used by MacroCommandTest.
#
# @see MacroCommandTest
# @see MacroCommandTestSub1Command
# @see MacroCommandTestSub2Command
# @see MacroCommandTestVO
class MacroCommandTestCommand < MacroCommand
  # Initialize the MacroCommandTestCommand by adding its 2 SubCommands.
  def initialize_macro_command
    add_sub_command { MacroCommandSub1Command.new }
    add_sub_command { MacroCommandSub2Command.new }
  end
end

# A SimpleCommand subclass used by MacroCommandTestCommand.
#
# @see MacroCommandTest
# @see MacroCommandTestCommand
# @see MacroCommandTestVO
class MacroCommandSub1Command < SimpleCommand
  # Fabricate a result by multiplying the input by 2
  # @param notification [INotification] carrying the <code>MacroCommandTestVO</code>
  def execute(notification)
    vo = notification.body

    # Fabricate a result
    vo.result1 = 2 * vo.input
  end
end

# A SimpleCommand subclass used by MacroCommandTestCommand.
#
# @see MacroCommandTest
# @see MacroCommandTestCommand
# @see MacroCommandTestVO
class MacroCommandSub2Command < SimpleCommand
  # Fabricate a result by multiplying the input by itself
  # @param notification [INotification] carrying the <code>MacroCommandTestVO</code>
  def execute(notification)
    vo = notification.body

    # Fabricate a result
    vo.result2 = vo.input * vo.input
  end
end

# A utility class used by MacroCommandTest.
#
# @see MacroCommandTest
# @see MacroCommandTestCommand
# @see MacroCommandTestSub1Command
# @see MacroCommandTestSub2Command
class MacroCommandTestVO

  attr_accessor :input, :result1, :result2

  # Constructor.
  #
  # @param input [Integer] the number to be fed to the MacroCommandTestCommand
  def initialize(input)
    @input = input
  end
end