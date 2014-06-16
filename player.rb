class Player
  SIZE = 32
  SPEED = 6
  LIMIT = 200
  COLOR = Gosu::Color::WHITE

  attr_reader :x, :y
  def initialize
    reset!
  end

  def reset!
    @x = Blast::WIDTH/2 - SIZE/2
    @y = Blast::HEIGHT - SIZE
  end

  def x_middle
    @x + SIZE/2
  end

  def y_middle
    @y + SIZE/2
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

  def draw(window, powerup)
    window.draw_quad(
      x1, y1, COLOR,
      x1, y2, COLOR,
      x2, y2, COLOR,
      x2, y1, COLOR,
    )

    if powerup
      color = powerup.color
      window.draw_quad(
        x1+5, y1+5, color,
        x1+5, y2-5, color,
        x2-5, y2-5, color,
        x2-5, y1+5, color,
      )
    end
  end

  def update(options={})
    left! if options[:left]
    right! if options[:right]
    up! if options[:up]
    down! if options[:down]
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
