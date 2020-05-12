require_relative 'test_helper'

# NodeSubscriptionTest.
# @class_description
#   Tests the NodeSubscription class.
class NodeSubscriptionTest < Minitest::Test

  # Constants.
  CLASS       = NodeSubscription
  TEST_SYMBOL = :test_symbol

  # test_conf_doc_f_ex().
  # @description
  #   The .travis.yml, CODE_OF_CONDUCT.md, Gemfile, LICENSE.txt, README.md,
  #   .yardopts, .gitignore, Changelog.md, CODE_OF_CONDUCT.md,
  #   node_subscription_impl.gemspec, Gemfile.lock, and Rakefile files exist.
  def test_conf_doc_f_ex()

    assert_path_exists('.travis.yml')
    assert_path_exists('CODE_OF_CONDUCT.md')
    assert_path_exists('Gemfile')
    assert_path_exists('LICENSE.txt')
    assert_path_exists('README.md')
    assert_path_exists('.yardopts')
    assert_path_exists('.gitignore')
    assert_path_exists('Changelog.md')
    assert_path_exists('CODE_OF_CONDUCT.md')
    assert_path_exists('node_subscription_impl.gemspec')
    assert_path_exists('Gemfile.lock')
    assert_path_exists('Rakefile')

  end

  # test_version_declared().
  # @description
  #   The version was declared.
  def test_version_declared()
    refute_nil(NodeSubscription::VERSION)
  end

  # setup().
  # @description
  #   Set fixtures.
  def setup()
    @node1 = Node.new(nil, TEST_SYMBOL, nil)
  end

  # NodeSubscription.instance().

  # test_cinstance_x1().
  # @description
  #   'NodeSubscription.instance()' returns an instance.
  def test_cinstance_x1()
    singleton = NodeSubscription.instance()
    assert_same(singleton.class(), NodeSubscription)
  end

  # update_subscribers(publisher = nil).

  # test_us_x1().
  # @description
  #   An unpublishable instance argument.
  def test_us_x1()

    singleton = NodeSubscription.instance()
    assert_raises(ArgumentError) {
      singleton.update_subscribers(@node1)
    }

  end

  # test_us_x2().
  # @description
  #   A Node argument having a feed.
  def test_us_x2()

    singleton = NodeSubscription.instance()
    singleton.add_publisher(@node1)
    diagram = NodeDiagram.new(@node1)
    singleton.add_subscriber(@node1, diagram)
    assert_nil(singleton.update_subscribers(@node1))

  end

  # test_us_x3().
  # @description
  #   A Node argument. The argument never registered a feed.
  def test_us_x3()

    singleton = NodeSubscription.instance()
    assert_raises(ArgumentError) {
      singleton.update_subscribers(@node1)
    }

  end

  # publisher(p = nil).

  # test_p_x1().
  # @description
  #   The argument was previously registered.
  def test_p_x1()

    singleton = NodeSubscription.instance()
    singleton.add_publisher(@node1)
    assert_operator(singleton, 'publisher', @node1)

  end

  # test_p_x2().
  # @description
  #   The argument never previously registered.
  def test_p_x2()
    singleton = NodeSubscription.instance()
    refute_operator(singleton, 'publisher', @node1)
  end

  # add_publisher(p = nil).

  # test_ap_x1().
  # @description
  #   Any argument excluding Node instances.
  def test_ap_x1()

    singleton = NodeSubscription.instance()
    assert_raises(ArgumentError) {
      singleton.add_publisher(TEST_SYMBOL)
    }

  end

  # test_ap_x2().
  # @description
  #   A Node argument never previously registered.
  def test_ap_x2()

    singleton = NodeSubscription.instance()
    singleton.add_publisher(@node1)
    assert_operator(singleton, 'publisher', @node1)

  end

  # test_ap_x3().
  # @description
  #   A previously registered Node argument.
  def test_ap_x3()

    singleton = NodeSubscription.instance()
    singleton.add_publisher(@node1)
    assert_raises(ArgumentError) {
      singleton.add_publisher(@node1)
    }

  end

  # add_subscriber(p = nil, s = nil).

  # test_as_x1a().
  # @description
  #   p is not a Node.
  def test_as_x1a()

    singleton = NodeSubscription.instance()
    diagram   = NodeDiagram.new(@node1)
    assert_raises(ArgumentError) {
      singleton.add_subscriber(TEST_SYMBOL, diagram)
    }

  end

  # test_as_x1b().
  # @description
  #   s is not a subscribable instance.
  def test_as_x1b()

    singleton = NodeSubscription.instance()
    singleton.add_publisher(@node1)
    diagram = NodeDiagram.new(@node1)
    assert_raises(ArgumentError) {
      singleton.add_subscriber(@node1, TEST_SYMBOL)
    }

  end

  # test_as_x2().
  # @description
  #   p is a Node. p was never previously registered.
  def test_as_x2()

    singleton = NodeSubscription.instance()
    diagram   = NodeDiagram.new(@node1)
    assert_raises(ArgumentError) {
      singleton.add_subscriber(@node1, diagram)
    }

  end

  # test_as_x3().
  # @description
  #   p was previously registered, and s never subscribed its feed.
  def test_as_x3()

    singleton = NodeSubscription.instance()
    diagram   = NodeDiagram.new(@node1)
    singleton.add_publisher(@node1)
    assert_nil(singleton.add_subscriber(@node1, diagram))

  end

  # test_as_x4().
  # @description
  #   s is already a p subscriber.
  def test_as_x4()

    singleton = NodeSubscription.instance()
    diagram   = NodeDiagram.new(@node1)
    singleton.add_publisher(@node1)
    singleton.add_subscriber(@node1, diagram)
    assert_raises(ArgumentError) {
      singleton.add_subscriber(@node1, diagram)
    }

  end

  # Protected methods.

  # test_prot_m().
  # @description
  #   'feeds()' and 'feed(p = nil)' were protected.
  def test_prot_m()

    protected_m = CLASS.protected_instance_methods(false)
    assert_includes(protected_m, :feeds)
    assert_includes(protected_m, :feed)

  end

  # Private methods.

  # test_private_m().
  # @description
  #   'feeds=(s = Set[])', 'kind_factory(s = nil)', 'initialize()', and
  #   'NodeSubscription.new()' were privatized.
  def test_private_m()

    private_c_methods = CLASS.private_methods(false)
    private_i_methods = CLASS.private_instance_methods(false)
    assert_includes(private_c_methods, :new)
    assert_includes(private_i_methods, :feeds=)
    assert_includes(private_i_methods, :kind_factory)
    assert_includes(private_i_methods, :initialize)

  end

  # teardown().
  # @description
  #   Cleanup.
  def teardown()
  end

end
