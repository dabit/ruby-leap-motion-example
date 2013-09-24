require 'artoo'
require 'csv'

#
# Write the data from the Leap into a CSV file
# to plot it with 3D graphing software.
#

FILE_NAME = 'data.txt'
File.unlink FILE_NAME if File.exists? FILE_NAME

connection :leapmotion, :adaptor => :leapmotion, :port => '127.0.0.1:6437'
device     :leapmotion, :driver  => :leapmotion

work do
  on leapmotion, :frame => :on_frame
end

def on_frame(*args)
  frame      = args[1]
  pointables = frame.pointables
  gestures   = frame.gestures

  #
  # Ideally you only want to track one of these:
  #

  #
  # Unconmment if you want to track finger movement
  #
  track_pointables(pointables)

  #
  # Uncomment if you want to track gestures
  #
  #track_gestures(gestures)
end

def track_pointables(pointables)
  pointables.each do |pointable|
    #puts pointable.instance_variables.inspect
    write_pointable_csv(pointable)
  end
end

def track_gestures(gestures)
  gestures.each do |gesture|
    write_gesture_csv gesture
  end
end

def write_pointable_csv(pointable)
  CSV.open FILE_NAME, 'a+' do |csv|
    puts pointable.stabilizedTipPosition.inspect
    csv << pointable.stabilizedTipPosition
  end
end

def write_gesture_csv(gesture)
  if gesture.is_a? Artoo::Drivers::Leapmotion::Gesture::Swipe
    if gesture.state == "stop"
      #debug(gesture)
      puts "Swipe"
      CSV.open FILE_NAME, 'a+' do |csv|
        csv << gesture.startPosition
        csv << gesture.position
      end
    end
  end
end

def debug(gesture)
  puts gesture.startPosition.inspect
  puts gesture.position.inspect
  puts gesture.direction.inspect
  puts gesture.type.inspect
  puts gesture.state.inspect
end
