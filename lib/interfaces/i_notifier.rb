# frozen_string_literal: true
require 'interface'

# i_notifier.rb
# PureMVC Ruby Multicore
#
# Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
# Your reuse is governed by the BSD 3-Clause License

module PureMVC
  # The interface definition for a PureMVC Notifier.
  #
  # <code>MacroCommand, Command, Mediator</code> and <code>Proxy</code>
  # all have a need to send <code>Notifications</code>.
  #
  # The <code>INotifier</code> interface provides a common method called
  # <code>sendNotification</code> that relieves implementation code of
  # the necessity to actually construct <code>Notifications</code>.
  #
  # The <code>Notifier</code> class, which all the above-mentioned classes
  # extend, also provides an initialized reference to the <code>Facade</code>
  # Singleton, which is required for the convenience method
  # for sending <code>Notifications</code>, but also eases implementation as these
  # classes have frequent <code>Facade</code> interactions and usually require
  # access to the facade anyway.
  #
  # @see IFacade
  # @see INotification
  INotifier = interface {
    # Send a <code>INotification</code>.
    #
    # Convenience method to prevent having to construct new
    # notification instances in our implementation code.
    #
    # @param name [String] The name of the notification to send.
    # @param body [Object, nil] The body of the notification (optional).
    # @param type [String, nil] The type of the notification (optional).
    # @return [void]
    def send_notification(name, body = nil, type = nil)
      raise NotImplementedError, "#{self.class} must implement #send_notification"
    end

    # Initialize this INotifier instance.
    #
    # This is how a </code>Notifier</code> gets its multitonKey.
    # Calls to <code>send_notification</code> or to access the
    # facade will fail until after this method has been called.
    #
    # @param key [String] The multitonKey for this INotifier to use.
    # @return void
    def initialize_notifier(key)
      raise NotImplementedError, "#{self.class} must implement #initialize_notifier"
    end

  }

end
