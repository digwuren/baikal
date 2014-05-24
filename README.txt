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

== LICENSE

Copyright (c) 2009-2014 by Andres Soolo <dig@mirky.net>.

Baikal is free software, licensed under the GNU General Public License version 3.
