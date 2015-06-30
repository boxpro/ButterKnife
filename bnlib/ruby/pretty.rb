class String
  def colorize code, multiplier
    "\033[#{code}m#{self}\033[#{multiplier}m"
  end

  def format
    format_colors self
  end

  def color_m col
    if col != nil
      send col.to_sym
    end
  end

  def black;        colorize 30, 0 end
  def red;          colorize 31, 0 end
  def green;        colorize 32, 0 end
  def brown;        colorize 33, 0 end
  def blue;         colorize 34, 0 end
  def magenta;      colorize 35, 0 end
  def cyan;         colorize 36, 0 end
  def gray;         colorize 37, 0 end
  def bg_black;     colorize 40, 0 end
  def bg_red;       colorize 41, 0 end
  def bg_green;     colorize 42, 0 end
  def bg_brown;     colorize 43, 0 end
  def bg_blue;      colorize 44, 0 end
  def bg_magenta;   colorize 45, 0 end
  def bg_cyan;      colorize 46, 0 end
  def bg_gray;      colorize 47, 0 end
  def bold;         colorize 1, 22 end
  def reverse;      colorize 7, 27 end

end

def format_colors str
  strings = str.split /<([a-zA-Z_]*)>/
  total = ""
  strings.each_with_index do |str, i|
    if i % 2 == 0
      if i == strings.length - 1
        total << str
      else
        total << (str.color_m(strings[i+1]))
      end
    end
  end
  total
end
