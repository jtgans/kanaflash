#
#  rb_main.rb
#  kanaflash
#
#  Created by June Tate-Gans on 1/16/08.
#  Copyright (c) 2008 June Tate-Gans. All rights reserved.
#

require 'osx/cocoa'
include OSX

$KCODE="utf8"

def rb_main_init
  path = OSX::NSBundle.mainBundle.resourcePath.fileSystemRepresentation
  rbfiles = Dir.entries(path).select {|x| /\.rb\z/ =~ x}
  rbfiles -= [ File.basename(__FILE__) ]
  rbfiles.each do |path|
    require( File.basename(path) )
  end
end

if $0 == __FILE__ then
  rb_main_init
  OSX.NSApplicationMain(0, nil)
end
