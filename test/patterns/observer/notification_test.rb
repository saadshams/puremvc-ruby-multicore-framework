# frozen_string_literal: true

# notification_test.rb
# PureMVC Ruby Multicore

# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

require 'minitest/autorun'
require_relative '../../../lib/puremvc'

# Test the PureMVC Notification class.
#
# @see PureMVC::Notification
class NotificationTest < Minitest::Test
  # Tests setting and getting the name using Notification class accessor methods.
  def test_name_accessor
    # Create a new Notification and use accessors to set the note name
    note = PureMVC::Notification.new("TestNote")

    # test assertions
    assert_equal "TestNote", note.name, "Expecting note.name == 'TestNote'"
  end

  # Tests setting and getting the body using Notification class accessor methods.
  def test_body_accessor
    # Create a new Notification and use accessors to set the body
    note = PureMVC::Notification.new("TestNote")
    note.body = 5

    # test assertions
    assert_equal 5, note.body, "Expecting note.body == 5"
  end

  # Tests setting the name and body using the Notification class Constructor.
  def test_constructor
    # Create a new Notification using the Constructor to set the note name and body
    note = PureMVC::Notification.new("TestNote", 5, "TestNoteType")

    # test assertions
    assert_equal "TestNote", note.name, "Expecting note.name == 'TestNoteType'"
    assert_equal 5, note.body, "Expecting note.body == 5"
    assert_equal "TestNoteType", note.type, "Expecting note.type == 'TestNoteType'"
  end

  # Tests the to_s method of the notification
  def test_to_s
    # Create a new Notification and use accessors to set the note name
    note = PureMVC::Notification.new("TestNote", [1, 3, 5], "TestNoteType")
    ts = "Notification Name: TestNote\nBody: [1, 3, 5]\nType: TestNoteType"

    # test assertions
    assert_equal ts, note.to_s, "Expecting note.to_s == ts"
  end

end
