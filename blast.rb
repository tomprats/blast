require "bundler/setup"
require "hasu"

Hasu.load "player.rb"
Hasu.load "bullet.rb"
Hasu.load "enemy.rb"

class Blast < Hasu::Window
  WIDTH = 800
  HEIGHT = 600
  DELAY = 0.25

  def initialize
    super(WIDTH, HEIGHT, false)
  end

  def reset
    @player = Player.new
    @score = 0
    @level = 1
    @bullets = []
    @enemies = []
    @last_shot = Time.now - DELAY

    reset_enemies

    @font = Gosu::Font.new(self, "Arial", 30)
  end

  def draw
    @player.draw(self)
    @bullets.each do |bullet|
      bullet.draw(self)
    end
    @enemies.each do |enemy|
      enemy.draw(self)
    end

    @font.draw(@score, WIDTH-50, 30, 0)
  end

  def update
    @bullets.each do |bullet|
      @bullets.delete(bullet) if bullet.update!
    end
    @enemies.each do |enemy|
      @bullets.each do |bullet|
        if bullet.intersects?(enemy)
          @enemies.delete(enemy)
          @bullets.delete(bullet)
          @score += 1
        end
      end
    end
    if @enemies.length.zero?
      @level += 1
      reset_level
    end

    if button_down?(Gosu::KbLeft)
      @player.left!
    end
    if button_down?(Gosu::KbRight)
      @player.right!
    end
    if button_down?(Gosu::KbUp)
      @player.up!
    end
    if button_down?(Gosu::KbDown)
      @player.down!
    end

    if button_down?(Gosu::KbSpace)
      shoot!
    end
  end

  def button_down(button)
    case button
    when Gosu::KbEscape
      close
    end
  end

  def shoot!
    if(@last_shot < Time.now - DELAY)
      @bullets.push(Bullet.new(@player.x_middle, @player.y))
      @last_shot = Time.now
    end
  end

  def reset_enemies
    case @level
    when 1
      enemy_file = File.open("level1.txt", "r")
    else
      enemy_file = File.open("level1.txt", "r")
    end

    line_number = 0
    enemy_file.each_line do |line|
      unless line[0] == "#"
        y = line_number*50 + 10
        char_number = 0
        line.each_byte do |j|
          if j.chr == "x"
            x = char_number*50 + 10
            @enemies.push(Enemy.new(x, y))
          end
          char_number += 1
        end
        line_number += 1
      end
    end
  end
end

Blast.run
