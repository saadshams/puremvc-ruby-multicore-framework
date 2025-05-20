# frozen_string_literal: true

# notification_test.rb
# PureMVC Ruby Multicore

# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

require 'minitest/autorun'
require_relative '../../../src/puremvc'

class NotificationTest < Minitest::Test
  def test_name_accessor
    note = PureMVC::Notification.new("TestNote")

    assert_equal "TestNote", note.name, "Expecting note.name == 'TestNote'"
  end

  def test_body_accessor
    note = PureMVC::Notification.new("TestNote")
    note.body = 5

    assert_equal 5, note.body, "Expecting note.body == 5"
  end

  def test_constructor
    note = PureMVC::Notification.new("TestNote", 5, "TestNoteType")

    assert_equal "TestNote", note.name, "Expecting note.name == 'TestNoteType'"
    assert_equal 5, note.body, "Expecting note.body == 5"
    assert_equal "TestNoteType", note.type, "Expecting note.type == 'TestNoteType'"
  end

  def test_to_s
    note = PureMVC::Notification.new("TestNote", [1, 3, 5], "TestNoteType")
    ts = "Notification Name: TestNote\nBody: [1, 3, 5]\nType: TestNoteType"
    assert_equal ts, note.to_s, "Expecting note.to_s == ts"
  end

end
