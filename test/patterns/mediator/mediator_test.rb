# frozen_string_literal: true

# mediator_test.rb
# PureMVC Ruby Multicore

# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

require 'minitest/autorun'
require_relative '../../../src/puremvc'

class MediatorTest < Minitest::Test

  def test_name_accessor
    mediator = PureMVC::Mediator.new
    assert_equal PureMVC::Mediator::NAME, mediator.name, "Expecting mediator.name == Mediator::NAME"
  end

  def test_view_accessor
    view = Object.new
    mediator = PureMVC::Mediator.new(PureMVC::Mediator::NAME, view)
    assert_equal view, mediator.view, "Expecting view == #{view}"
  end

end
