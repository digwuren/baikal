#
# Baikal is a tool for generating, parsing and modifying binary objects.
#
# $Id: baikal.rb 90 2009-10-19 15:02:43Z dig $
#
module Baikal
  VERSION = '1.1.0'

  #
  # Represents a byte pool.  Byte pools are resizeable arrays of bytes.  Data
  # can be stored into or read from byte pool as integers or as blobs.
  #
  # Each byte pool has an associated /integer byte order indicator/; see
  # +go_network_byte_order+, +go_reverse_network_byte_order+ and
  # +go_native_byte_order+.
  #
  # Byte pools have no concept of current position; for linear traversal, see
  # +Cursor+.
  #
  class Pool
    #
    # A Ruby string containing all the bytes currently in this pool.
    #
    attr_reader :bytes

    #
    # Creates a new byte pool of the host system's native byte order.  If
    # +initial_content+ is given, loads its bytes to the newly created byte
    # pool.  Otherwise, the byte pool will be empty after creation.
    #
    def initialize initial_content = ''
      raise 'Type mismatch' unless initial_content.is_a? String
      super()
      @bytes = initial_content.dup
      @bytes.force_encoding Encoding::ASCII_8BIT
      @byte_order = '!' # native
      return
    end

    #
    # Creates a new byte pool of the network byte order.the host system's
    # native endianness.  If +initial_content+ is given, loads its bytes to
    # the newly created byte pool.  Otherwise, the byte pool will be empty
    # after creation.
    #
    def Pool::new_of_network_byte_order initial_content = ''
      raise 'Type mismatch' unless initial_content.is_a? String
      pool = Pool.new(initial_content)
      pool.go_network_byte_order
      return pool
    end

    #
    # Creates a new byte pool of the reverse network byte order.the host
    # system's native endianness.  If +initial_content+ is given, loads its
    # bytes to the newly created byte pool.  Otherwise, the byte pool will
    # be empty after creation.
    #
    def Pool::new_of_reverse_network_byte_order initial_content = ''
      raise 'Type mismatch' unless initial_content.is_a? String
      pool = Pool.new(initial_content)
      pool.go_reverse_network_byte_order
      return pool
    end

    #
    # Appends the byte given by +value+ to this byte pool, growing the byte
    # pool by one byte.
    #
    def emit_byte value
      set_byte @bytes.size, value
      return
    end

    #
    # Appends the wyde given by +value+ to this byte pool using the
    # currently selected byte order, growing the byte pool by two bytes.
    #
    def emit_wyde value
      set_wyde @bytes.size, value
      return
    end

    #
    # Appends the tetrabyte given by +value+ to this byte pool using the
    # currently selected byte order, growing the byte pool by four bytes.
    #
    def emit_tetra value
      set_tetra @bytes.size, value
      return
    end

    #
    # Appends the octabyte given by +value+ to this byte pool using the
    # currently selected byte order, growing the byte pool by eight bytes.
    #
    def emit_octa value
      set_octa @bytes.size, value
      return
    end

    #
    # Appends +count+ copies of the byte given by +value+ to this byte
    # pool, growing the byte pool by as many bytes.  If +value+ is not
    # given, zero is used by default.
    #
    def emit_repeated_bytes count, value = 0
      raise 'Type mismatch' unless count.is_a? Integer
      raise 'Type mismatch' unless value.is_a? Integer
      @bytes << [value].pack('C') * count
      return
    end

    #
    # Retrieves one unsigned byte from this byte pool from the given
    # +offset+.
    #
    # Error if such a byte lies outside the boundaries of the pool.
    #
    def get_unsigned_byte offset
      raise 'Type mismatch' unless offset.is_a? Integer
      raise 'Offset out of range' if offset < 0 or offset + 1 > @bytes.size
      return @bytes.unpack("@#{offset}C").first
    end

    #
    # Retrieves one unsigned wyde from this byte pool from the given
    # +offset+, using the currently selected byte order.
    #
    # Error if such a wyde lies outside the boundaries of the pool, even
    # partially.
    #
    def get_unsigned_wyde offset
      raise 'Type mismatch' unless offset.is_a? Integer
      raise 'Offset out of range' if offset < 0 or offset + 2 > @bytes.size
      return @bytes.unpack("@#{offset} S#@byte_order").first
    end

    #
    # Retrieves one unsigned tetrabyte from this byte pool from the given
    # +offset+, using the currently selected byte order.
    #
    # Error if such a tetra lies outside the boundaries of the pool, even
    # partially.
    #
    def get_unsigned_tetra offset
      raise 'Type mismatch' unless offset.is_a? Integer
      raise 'Offset out of range' if offset < 0 or offset + 4 > @bytes.size
      return @bytes.unpack("@#{offset} L#@byte_order").first
    end

    #
    # Retrieves one unsigned octabyte from this byte pool from the given
    # +offset+, using the currently selected byte order.
    #
    # Error if such an octa lies outside the boundaries of the pool, even
    # partially.
    #
    def get_unsigned_octa offset
      raise 'Type mismatch' unless offset.is_a? Integer
      raise 'Offset out of range' if offset < 0 or offset + 8 > @bytes.size
      return @bytes.unpack("@#{offset} Q#@byte_order").first
    end

    #
    # Retrieves one signed byte from this byte pool from the given
    # +offset+.
    #
    # Error if such a byte lies outside the boundaries of the pool.
    #
    def get_signed_byte offset
      raise 'Type mismatch' unless offset.is_a? Integer
      raise 'Offset out of range' if offset < 0 or offset + 1 > @bytes.size
      return @bytes.unpack("@#{offset} c").first
    end

    #
    # Retrieves one signed wyde from this byte pool from the given
    # +offset+, using the currently selected byte order.
    #
    # Error if such a wyde lies outside the boundaries of the pool, even
    # partially.
    #
    def get_signed_wyde offset
      raise 'Type mismatch' unless offset.is_a? Integer
      raise 'Offset out of range' if offset < 0 or offset + 2 > @bytes.size
      return @bytes.unpack("@#{offset} s#@byte_order").first
    end

    #
    # Retrieves one signed tetrabyte from this byte pool from the given
    # +offset+, using the currently selected byte order.
    #
    # Error if such a tetra lies outside the boundaries of the pool, even
    # partially.
    #
    def get_signed_tetra offset
      raise 'Type mismatch' unless offset.is_a? Integer
      raise 'Offset out of range' if offset < 0 or offset + 4 > @bytes.size
      return @bytes.unpack("@#{offset} l#@byte_order").first
    end

    #
    # Retrieves one signed octabyte from this byte pool from the given
    # +offset+, using the currently selected byte order.
    #
    # Error if such an octa lies outside the boundaries of the pool, even
    # partially.
    #
    def get_signed_octa offset
      raise 'Type mismatch' unless offset.is_a? Integer
      raise 'Offset out of range' if offset < 0 or offset + 8 > @bytes.size
      return @bytes.unpack("@#{offset} q#@byte_order").first
    end

    #
    # Retrieves an unsigned integer of the given +size+ (which must be either
    # +1+, +2+, +4+ or +8+) from this byte pool from the given +offset+, using
    # the currently selected byte order.
    #
    # Error if such an integer lies outside the boundaries of the pool,
    # even partially.
    #
    def get_unsigned_integer size, offset
      raise 'Type mismatch' unless offset.is_a? Integer
      pack_code = case size
      when 1 then 'C'
      when 2 then "S#@byte_order"
      when 4 then "L#@byte_order"
      when 8 then "Q#@byte_order"
      else raise "Unsupported integer size #{size.inspect}"
      end
      raise 'Offset out of range' if offset < 0 or offset + size > @bytes.size
      return @bytes.unpack("@#{offset} #{pack_code}").first
    end

    #
    # Sets the byte in this byte pool on the given +offset+ to the given +value+.
    #
    # Error if the offset lies outside the boundaries of the pool.  (But it's
    # OK for it to point at the end of the pool.)
    #
    def set_byte offset, value
      raise 'Type mismatch' unless offset.is_a? Integer
      raise 'Type mismatch' unless value.is_a? Integer
      raise 'Offset out of range' if offset < 0 or offset > @bytes.size
      @bytes[offset] = [value].pack('c')
      return
    end

    #
    # Sets the wyde in this byte pool on the given +offset+ to the given
    # +value+, using the currently selected byte order.
    #
    # Error if the offset lies outside the boundaries of the pool.  (But it's
    # OK for it to point at the end of the pool.)
    #
    def set_wyde offset, value
      raise 'Type mismatch' unless offset.is_a? Integer
      raise 'Type mismatch' unless value.is_a? Integer
      raise 'Offset out of range' if offset < 0 or offset > @bytes.size
      @bytes[offset, 2] = [value].pack("s#@byte_order")
      return
    end

    #
    # Sets the tetrabyte in this byte pool on the given +offset+ to the
    # given +value+, using the currently selected byte order.
    #
    # Error if the offset lies outside the boundaries of the pool.  (But it's
    # OK for it to point at the end of the pool.)
    #
    def set_tetra offset, value
      raise 'Type mismatch' unless offset.is_a? Integer
      raise 'Type mismatch' unless value.is_a? Integer
      raise 'Offset out of range' if offset < 0 or offset > @bytes.size
      @bytes[offset, 4] = [value].pack("l#@byte_order")
      return
    end

    #
    # Sets the octabyte in this byte pool on the given +offset+ to the
    # given +value+, using the currently selected byte order.
    #
    # Error if the offset lies outside the boundaries of the pool.  (But it's
    # OK for it to point at the end of the pool.)
    #
    def set_octa offset, value
      raise 'Type mismatch' unless offset.is_a? Integer
      raise 'Type mismatch' unless value.is_a? Integer
      raise 'Offset out of range' if offset < 0 or offset > @bytes.size
      @bytes[offset, 8] = [value].pack("q#@byte_order")
      return
    end

    #
    # Sets integer of the given +size+ (which must be either +1+, +2+, +4+
    # or +8+) in this byte pool on the given +offset+ to the given +value+,
    # using the currently selected byte order.
    #
    # Error if such an integer lies outside the boundaries of the pool,
    # even partially.
    #
    def set_integer size, offset, value
      raise 'Type mismatch' unless offset.is_a? Integer
      pack_code = case size
      when 1 then 'C'
      when 2 then "S#@byte_order"
      when 4 then "L#@byte_order"
      when 8 then "Q#@byte_order"
      else raise "Unsupported integer size #{size.inspect}"
      end
      raise 'Offset out of range' if offset < 0 or offset > @bytes.size
      @bytes[offset, size] = [value].pack(pack_code)
      return
    end

    #
    # Appends +blob+ given as a Ruby string to this byte pool, growing the
    # byte pool by the blob's length.
    #
    def emit_blob blob
      @bytes << blob.to_s
      return
    end

    #
    # Extracts a blob of given +size+ from this byte pool's given +offset+
    # and returns it as a Ruby string.
    #
    # Error if such a blob lies outside of the boundaries of the pool, even partially.
    #
    def get_blob offset, size
      raise 'Type mismatch' unless offset.is_a? Integer
      raise 'Type mismatch' unless size.is_a? Integer
      raise 'Invalid blob size' if size < 0
      raise 'Offset out of range' if offset < 0 or offset + size > @bytes.size
      return @bytes[offset, size]
    end

    #
    # Stores a +blob+, given as a Ruby string, into this byte pool at the
    # given +offset+.
    #
    # Error if the offset lies outside the boundaries of the pool.  (But it's
    # OK for it to point at the end of the pool.)
    #
    def set_blob offset, blob
      raise 'Type mismatch' unless offset.is_a? Integer
      blob = blob.to_s.dup.force_encoding Encoding::ASCII_8BIT
      raise 'Offset out of range' if offset < 0 or offset > @bytes.size
      @bytes[offset, blob.bytesize] = blob
      return
    end

    #
    # Returns the number of bytes in this byte pool.
    #
    def size
      return @bytes.size
    end

    #
    # Returns the difference between current size of the byte pool and the
    # alignment requirement given by +alignment+.  +alignment+ needs not be
    # a two's power.
    #
    def bytes_until_alignment alignment
      raise 'Type mismatch' unless alignment.is_a? Integer
      raise 'Invalid alignment requirement' unless alignment > 0
      return -@bytes.size % alignment
    end

    #
    # Pads the byte pool to the specified +alignment+ using the specified
    # +padding+ byte.  If +padding+ is not given, zero is used by default.
    #
    def align alignment, padding = 0
      raise 'Type mismatch' unless alignment.is_a? Integer
      raise 'Type mismatch' unless padding.is_a? Integer
      emit_repeated_bytes bytes_until_alignment(alignment), padding
      return
    end

    #
    # Truncates this byte pool to +new_size+ bytes, discarding all bytes
    # after this offset.
    #
    # Error if the byte pool is already shorter than +new_size+ bytes.
    #
    def truncate new_size
      raise 'Type mismatch' unless new_size.is_a? Integer
      raise 'Invalid size' if new_size < 0
      raise 'Unable to truncate to grow' if new_size > @bytes.size
      @bytes[new_size .. -1] = ''
      return
    end

    #
    # Selects the network byte order for following multibyte integer read
    # or write operations.
    #
    def go_network_byte_order
      @byte_order = '>'
      return
    end

    #
    # Selects the reverse network byte order for following multibyte
    # integer read or write operations.
    #
    def go_reverse_network_byte_order
      @byte_order = '<'
      return
    end

    #
    # Selects the host system's native byte order for following multibyte
    # integer read or write operations.
    #
    def go_native_byte_order
      @byte_order = '!'
      return
    end

    #
    # Returns the byte order indicator for the currently selected endianness:
    # +>+ for BigEndian, +<+ for LittleEndian, or +!+ for whatever the native
    # byte order is.  (+Array#pack+ can accept such since Ruby 1.9.3.)
    #
    def byte_order
      return @byte_order
    end

    #
    # Returns whether this byte pool's currently selected byte order is the
    # network byte order.
    #
    def network_byte_order_selected?
      return @byte_order == '>'
    end

    #
    # Returns whether this byte pool's currently selected byte order is the
    # reverse network byte order.
    #
    def reverse_network_byte_order_selected?
      return @byte_order == '<'
    end

    #
    # Returns whether this byte pool's currently selected byte order is the
    # host system's native byte order.
    #
    def native_byte_order_selected?
      return @byte_order == '!'
    end
  end
end
