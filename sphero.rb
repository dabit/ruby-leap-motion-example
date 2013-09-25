require 'bundler'

Bundler.setup

require 'artoo'

class SpheroRobot < Artoo::Robot
  connection :sphero, adaptor: :sphero, port: '4321'
  device :sphero, driver: :sphero

  attr_accessor :move

  work do
    every(3.seconds) do
      if self.move
        sphero.set_color(rand(250), rand(250), rand(250))
        sphero.roll 90, self.move
        self.move = nil
      else
        sphero.stop
      end
    end
  end

  def go_left
    p "Sphero go left"
    self.move = 0
  end

  def go_right
    p "Sphero go right"
    self.move = 180
  end

  def go_up
    p "Sphero go up"
    self.move = 90
  end

  def go_down
    p "Sphero go down"
    self.move = 270
  end
end

class LeapMotionRobot < Artoo::Robot
  attr_accessor :sphero

  connection :leapmotion, adaptor: :leapmotion, port: '6437'
  device     :leapmotion, driver: :leapmotion

  work do
    on leapmotion, frame: :on_frame
  end

  def on_frame(*args)
    frame      = args[1]
    gestures   = frame.gestures
    unless gestures.empty?
      gesture = gestures.first
      if gesture.respond_to?(:state) && gesture.state == "stop"
        direction = gesture.direction - gesture.position
        p direction
        if direction.first > 0.5 and direction.first < 1
          p "Der"
          self.sphero.go_right
        elsif direction.first < -0.5 and direction.first > -1
          p "Izq"
          self.sphero.go_left
        elsif direction.last > 0.5 and direction.last < 1
          p "Down"
          self.sphero.go_down
        elsif direction.last < -0.5 and direction.last > -1
          p "Up"
          self.sphero.go_up
        end
      end
    end
  end
end

@sphero = SpheroRobot.new
@leap   = LeapMotionRobot.new
@leap.sphero = @sphero

LeapMotionRobot.work!([@leap, @sphero])
