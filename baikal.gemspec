Gem::Specification.new do |s|
    s.name = 'baikal'
    s.version = '1.1.0'
    s.date = '2014-05-24'
    s.homepage = 'https://github.com/digwuren/baikal'
    s.summary = 'A blob handling toolkit'
    s.author = 'Andres Soolo'
    s.email = 'dig@mirky.net'
    s.files = IO::read('Manifest.txt').split(/\n/)
    s.license = 'GPL-3'
    s.description = <<EOD
Baikal is a Ruby library for constructing, parsing and modifying binary objects
('blobs') in a linear manner.  Its primary use is facilitating custom bytecode
engines.
EOD
    # s.require_path = 'lib'
    s.test_files = ['test/test_baikal.rb']
    s.has_rdoc = true
    s.extra_rdoc_files = ['README.txt']
end
