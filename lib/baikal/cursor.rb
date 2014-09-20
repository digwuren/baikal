require_relative '../baikal'

module Baikal
  #
  # Represents an offset into a byte pool, permitting traversing the byte
  # pool in a linear manner.
  #
  class Cursor
    #
    # The cursor's current offset into the underlying byte pool.
    #
    attr_accessor :offset

    #
    # Creates a cursor of the given +pool+, initialising it to point at
    # its given +offset+.  If +offset+ is not given, defaults to zero, that
    # is to say, the byte pool's beginning.
    #
    def initialize pool, offset = 0
      raise 'Type mismatch' unless pool.is_a? Baikal::Pool
      raise 'Type mismatch' unless offset.is_a? Integer
      super()
      @pool = pool
      @offset = offset
      return
    end

    #
    # Retrieves an unsigned byte from the underlying pool's current
    # position and advances the cursor by one byte.
    #
    # Error if the byte referred to by this cursor lies outside the
    # boundaries of the underlying pool.
    #
    def parse_unsigned_byte
      value = @pool.get_unsigned_byte(@offset)
      @offset += 1
      return value
    end

    #
    # Retrieves an unsigned wyde from the underlying pool's current
    # position using the pool's currently selected byte order and advances
    # the cursor by two bytes.
    #
    # Error if the wyde referred to by this cursor lies outside the
    # boundaries of the underlying pool, even partially.
    #
    def parse_unsigned_wyde
      value = @pool.get_unsigned_wyde(@offset)
      @offset += 2
      return value
    end

    #
    # Retrieves an unsigned tetrabyte from the underlying pool's current
    # position using the pool's currently selected byte order and advances
    # the cursor by four bytes.
    #
    # Error if the tetra referred to by this cursor lies outside the
    # boundaries of the underlying pool, even partially.
    #
    def parse_unsigned_tetra
      value = @pool.get_unsigned_tetra(@offset)
      @offset += 4
      return value
    end

    #
    # Retrieves an unsigned octabyte from the underlying pool's current
    # position using the pool's currently selected byte order and advances
    # the cursor by eight bytes.
    #
    # Error if the octa referred to by this cursor lies outside the
    # boundaries of the underlying pool, even partially.
    #
    def parse_unsigned_octa
      value = @pool.get_unsigned_octa(@offset)
      @offset += 8
      return value
    end

    #
    # Retrieves a signed byte from the underlying pool's current position
    # and advances the cursor by one byte.
    #
    # Error if the byte referred to by this cursor lies outside the
    # boundaries of the underlying pool.
    #
    def parse_signed_byte
      value = @pool.get_signed_byte(@offset)
      @offset += 1
      return value
    end

    #
    # Retrieves a signed wyde from the underlying pool's current position
    # using the pool's currently selected byte order and advances the
    # cursor by two bytes.
    #
    # Error if the wyde referred to by this cursor lies outside the
    # boundaries of the underlying pool, even partially.
    #
    def parse_signed_wyde
      value = @pool.get_signed_wyde(@offset)
      @offset += 2
      return value
    end

    #
    # Retrieves a signed tetrabyte from the underlying pool's current
    # position using the pool's currently selected byte order and advances
    # the cursor by four bytes.
    #
    # Error if the tetra referred to by this cursor lies outside the
    # boundaries of the underlying pool, even partially.
    #
    def parse_signed_tetra
      value = @pool.get_signed_tetra(@offset)
      @offset += 4
      return value
    end

    #
    # Retrieves a signed octabyte from the underlying pool's current
    # position using the pool's currently selected byte order and advances
    # the cursor by eight bytes.
    #
    # Error if the octa referred to by this cursor lies outside the
    # boundaries of the underlying pool, even partially.
    #
    def parse_signed_octa
      value = @pool.get_signed_octa(@offset)
      @offset += 8
      return value
    end

    #
    # Retrieves an unsigned byte from the underlying pool's current
    # position.  Does not affect the position.
    #
    # Error if the byte referred to by this cursor lies outside the
    # boundaries of the underlying pool.
    #
    def peek_unsigned_byte
      return @pool.get_unsigned_byte(@offset)
    end

    #
    # Retrieves an unsigned wyde from the underlying pool's current
    # position using the pool's currently selected byte order.  Does not
    # affect the position.
    #
    # Error if the wyde referred to by this cursor lies outside the
    # boundaries of the underlying pool, even partially.
    #
    def peek_unsigned_wyde
      return @pool.get_unsigned_wyde(@offset)
    end

    #
    # Retrieves an unsigned tetrabyte from the underlying pool's current
    # position using the pool's currently selected byte order.  Does not
    # affect the position.
    #
    # Error if the tetra referred to by this cursor lies outside the
    # boundaries of the underlying pool, even partially.
    #
    def peek_unsigned_tetra
      return @pool.get_unsigned_tetra(@offset)
    end

    #
    # Retrieves an unsigned octabyte from the underlying pool's current
    # position using the pool's currently selected byte order.  Does not
    # affect the position.
    #
    # Error if the octa referred to by this cursor lies outside the
    # boundaries of the underlying pool, even partially.
    #
    def peek_unsigned_octa
      return @pool.get_unsigned_octa(@offset)
    end

    #
    # Retrieves a signed byte from the underlying pool's current position.
    # Does not affect the position.
    #
    # Error if the byte referred to by this cursor lies outside the
    # boundaries of the underlying pool.
    #
    def peek_signed_byte
      return @pool.get_signed_byte(@offset)
    end

    #
    # Retrieves a signed wyde from the underlying pool's current position
    # using the pool's currently selected byte order.  Does not affect the
    # position.
    #
    # Error if the wyde referred to by this cursor lies outside the
    # boundaries of the underlying pool, even partially.
    #
    def peek_signed_wyde
      return @pool.get_signed_wyde(@offset)
    end

    #
    # Retrieves a signed tetrabyte from the underlying pool's current
    # position using the pool's currently selected byte order.  Does not
    # affect the position.
    #
    # Error if the tetra referred to by this cursor lies outside the
    # boundaries of the underlying pool, even partially.
    #
    def peek_signed_tetra
      return @pool.get_signed_tetra(@offset)
    end

    #
    # Retrieves a signed octabyte from the underlying pool's current
    # position using the pool's currently selected byte order.  Does not
    # affect the position.
    #
    # Error if the octa referred to by this cursor lies outside the
    # boundaries of the underlying pool, even partially.
    #
    def peek_signed_octa
      return @pool.get_signed_octa(@offset)
    end

    #
    # Retrieves an unsigned integer of the given +size+ (which must be +1+,
    # +2+, +4+ or +8+) from the underlying pool's current position using the
    # pool's currently selected byte order and advances the cursor by the
    # integer's size.
    #
    # Error if the integer of this size referred to by this cursor lies
    # outside the boundaries of the underlying pool, even partially.
    #
    def parse_unsigned_integer size
      value = @pool.get_unsigned_integer(size, @offset)
      @offset += size
      return value
    end

    #
    # Retrieves a specified number of bytes from the underlying pool's
    # current position and advances the cursor by the same number.
    #
    # Error if the blob referred to by this cursor and this byte count lies
    # outside the boundaries of the underlying pool, even partially.
    #
    def parse_blob size
      raise 'Type mismatch' unless size.is_a? Integer
      raise 'Invalid blob size' unless size >= 0
      blob = @pool.get_blob(@offset, size)
      @offset += size
      return blob
    end

    #
    # Moves the cursor forwards by +delta+ bytes, passing a part of the
    # byte sequence without parsing.
    #
    # Error if +delta+ is negative.
    #
    def skip delta
      raise 'Type mismatch' unless delta.is_a? Integer
      raise 'Invalid byte count' if delta < 0
      @offset += delta
      return
    end

    #
    # Moves the cursor backwards by +delta+ bytes.
    #
    # Error if +delta+ is negative.
    #
    def unskip delta
      raise 'Type mismatch' unless delta.is_a? Integer
      raise 'Invalid byte count' if delta < 0
      @offset -= delta
      return
    end

    #
    # Returns +true+ if the cursor has passed the last byte currently in
    # the underlying pool or +false+ otherwise.
    #
    def eof?
      return @offset >= @pool.size
    end
  end
end
