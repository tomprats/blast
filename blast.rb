require "bundler/setup"
require "hasu"

Hasu.load "player.rb"
Hasu.load "bullet.rb"
Hasu.load "enemy.rb"

class Blast < Hasu::Window
  WIDTH = 800
  HEIGHT = 600
  DELAY = 0.25
  PAUSE_DELAY = 0.5

  def initialize
    super(WIDTH, HEIGHT, false)
  end

  def reset
    @player = Player.new
    @score = 0
    @level = 1
    @bullets = []
    @enemies = []
    @enemy_bullets = []
    @last_shot = Time.now - DELAY
    @last_pause = Time.now - PAUSE_DELAY
    @dead = false
    @state = "start"
    @wins = 0
    @losses = 0

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
    @enemy_bullets.each do |bullet|
      bullet.draw(self)
    end

    @font.draw("Wins: #{@wins}        Losses: #{@losses}", 20, 10, 0)
    @font.draw("Score: #{@score}", WIDTH-120, 10, 0)
    if !started?
      text = "Press P to Start"
      @font.draw(text, WIDTH/2 - @font.text_width(text)/2, HEIGHT/2 + 100, 0)
    elsif won?
      text = "YOU WON"
      @font.draw(text, WIDTH/2 - @font.text_width(text)/2, HEIGHT/2 + 100, 0)
      text = "Press P to Restart"
      @font.draw(text, WIDTH/2 - @font.text_width(text)/2, HEIGHT/2 + 140, 0)
    elsif lost?
      text = "YOU LOST"
      @font.draw(text, WIDTH/2 - @font.text_width(text)/2, HEIGHT/2 + 100, 0)
      text = "Press P to Restart"
      @font.draw(text, WIDTH/2 - @font.text_width(text)/2, HEIGHT/2 + 140, 0)
    elsif paused?
      text = "PAUSED"
      @font.draw(text, WIDTH/2 - @font.text_width(text)/2, HEIGHT/2 + 100, 0)
      text = "Press P to Unpause"
      @font.draw(text, WIDTH/2 - @font.text_width(text)/2, HEIGHT/2 + 140, 0)
    end
  end

  def update
    if running?
      @bullets.each do |bullet|
        @bullets.delete(bullet) if bullet.update!
      end
      @enemy_bullets.each do |bullet|
        @enemy_bullets.delete(bullet) if bullet.update!
      end
      @enemies.each do |enemy|
        enemy.update!
        @dead = true if enemy.won?
        enemy_fire!(enemy) if enemy.fire?
        @bullets.each do |bullet|
          if bullet.intersects?(enemy)
            @enemies.delete(enemy)
            @bullets.delete(bullet)
            @score += 1
          end
        end
      end
      @enemy_bullets.each do |bullet|
        if bullet.intersects?(@player)
          @enemy_bullets.delete(bullet)
          @dead = true
        end
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
      if button_down?(Gosu::KbP)
        pause!
      end

      if @enemies.length.zero?
        win!
      end
      if @dead
        lose!
      end
    else
      if button_down?(Gosu::KbP)
        unpause!
      end
    end
  end

  def button_down(button)
    case button
    when Gosu::KbEscape
      close
    end
  end

  def pause!
    if(@last_pause < Time.now - PAUSE_DELAY)
      @state = "paused"
      @last_pause = Time.now
    end
  end
  def unpause!
    if(@last_pause < Time.now - PAUSE_DELAY)
      @state = "running"
      @last_pause = Time.now
    end
  end
  def win!
    @state = "won"
    @level += 1
    @wins += 1
    reset_enemies
  end
  def lose!
    @state = "lost"
    @dead = false
    @losses += 1
    reset_enemies
  end

  def paused?
    @state == "paused"
  end
  def won?
    @state == "won"
  end
  def lost?
    @state == "lost"
  end
  def running?
    @state == "running"
  end
  def started?
    @state != "start"
  end

  def enemy_fire!(enemy)
    @enemy_bullets.push(Bullet.new(enemy.x_middle, enemy.y, true))
  end

  def shoot!
    if(@last_shot < Time.now - DELAY)
      @bullets.push(Bullet.new(@player.x_middle, @player.y))
      @last_shot = Time.now
    end
  end

  def reset_enemies
    @bullets = []
    @enemy_bullets = []
    @enemies = []
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
