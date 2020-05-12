$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require_relative "../lib/node_subscription_impl"
require 'node'
require "minitest/autorun"
