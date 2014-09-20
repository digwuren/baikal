module Baikal
  #
  # Hexdumps bytes from +data_source+ into the given +port+ (by default,
  # +$stdout+) using the given format (by default, +DEFAULT_HEXDUMP_FORMAT+).
  # Uses the +length+ method of +data_source+ to determine byte count and the
  # +[]+ method with integer range arguments to extract row-sized slices.
  # +data_source+ being a +String+ instance behaves as expected.
  #
  def Baikal::hexdump data_source, port = $stdout, format = Hexdump::DEFAULT_HEXDUMP_FORMAT
    row = Hexdump::Row.new
    row.expected_size = format.bytes_per_row
    # iterate over rows
    row.offset = 0
    block_row_counter = 0
    while row.offset < data_source.bytesize do
      if format.rows_per_block != 0 then
        block_row_counter += 1
        if block_row_counter == format.rows_per_block then
          port.puts # block separator
          block_row_counter = 0
        end
      end
      row.data = data_source.unpack "@#{row.offset} C#{format.bytes_per_row}"
      format.format_row row, port
      row.offset += format.bytes_per_row
    end
    return
  end

  module Hexdump
    #
    # Represents the row currently being processed by +hexdump+.
    #
    class Row
      #
      # Offset of the first byte on this row.
      #
      attr_accessor :offset

      #
      # The row's expected size, as per +Hexdump::Format#bytes_per_row+.
      #
      attr_accessor :expected_size

      #
      # Bytes of this row in an +Array+ instance.  For the last row, some of
      # the trailing elements may be +nil+.
      #
      attr_accessor :data
    end

    #
    # Represents a particular field of a hexdump format.  Abstract class; see
    # +Field::Offset+, +Field::Decoration+, and +Field::Data+ as practical
    # hexdump fields.
    #
    class Field
      #
      # Returns a string representing this field's contribution to dumping
      # +row+, an instance of +Hexdump::Row+
      #
      def format row
      end

      #
      # The +Offset+ field outputs the offset of a hexdump row, formatted
      # via a printf template.
      #
      class Offset < Field
        def initialize template
          super()
          @template = template
          return
        end

        def format row
          return sprintf(@template, row.offset)
        end
      end

      #
      # The +Decoration+ field outputs a literal string.
      #
      class Decoration < Field
        def initialize content
          super()
          @content = content
          return
        end

        def format row
          return @content
        end
      end

      #
      # The +Data+ field outputs data on a hexdump row, formatted using a
      # supplied +Proc+ instance.  +grouping_rules+ are specified as
      # pairs of group size and separator.  All group sizes are processed
      # in parallel.  In group boundaries where multiple grouping rules
      # would match, only the leftmost one is used.
      #
      class Data < Field
        def initialize formatter, *grouping_rules
          super()
          @formatter = formatter
          @grouping_rules = grouping_rules
          return
        end

        def format row
          output = ""
          (0 ... row.expected_size).each do |column|
            if column != 0 then
              rule = @grouping_rules.detect{|divisor, separator| column % divisor == 0}
              output << rule[1] if rule
            end
            output << @formatter.call(row.data[column])
          end
          return output
        end

        #
        # Formats the byte as a zero-padded two-digit lowercase hexadecimal number.
        #
        # :stopdoc: Unfortunately, RDoc gets confused by thunk constants.
        LOWERCASE_HEX = proc do |value|
          if value then
            raise 'Type mismatch' unless value.is_a? Integer
            sprintf("%02x", value)
          else
            "  "
          end
        end

        #
        # Formats the byte as a zero-padded two-digit uppercase hexadecimal number.
        #
        UPPERCASE_HEX = proc do |value|
          if value then
            raise 'Type mismatch' unless value.is_a? Integer
            sprintf("%02X", value)
          else
            "  "
          end
        end

        #
        # Formats the byte as a zero-padded three-digit octal number.
        #
        OCTAL = proc do |value|
          if value then
            raise 'Type mismatch' unless value.is_a? Integer
            sprintf("%03o", value)
          else
            "   "
          end
        end

        #
        # Formats the byte as a space-padded three-digit decimal number.
        #
        DECIMAL = proc do |value|
          if value then
            raise 'Type mismatch' unless value.is_a? Integer
            sprintf("%3i", value)
          else
            "   "
          end
        end

        #
        # Formats the byte as an ASCII character.  Nonprintable characters are
        # replaced by a period.
        #
        ASCII = proc do |value|
          if value then
            raise 'Type mismatch' unless value.is_a? Integer
            value >= 0x20 && value <= 0x7E ? value.chr : "."
          else
            " "
          end
        end

        #
        # Decodes the byte as a Latin-1 character and formats it in UTF-8.
        # Nonprintable characters are replaced by a period, as in
        # +ASCII+.
        #
        LATIN1 = proc do |value|
          if value then
            raise 'Type mismatch' unless value.is_a? Integer
            if (0x20 .. 0x7E).include? value or (0xA0 .. 0xFF).include? value then
              [value].pack('U')
            else
              "."
            end
          else
            " "
          end
        end

        # :startdoc:
      end
    end

    #
    # Describes a textual hexdump format.
    #
    class Format
      attr_reader :rows_per_block # zero indicates no block separation
      attr_reader :bytes_per_row # zero indicates no group separation
      attr_reader :fields

      #
      # Creates a new +Hexdump::Format+ instance with the specified structure.
      # +bytes_per_row+ specifies the number of bytes to be listed on every
      # row; +fields+ (a list of +Hexdump::Field+ instances) contains the
      # formatting rules.  +rows_per_block+, if given and nonzero, will cause
      # an empty line to be printed after every block of that many rows.
      #
      def initialize bytes_per_row, fields, rows_per_block = 0
        super()
        @bytes_per_row = bytes_per_row
        @fields = fields
        @rows_per_block = rows_per_block
        return
      end

      #
      # Formats a given +row+ (an instance of +Hexdump::Row+) according to
      # formatting rules embodied in this +Hexdump_Format+ instance and
      # outputs the result into the given +port+
      #
      def format_row row, port
        raise 'Type mismatch' unless row.is_a? Hexdump::Row
        port.puts @fields.map{|field| field.format(row)}.join('')
        return
      end
    end

    #
    # The default hexdump format uses five-digit offsets (fits up to a
    # mebibyte of data, which should be enough for everybody) and lists the
    # content on sixteen bytes per row, both in hexadecimal (grouped by
    # four bytes) and ASCII-or-dot form.
    #
    DEFAULT_HEXDUMP_FORMAT = Format.new(16, [
      Field::Offset.new("%05X: "),
      Field::Data.new(Field::Data::UPPERCASE_HEX, [4, '  '], [1, ' ']),
      Field::Decoration.new("  "),
      Field::Data.new(Field::Data::ASCII),
    ])
  end
end
