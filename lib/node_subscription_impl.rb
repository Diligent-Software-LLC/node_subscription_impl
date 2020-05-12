# Copyright (C) 2020 Diligent Software LLC. All rights reserved. Released
# under the GNU General Public License, Version 3. Refer LICENSE.txt.

require_relative "node_subscription_impl/version"
require 'node_diagram'
require 'diagram_factory_impl'

# NodeSubscription.
# @class_description
#   A NodeSubscription library implementation.
# @attr instance [NodeSubscription]
#   A singleton instance.
# @attr feeds [Set]
#   All subscription feeds. Its elements are hashes. The keys are Node
#   references, and their values are Sets containing corresponding subscribers.
class NodeSubscription < Subscription

  # self.instance().
  # @description
  #   Lazily initializes a singleton instance, or gets the singleton instance.
  # @return [NodeSubscription]
  #   The singleton.
  def self.instance()
    if (@instance.nil?()) then
      self.instance = new()
    end
    return @instance
  end

  # publisher(p = nil).
  # @description
  #   Predicate. Verifies a Node is a feed publisher.
  # @param p [Node]
  #   Any instance.
  # @return [TrueClass, FalseClass]
  #   True in the case p is a feeds key. False otherwise.
  def publisher(p = nil)

    feeds().to_a().each { |feed|
      if (feed.key?(p)) then
        return true
      end
    }
    return false

  end

  # update_subscribers(p = nil).
  # @description
  #   Updates a publisher's subscribers.
  # @param p [Node]
  #   A changed subject.
  # @return [NilClass]
  #   nil.
  def update_subscribers(p = nil)

    unless (publisher(p))
      raise(ArgumentError, "#{p} is not a publisher.")
    else

      p_feed = feed(p)
      p_feed.each { |subscriber|

        factory   = kind_factory(subscriber)
        singleton = factory.instance()
        singleton.diagram_update(p)

      }

    end
    return nil

  end

  # add_publisher(p = nil).
  # @description
  #   Adds a Node publisher.
  # @param p [Node]
  #   Any instance.
  # @return [NilClass]
  #   nil.
  def add_publisher(p = nil)

    publishable_set = NodeSubscription.publishable()
    p_class         = p.class()
    if (publisher(p))
      raise(ArgumentError, "#{p} was added previously.")
    elsif (!publishable_set.include?(p_class))
      raise(ArgumentError, "#{p} is not a publishable object.")
    else

      feed_hash    = {}
      feed_hash[p] = Set[]
      feeds().add(feed_hash)

    end
    return nil

  end

  # add_subscriber(p = nil, s = nil).
  # @description
  #   Adds a subscriber a publisher's Set.
  # @param p [Node]
  #   A publisher.
  # @param s [.]
  #   Any subscribable instance.
  # @return [NilClass]
  #   nil.
  def add_subscriber(p = nil, s = nil)

    if ((!publisher(p)) || (feed(p).include?(s)) ||
        (!NodeSubscription.s_instance(s)))
      raise(ArgumentError,
            "#{p} never registered as a publisher, or #{s} was previously
subscribed.")
    else
      p_feed = feed(p)
      p_feed.add(s)
    end
    return nil

  end

  protected

  # feeds().
  # @description
  #   Gets feeds.
  # @return [Set]
  #   feeds' reference.
  def feeds()
    return @feeds
  end

  # feed(p = nil).
  # @description
  #   Gets a publisher's feed.
  # @param p [Node]
  #   A publisher.
  # @return [Set]
  #   p's feed.
  # @raise [ArgumentError]
  #   In the case p is not a feeds element hash key.
  def feed(p = nil)

    if (publisher(p))

      feeds().to_a().each { |feed|
        if (feed.key?(p)) then
          return feed[p]
        end
      }

    else
      raise(ArgumentError, "#{p} was never added.")
    end

  end

  private

  # feeds=(s = nil).
  # @description
  #   Sets feeds.
  # @param s [Set]
  #   An empty Set.
  # @return [Set]
  #   The argument.
  def feeds=(s = nil)
    @feeds = s
  end

  # kind_factory(s = nil).
  # @description
  #   Gets a subscriber's factory.
  # @param s [.]
  #   A feed subscriber.
  # @return [.]
  #   A factory identifier.
  def kind_factory(s = nil)

    case
    when s.instance_of?(NodeDiagram)
      return DiagramFactory
    else
      raise(ArgumentError, "#{s}\'s factory is nonexistent.")
    end

  end

  # initialize().
  # @description
  #   Initializes the singleton instance.
  def initialize()
    self.feeds = Set[]
  end

  # self.instance=(s = nil).
  # @description
  #   Sets the singleton instance.
  # @param s [NodeSubscription]
  #   The singleton NodeSubscription instance.
  # @return [NodeSubscription]
  #   The argument.
  def self.instance=(s = nil)
    @instance = s
  end

  private_class_method :new
  private_class_method :instance=

end
