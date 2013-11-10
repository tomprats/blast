class Enemy
  SIZE = 32
  SPEED = 2

  attr_reader :x, :y
  def initialize(x, y)
    @x = x
    @y = y
  end

  def x1
    @x
  end

  def x2
    @x + SIZE
  end

  def y1
    @y
  end

  def y2
    @y + SIZE
  end

  def draw(window)
    color = Gosu::Color::BLUE

    window.draw_quad(
      x1, y1, color,
      x1, y2, color,
      x2, y2, color,
      x2, y1, color,
    )
  end

  def left!
    @x -= SPEED

    @x = 0 if @x < 0
  end

  def right!
    @x += SPEED

    @x = Blast::WIDTH - SIZE if @x > Blast::WIDTH - SIZE
  end

  def up!
    @y -= SPEED

    @y = Blast::HEIGHT - LIMIT if @y < Blast::HEIGHT - LIMIT
  end

  def down!
    @y += SPEED

    @y = Blast::HEIGHT - SIZE if @y > Blast::HEIGHT - SIZE
  end
end
