require 'minitest/autorun'
begin
  require 'minitest/reporters'
  Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
rescue LoadError
end


class Person
  attr_reader :name

  def initialize name
    @name = name
  end

  def buy cup_of_coffee_that_you_should_buy
    @held_coffee = cup_of_coffee_that_you_should_buy
  end

  def current_coffee_cup
    @held_coffee
  end
end

class Coffee
  attr_reader :sips_left

  def initialize
    @sips_left = 5
  end

  def full?
    @sips_left == 5
  end

  def empty?
    @sips_left == 0
  end
end


class CoffeeTest < Minitest::Test
  def test_mugs_start_with_5_sips
    c = Coffee.new
    assert_equal 5, c.sips_left
    assert c.full?
    refute c.empty?
  end

  def test_people_have_names
    mal = Person.new "Mallory"
    assert_equal "Mallory", mal.name
  end

  def test_people_can_buy_coffee
    c = Coffee.new
    kat = Person.new "Katie"
    kat.buy c

    assert_equal c, kat.current_coffee_cup
  end

  def test_people_can_drink_their_coffee
    skip
    c = Coffee.new
    kat = Person.new "Katie"
    kat.buy c
    kat.take_sip
    kat.take_sip

    assert_equal 3, c.sips_left
  end

  def test_drinking_coffee_wakes_people_up
    skip
    c = Coffee.new
    kat = Person.new "Katie"
    refute kat.awake?

    kat.buy c
    5.times { kat.take_sip }

    assert kat.awake?
  end

  def test_drinking_coffee_empties_the_coffee
    skip
    c = Coffee.new
    kat = Person.new "Katie"
    kat.buy c

    # Take a few sips
    2.times { kat.take_sip }
    assert_equal 3, c.sips_left
    refute c.full?
    refute c.empty?

    # Finish the drink
    3.times { kat.take_sip }
    assert_equal 0, c.sips_left
    assert c.empty?
  end

  def test_you_cant_drink_from_an_empty_mug
    skip
    c = Coffee.new
    kat = Person.new "Katie"
    refute kat.awake?

    kat.buy c
    5.times { kat.take_sip }

    assert_raises do
      kat.take_sip
    end
  end

  # What other tests should we write?
  # What should happen if you try to drink, but don't have coffee?
  # What if a person already has coffee and buys a new coffee?
  # Allow for different sizes of coffee cups, with different
  #   numbers of sips in them
end
