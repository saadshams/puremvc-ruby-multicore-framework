# frozen_string_literal: true

# mediator_test.rb
# PureMVC Ruby Multicore

# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

require 'minitest/autorun'
require_relative '../../../lib/puremvc'

include PureMVC

# Test the PureMVC Mediator class.
#
# @see IMediator
# @see Mediator
class MediatorTest < Minitest::Test

  # Tests getting the name using Mediator class accessor method.
  def test_name_accessor
    # Create a new Mediator and use accessors to set the mediator name
    mediator = Mediator.new

    # test assertions
    assert_equal Mediator::NAME, mediator.name, 'Expecting mediator.name == Mediator::NAME'
  end

  # Tests getting the name using Mediator class accessor method.
  def test_view_accessor
    # Create a component object
    component = Object.new

    # Create a new Proxy and use accessors to set the proxy name
    mediator = Mediator.new(Mediator::NAME, component)

    # test assertions
    assert_equal component, mediator.component, "Expecting component == #{component}"
  end

end
