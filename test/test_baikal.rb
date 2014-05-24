#! /usr/bin/ruby

require 'stringio'
require 'test/unit'

require_relative '../lib/baikal'
require_relative '../lib/baikal/tweak'
require_relative '../lib/baikal/hexdump'

class Test_Baikal < Test::Unit::TestCase
  def test_sanity
    pool = Baikal::Pool.new
    pool.emit_byte(42)
    assert_equal pool.bytes, '*'
    pool.go_network_byte_order
    pool.emit_tetra(0x41424344)
    assert_equal pool.bytes,'*ABCD'
    pool.truncate 1
    assert_equal pool.size, 1
    pool.go_reverse_network_byte_order
    pool.emit_wyde(0x3132)
    assert_equal pool.bytes, '*21'
    return
  end

  def test_tweak
    pool = Baikal::Pool.new 'XYZ'
    pool.tweak_unsigned_byte 2 do |c| c = 0x20 end
    assert_equal pool.bytes, 'XY '
    pool.tweak_signed_byte 1 do |c| c -= 2 end
    assert_equal pool.bytes, 'XW '
    pool.go_network_byte_order
    pool.tweak_unsigned_wyde 1 do |c| c += 0xFF03 end
    assert_equal pool.bytes, 'XV#'
    return
  end

  def test_hexdump
    sport = StringIO.new
    s = "Mary had a little lamb,\n" +
        "His fleece was white as snow,\n" +
        "And everywhere that Mary went,\n" +
        "The lamb was sure to go.\n"
    Baikal.hexdump s, sport
    assert_equal sport.string,
        "00000: 4D 61 72 79  20 68 61 64  20 61 20 6C  69 74 74 6C  " +
            "Mary had a littl\n" +
        "00010: 65 20 6C 61  6D 62 2C 0A  48 69 73 20  66 6C 65 65  " +
            "e lamb,.His flee\n" +
        "00020: 63 65 20 77  61 73 20 77  68 69 74 65  20 61 73 20  " +
            "ce was white as \n" +
        "00030: 73 6E 6F 77  2C 0A 41 6E  64 20 65 76  65 72 79 77  " +
            "snow,.And everyw\n" +
        "00040: 68 65 72 65  20 74 68 61  74 20 4D 61  72 79 20 77  " +
            "here that Mary w\n" +
        "00050: 65 6E 74 2C  0A 54 68 65  20 6C 61 6D  62 20 77 61  " +
            "ent,.The lamb wa\n" +
        "00060: 73 20 73 75  72 65 20 74  6F 20 67 6F  2E 0A        " +
            "s sure to go..  \n"
  end
end
