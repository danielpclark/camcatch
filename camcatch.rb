# The MIT License

require 'highline/import'
require 'hornetseye_v4l2'
require 'hornetseye_xorg'
include Hornetseye
$camera = V4L2Input.new '/dev/video0' do |modes|
  modes.each_with_index { |mode,i| puts "#{i + 1}: #{mode[0]} #{mode[1]}x#{mode[2]}" }
  modes[ask("Mode: ").to_i - 1]
end

def option0 # Normal
	$camera.read
end

def option1 #Constant Mask
	bg = nil
	bg = $camera.read_sint
	($camera.read_ubyte - bg).abs
end
$bg2 = nil
def bg2o
	if $bg2.nil?
		$bg2 = $camera.read_sint
	end
end
def option2 #Mask Imprint
	bg2o
	($camera.read_ubyte - $bg2).abs
end

def option3
	bg2o
	($camera.read_ubyte - $bg2).gauss_blur( 2 ).abs
end

opt = "option#{ask("0: Normal\n1: Constant Mask\n2: Mask Imprint\n3: Gaussion Mask\n#: ")}"
X11Display.show { eval(opt) }
