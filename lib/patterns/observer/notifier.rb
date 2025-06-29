# frozen_string_literal: true

# notifier.rb
# PureMVC Ruby Multicore
#
# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

module PureMVC
  # A base <code>INotifier</code> implementation.
  #
  # <code>MacroCommand</code>, <code>SimpleCommand</code>, <code>Mediator</code>, and <code>Proxy</code>
  # all need to send <code>Notification</code>s.
  #
  # The <code>INotifier</code> interface provides a common method called
  # <code>send_notification</code> that relieves implementation code of
  # the necessity to actually construct <code>Notification</code>s.
  #
  # The <code>Notifier</code> class, which all the above-mentioned classes
  # extend, provides an initialized reference to the <code>Facade</code>
  # Multiton, which is required for the convenience method
  # for sending <code>Notification</code>s. It also eases implementation,
  # as these classes have frequent <code>Facade</code> interactions and
  # usually require access to it anyway.
  #
  # NOTE: In the MultiCore version of the framework, there is one caveat:
  # notifiers cannot send notifications or reach the facade until they
  # have a valid <code>multiton_key</code>.
  #
  # The <code>multiton_key</code> is set:
  # * on a <code>SimpleCommand</code> when it is executed by the <code>Controller<c/ode>
  # * on a <code>Mediator</code> when registered with the <code>View</code>
  # * on a <code>Proxy</code> when registered with the <code>Model</code>
  #
  # @see Proxy
  # @see Facade
  # @see Mediator
  # @see MacroCommand
  # @see SimpleCommand
  class Notifier

    # Message Constants
    MULTITON_MSG = "multitonKey for this Notifier not yet initialized!"
    private_constant :MULTITON_MSG

    # @attr_reader [String] The Multiton Key for this app
    protected attr_reader :multiton_key # Missing type signature for method 'multiton_key'

    # Initialize this INotifier instance.
    #
    # This is how a Notifier receives its <code>multiton_key</code>.
    # Any calls to <code>send_notification</code> or attempts to access the <code>facade</code>
    # will fail until this method has been called.
    #
    # Subclasses such as <code>Mediator</code>, <code>Command</code>, or <code>Proxy</code> may override this
    # method if they need to send notifications or access the <code>Facade</code> instance
    # as early as possible. However, note that the <code>Facade</code> cannot be accessed
    # within the constructor of these classes, because <code>initialize_notifier</code>
    # will not yet have been called at that point.
    #
    # @param key [String] the <code>multiton_key</code> this <code>INotifier</code> will use
    def initialize_notifier(key)
      @multiton_key = key
    end

    # Create and send an INotification.
    #
    # This method eliminates the need to manually construct
    # INotification instances in your implementation code.
    #
    # @param name [String] the name of the notification
    # @param body [Object, nil] optional body
    # @param type [String, nil] optional type
    def send_notification(name, body = nil, type = nil)
      facade.send_notification(name, body, type)
    end

    # Return the Multiton Facade instance
    #
    # @raise [RuntimeError] if the <code>multiton_key</code> is not set
    # @return [IFacade] the facade instance for the notifier's key
    def facade
      raise MULTITON_MSG if @multiton_key.nil?
      Facade.get_instance(@multiton_key) { |key| Facade.new(key) }
    end

  end
end
