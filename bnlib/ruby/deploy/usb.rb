module Butterknife
  module Deploy
    class USB
      require 'fileutils'
      require_relative '../net/ssh'

      def self.listUSB
        if Butterknife::OS.windows?
          require 'win32ole'
          file_system = WIN32OLE.new("Scripting.FileSystemObject")
          drives = file_system.Drives
          drive_arr = []
          drives.each {|dr| drive_arr.push dr}
          return drive_arr.map {|drive| { path: drive.Path, name: drive.VolumeName }}
        else
          drives = `df`
          devices = []
          drives.split /\r\n|\r/ do |item|
            i_s = item.split /\s/
            devices.push ({ path: i_s.last, name: i_s.last.split(/\//).last })
          end
          return devices
        end
      end

      def self.selectUSB list
        puts "\nPlease select the USB Device you wish to use...".magenta
        list.each_with_index do |devicel, i|
          puts "\t[#{i}]<magenta> #{devicel[:name]}<cyan> (#{devicel[:path]})<magenta>".format
        end
        user_selection = gets.chop!.to_i
        if user_selection >= list.length
          puts "Invalid Device".red
          return selectUSB list
        else
          return list[user_selection]
        end
      end

      def self.copyresources usb
        usb_root = File.join usb[:path], "toast_butterknife_deploy"
        Butterknife::Util.copy_resources usb_root
      end

      puts "USB Drive Deployment is done by copying Toast files to a USB Drive, then plugging that USB drive into the RoboRIO to copy the files over.".green
      puts "Please ensure your USB Device is NOT plugged into your computer... (hit <brown>ENTER<cyan> when ready)<brown>".format
      gets
      prelist = listUSB
      puts "Please plug your USB Device into your computer now... (hit <brown>ENTER<cyan> when ready)<brown>".format
      gets
      list = listUSB - prelist

      device = nil
      if list.length == 0
        puts "Could not find any USB Devices. Hit ENTER to exit".red
        gets; exit
      elsif list.length == 1
        device = list[0]
      else
        device = selectUSB list
      end
      puts "Using USB Device: <green>#{device[:name]}<cyan> (#{device[:path]})<magenta>".format
      copyresources device
      puts "Please remove your USB Drive and plug it in to the RoboRIO, then connect your Computer to the same network as the RoboRIO (hit <brown>ENTER<cyan> when ready)<brown>".format
      gets
      Butterknife::Network::SSH.connect do |ssh|
        output == ssh.exec!("(cd /U/toast_butterknife_deploy && chmod +x load.sh && ./load.sh)")
        puts output.magenta
      end
      puts "Deployment Successful!".green
      gets
    end
  end
end
