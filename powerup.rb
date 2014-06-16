class Powerup
  HEIGHT = 8
  WIDTH = 8
  SPEED = 6
  LIFE = 3

  attr_reader :x, :y
  def self.setup(x, y)
    case rand(2)
    when 0
      RapidFire.new(x, y)
    when 1
      Invincible.new(x, y)
    end
  end

  def initialize(x, y)
    @x = x - WIDTH/2
    @y = y - HEIGHT/2
    @time = Time.now
  end

  def x1
    @x
  end

  def x2
    @x + WIDTH
  end

  def y1
    @y
  end

  def y2
    @y + HEIGHT
  end

  def color
    @color
  end

  def type
    @type
  end

  def invincible?
    @type == :invincible
  end

  def rapid_fire?
    @type == :rapid_fire
  end

  def draw(window)
    window.draw_quad(
      x1, y1, @color,
      x1, y2, @color,
      x2, y2, @color,
      x2, y1, @color,
    )
  end

  def done?
    Time.now - @time > LIFE
  end

  def update!
    @y += SPEED/2

    # Return if it is out of the window
    @y <= 0
  end

  def intersects?(object)
    x1 < object.x2 &&
      x2 > object.x1 &&
      y1 < object.y2 &&
      y2 > object.y1
  end
end

class RapidFire < Powerup
  def initialize(x, y)
    @type = :rapid_fire
    @color = Gosu::Color::BLUE
    super
  end
end

class Invincible < Powerup
  def initialize(x, y)
    @type = :invincible
    @color = Gosu::Color::GREEN
    super
  end
end
