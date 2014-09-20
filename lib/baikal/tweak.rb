require_relative '../baikal'

module Baikal
  class Pool
    #
    # Fetches an unsigned byte from +offset+ in this byte pool, calls
    # +thunk+ with the byte as its argument, and stores the result of
    # calling +thunk+ as a byte at the same +offset+.
    #
    # Error if the byte lies outside this byte pool.
    #
    def tweak_unsigned_byte offset, &thunk
      set_byte offset, yield(get_unsigned_byte(offset))
      return
    end

    #
    # Fetches a signed byte from +offset+ in this byte pool, calls +thunk+
    # with the byte as its argument, and stores the result of calling
    # +thunk+ as a byte at the same +offset+.
    #
    # Error if the byte lies outside this byte pool.
    #
    def tweak_signed_byte offset, &thunk
      set_byte offset, yield(get_signed_byte(offset))
      return
    end

    #
    # Fetches an unsigned wyde from +offset+ in this byte pool, calls
    # +thunk+ with the wyde as its argument, and stores the result of
    # calling +thunk+ as a wyde at the same +offset+.
    #
    # Error if the wyde lies outside this byte pool, even partially.
    #
    def tweak_unsigned_wyde offset, &thunk
      set_wyde offset, yield(get_unsigned_wyde(offset))
      return
    end

    #
    # Fetches a signed wyde from +offset+ in this byte pool, calls +thunk+
    # with the wyde as its argument, and stores the result of calling
    # +thunk+ as a wyde at the same +offset+.
    #
    # Error if the wyde lies outside this byte pool, even partially.
    #
    def tweak_signed_wyde offset, &thunk
      set_wyde offset, yield(get_signed_wyde(offset))
      return
    end

    #
    # Fetches an unsigned tetra from +offset+ in this byte pool, calls
    # +thunk+ with the tetra as its argument, and stores the result of
    # calling +thunk+ as a tetra at the same +offset+.
    #
    # Error if the tetra lies outside this byte pool, even partially.
    #
    def tweak_unsigned_tetra offset, &thunk
      set_tetra offset, yield(get_unsigned_tetra(offset))
      return
    end

    #
    # Fetches a signed tetra from +offset+ in this byte pool, calls +thunk+
    # with the tetra as its argument, and stores the result of calling
    # +thunk+ as a tetra at the same +offset+.
    #
    # Error if the tetra lies outside this byte pool, even partially.
    #
    def tweak_signed_tetra offset, &thunk
      set_tetra offset, yield(get_signed_tetra(offset))
      return
    end

    #
    # Fetches an unsigned octa from +offset+ in this byte pool, calls
    # +thunk+ with the octa as its argument, and stores the result of
    # calling +thunk+ as a octa at the same +offset+.
    #
    # Error if the octa lies outside this byte pool, even partially.
    #
    def tweak_unsigned_octa offset, &thunk
      set_octa offset, yield(get_unsigned_octa(offset))
      return
    end

    #
    # Fetches a signed octa from +offset+ in this byte pool, calls +thunk+
    # with the octa as its argument, and stores the result of calling
    # +thunk+ as a octa at the same +offset+.
    #
    # Error if the octa lies outside this byte pool, even partially.
    #
    def tweak_signed_octa offset, &thunk
      set_octa offset, yield(get_signed_octa(offset))
      return
    end
  end
end
