require 'minitest/autorun'
begin
  require 'minitest/reporters'
  Minitest::Reporters.use!
rescue LoadError
end


class Person
  attr_reader :name

  def initialize name
    @name = name
    @sips_taken = 0
  end

  def buy coffee
    @held_coffee = coffee
  end

  def current_coffee_cup
    @held_coffee
  end

  def take_sip
    raise if @held_coffee.empty?
    @held_coffee.remove_sip
    @sips_taken += 1
  end

  def awake?
    @sips_taken == 5
  end
end

class Coffee
  attr_accessor :sips_left
  def initialize
    @sips_left = 5
  end

  def full?
    @sips_left == 5
  end

  def empty?
    @sips_left == 0
  end

  def remove_sip
    @sips_left -= 1
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
    c = Coffee.new
    kat = Person.new "Katie"
    kat.buy c
    kat.take_sip
    kat.take_sip

    assert_equal 3, c.sips_left
  end

  def test_drinking_coffee_wakes_people_up
    c = Coffee.new
    kat = Person.new "Katie"
    refute kat.awake?

    kat.buy c
    5.times { kat.take_sip }

    assert kat.awake?
  end

  def test_drinking_coffee_empties_the_coffee
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

  # HARD MODE
  def test_you_cant_drink_from_an_empty_mug
    c = Coffee.new
    kat = Person.new "Katie"
    refute kat.awake?

    kat.buy c
    5.times { kat.take_sip }

    assert_raises(RuntimeError) do
      kat.take_sip
    end
  end
end
