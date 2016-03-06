require 'test_helper'

class MoneyMoney::StatementLinesTest < MiniTest::Unit::TestCase
  
  def setup
    fixture = File.join(File.dirname(__FILE__), '../fixtures/moneymoney-fixture.csv')
    @lines = MoneyMoney::StatementLines.read(fixture)
  end
  
  #
  # test array behaviour
  #
  def test_size
    assert_equal 4, @lines.size
  end
  
  def test_each
    count = 0
    @lines.each { |l| count += 1 }
    assert_equal 4, count
  end
  
  def test_map
    out = @lines.map { |l| l }
    assert_equal 4, out.size
  end
  
  def test_array_access
    assert_equal MoneyMoney::StatementLine, @lines[0].class
  end
  
  #
  # test metadata
  #
  def test_num_statements
    assert_equal 4, @lines.num_statements
  end
  
  def test_latest_booking
    assert_equal Date.parse("31.12.2012"), @lines.latest_booking
  end
  
  def test_earliest_booking
    assert_equal Date.parse("28.12.2012"), @lines.earliest_booking
  end
  
end