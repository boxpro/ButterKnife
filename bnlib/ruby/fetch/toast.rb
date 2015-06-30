require 'open-uri'
require 'openssl'
require 'fileutils'
NO_VERIFY =  {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}

module Butterknife
  module Fetch
    class Toast

      def self.download_latest
        ENV["TOAST_LOCAL"] = "INSTALLED"
        puts "Checking for Toast Version...<cyan>".format
        update = !(File.exist? "bnlib/meta.txt")
        if update
          puts "No local Toast Installation found... Updating...".cyan
          ENV["TOAST_LOCAL"] = "NONE"
          dl; return
        end

        stored_version = File.read("bnlib/meta.txt")
        latest = open("https://dev.imjac.in/toast/latest.php", NO_VERIFY).read
        puts "Latest Toast Version:<green> #{latest}<cyan>, Local: <green>#{stored_version}<cyan>".format

        unless stored_version == latest
          puts "Toast Version out of date! Would you like to update? <red>(Y/N)<cyan>".format
          input = gets.chop!
          if input =~ /y(es)?/i || input =~ //
            dl
          end
        end
      end

      def self.dl
        puts "Downloading Latest Version of Toast...".green
        target = "bnlib/bin/root/home/lvuser/"
        FileUtils.mkdir_p target
        target += "FRCUserProgram.jar"
        File.delete target if File.exist? target
        File.open(target, "wb") do |local_file|
          open("https://dev.imjac.in/toast/latest.php?dl=true", "rb", ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE) do |read_file|
            local_file.write(read_file.read)
          end
        end
        dl_vers = open("https://dev.imjac.in/toast/latest.php", NO_VERIFY).read
        File.write("bnlib/meta.txt", dl_vers)
        puts "Successfully downloaded Toast #{dl_vers}".cyan
      end

    end
  end
end
