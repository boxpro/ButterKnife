begin
  gem "rubyzip"
rescue
  `gem install rubyzip`
  exec "ruby build.rb"
end

require "zip"
require "fileutils"

def del path
  File.delete path if File.exist? path
end

del "bnlib/meta.txt"
del "bnlib/bin/root/home/lvuser/FRCUserProgram.jar"

` ruby butterknife -build `
files = ['butterknife', 'butterknife.exe', Dir["bnlib/**/*"], "quickstart.txt"].flatten!
files = files - Dir["bnlib/build/*"]

FileUtils.mkdir "out" unless File.exist? "out"
del "out/ButterKnife.zip"
Zip::File.open("out/ButterKnife.zip", Zip::File::CREATE) do |zip|
  files.each do |fn|
    zip.add(fn, File.absolute_path(fn))
  end
end
