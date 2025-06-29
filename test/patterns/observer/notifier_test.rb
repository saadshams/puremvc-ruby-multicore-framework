# frozen_string_literal: true

# notifier_test.rb
# PureMVC Ruby Multicore

# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

require 'minitest/autorun'
require_relative '../../../lib/puremvc'

include PureMVC

# Test the PureMVC Notifier class.
#
# @see Notifier
class NotifierTest < Minitest::Test
  # Tests notifier methods.
  def test_notifier
    # Create a new Notifier and initialize the notifier with a test key
    notifier = Notifier.new
    notifier.initialize_notifier("NotifierTestKey1")

    # test assertions
    refute_nil notifier, "Expecting notifier not nil"
    refute_nil notifier.facade, "Expecting notifier.facade not nil"
  end

  def test_register_command_and_send_notification
    # Create the Notifier, register the NotifierTestCommand to
    # handle 'NotifierTest' notifications
    notifier = Notifier.new
    notifier.initialize_notifier("NotifierTestKey2")
    notifier.facade.register_command("NotifierTest") { NotifierTestCommand.new }

    # Send notification. The Command associated with the event
    # (NotifierTestCommand) will be invoked and will multiply
    # the vo.input value by 2 and set the result on vo.result
    vo = NotifierTestVO.new(12)
    note = Notification.new("NotifierTest", vo)
    notifier.facade.send_notification(note.name, note.body)

    # test assertions
    assert_equal 24, vo.result, "Expecting vo.result == 24"
  end
end

# A SimpleCommand subclass used by Notifier.
#
# @see NotifierTest
# @see NotifierTestVO
class NotifierTestCommand < SimpleCommand
  # Fabricate a result by multiplying the input by 2
  #
  # @param notification [Notification] the Notification carrying the NotifierTestVO
  def execute(notification)
    vo = notification.body
    vo.result = 2 * vo.input
  end
end

# A utility class used by NotifierTest.
#
# @see NotifierTest
# @see NotifierTestVO
class NotifierTestVO

  attr_accessor :input, :result

  # Constructor
  #
  # @param input [Integer] the number to be fed to the NotifierTestCommand
  def initialize(input)
    @input = input
  end
end
