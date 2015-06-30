module Butterknife
  module OS
    def OS.windows?
      (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
    end

    def OS.mac?
     (/darwin/ =~ RUBY_PLATFORM) != nil
    end

    def OS.unix?
      !OS.windows?
    end

    def OS.linux?
      OS.unix? and not OS.mac?
    end
  end

  module Util
    def Util.copy_resources dest
      puts "Copying Resources...<green>".format
      FileUtils.rm_rf dest if File.exist? dest
      FileUtils.mkdir dest

      FileUtils.cp_r Dir.glob(File.join(Butterknife::LIBHOME, "bin/*")), dest
      puts "Resources Copied! <cyan>".format
    end
  end
end
