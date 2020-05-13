# Copyright (C) 2020 Diligent Software LLC. All rights reserved. Released
# under the GNU General Public License, Version 3. Refer LICENSE.txt.

require 'subscription_impl'

# NodeSubscription.
# @class_description
#   A NodeSubscription library implementation.
# @attr instance [NodeSubscription]
#   A singleton instance.
# @attr feeds [Set]
#   All subscription feeds. Its elements are hashes. The keys are Node
#   references, and their values are Sets containing corresponding subscribers.
class NodeSubscription < Subscription
  VERSION = '1.0.0'.freeze()
end
