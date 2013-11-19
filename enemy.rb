class Enemy
  SIZE = 32
  SPEED = 2

  attr_reader :x, :y
  def initialize(x, y)
    @x = x
    @y = y
    @step = 0
    @fire = false
    @fire_time = rand(300)
    @bottom = false
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

  def fire?
    if @fire
      @fire = false
      true
    else
      false
    end
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

  def update!(ai = 1)
    case ai
    when 1
      levelOne
    else
      levelOne
    end
    @step += 1
  end

  def levelOne
    case @step % 100
    when 0..10, 90..100
      right!
    when 10..30
      left!
    when 50..70
      up!
    when 30..50, 70..90
      down!
    end
    @step = -1 if @step > 299
    fire!
  end

  def won?
    @bottom
  end

  def fire!
    if @step == @fire_time
      @fire = true
    end
  end

  def left!
    @x -= SPEED
  end

  def right!
    @x += SPEED
  end

  def up!
    @y -= SPEED
  end

  def down!
    @y += SPEED

    @bottom = true if @y > Blast::HEIGHT - SIZE
  end
end
