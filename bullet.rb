class Bullet
  HEIGHT = 16
  WIDTH = 8
  SPEED = 12

  attr_reader :x, :y
  def initialize(x, y)
    @x = x - WIDTH/2
    @y = y - HEIGHT/2
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

  def draw(window)
    color = Gosu::Color::RED

    window.draw_quad(
      x1, y1, color,
      x1, y2, color,
      x2, y2, color,
      x2, y1, color,
    )
  end

  def update!
    @y -= SPEED

    # Return if it is out of the window
    @y <= HEIGHT
  end

  def intersects?(object)
    x1 < object.x2 &&
      x2 > object.x1 &&
      y1 < object.y2 &&
      y2 > object.y1
  end
end
