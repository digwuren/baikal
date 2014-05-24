== DESCRIPTION

Baikal is a basic Ruby library for constructing, parsing and modifying binary
objects ('blobs') in a linear manner.  Its primary use is facilitating custom
bytecode engines.

== SYNOPSIS

  require 'baikal'
 
  pool = Baikal::Pool.new
  pool.go_network_byte_order
  pool.emit_wyde(42)
  pool.emit_blob "Yellow."
 
  open 'dump', 'wb' do |port|
    port.print pool.bytes
  end

== REQUIREMENTS

Baikal is implemented in plain Ruby.

The String#pack interface Baikal uses appeared in Ruby 1.9.3.

Ruby 2.1 or later is needed to manipulate octabytes in the native byte order.
Octabytes in an explicit BigEndian or LittleEndian byte order should work with
1.9.3 or later.

== LICENSE

Copyright (c) 2009-2014 by Andres Soolo <dig@mirky.net>.

Baikal is free software, licensed under the GNU General Public License version 3.
