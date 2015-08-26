require 'open-uri'
require 'openssl'
require 'fileutils'
NO_VERIFY =  {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}

module Butterknife
  module Fetch
    class Toast

      def self.download_latest
        ENV["TOAST_LOCAL"] = "INSTALLED"
        pre = Butterknife.options[:pre]
        puts "Checking for Toast#{pre ? ' Pre-Release' : ''} Version...<cyan>".format
        update = !(File.exist? "bnlib/meta.txt")

        latest = "https://dev.imjac.in/toast/latest.php"
        latest += "?pre=true" if pre
        latest_dl = latest
        latest_dl += "#{pre ? '&' : '?'}dl=true"

        latestvers = open(latest, NO_VERIFY).read

        if update
          puts "No local Toast Installation found... Updating...".cyan
          ENV["TOAST_LOCAL"] = "NONE"
          dl(latest, latest_dl); return
        end

        stored_version = File.read("bnlib/meta.txt")
        puts "Latest Toast Version:<green> #{latestvers}<cyan>, Local: <green>#{stored_version}<cyan>".format

        unless stored_version == latestvers
          puts "Toast Version out of date! Would you like to update? <red>(Y/N)<cyan>".format
          input = gets.chop!
          if input =~ /y(es)?/i || input =~ //
            dl(latest, latest_dl)
          end
        end
      end

      def self.dl latest, latest_dl
        puts "Downloading Latest Version of Toast...".green
        target = "bnlib/bin/root/home/lvuser/"
        FileUtils.mkdir_p target
        target += "FRCUserProgram.jar"
        File.delete target if File.exist? target
        File.open(target, "wb") do |local_file|
          open(latest_dl, "rb", ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE) do |read_file|
            local_file.write(read_file.read)
          end
        end
        dl_vers = open(latest, NO_VERIFY).read
        File.write("bnlib/meta.txt", dl_vers)
        puts "Successfully downloaded Toast #{dl_vers}".cyan
      end

    end
  end
end
