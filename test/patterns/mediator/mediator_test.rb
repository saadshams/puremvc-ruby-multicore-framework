# frozen_string_literal: true

# mediator_test.rb
# PureMVC Ruby Multicore

# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

require 'minitest/autorun'
require_relative '../../../src/puremvc'

# Test the PureMVC Mediator class.
#
# @see PureMVC::IMediator
# @see PureMVC::Mediator
class MediatorTest < Minitest::Test

  # Tests getting the name using Mediator class accessor method.
  def test_name_accessor
    # Create a new Mediator and use accessors to set the mediator name
    mediator = PureMVC::Mediator.new

    # test assertions
    assert_equal PureMVC::Mediator::NAME, mediator.name, "Expecting mediator.name == Mediator::NAME"
  end

  # Tests getting the name using Mediator class accessor method.
  def test_view_accessor
    # Create a view object
    view = Object.new

    # Create a new Proxy and use accessors to set the proxy name
    mediator = PureMVC::Mediator.new(PureMVC::Mediator::NAME, view)

    # test assertions
    assert_equal view, mediator.view, "Expecting view == #{view}"
  end

end
