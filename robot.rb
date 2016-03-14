class Robot

  class RobotAlreadyDeadError < StandardError; end
  class UnattackableEnemy < StandardError; end
  attr_reader :position, :items, :items_weight, :attack_power
  attr_accessor :equipped_weapon, :shield, :health
  @@robot_list = []
  def initialize
    @position = [0,0]
    @items = []
    @items_weight = 0
    @health = 100
    @attack_power = 5
    @shield = 50
    @@robot_list << self
  end

  def move_left
    @position[0] -= 1
  end 

  def move_right
    @position[0] += 1
  end

  def move_up
    @position[1] += 1
  end

  def move_down
    @position[1] -= 1
  end

  def pick_up(item)
    
    if item.is_a?(Weapon)
      @equipped_weapon = item
    end

    if item.is_a?(BoxOfBolts) && (@health<=80)
      item.feed(self)
    end

    if item.is_a?(Batteries)
      item.recharge(self)
    end

    if items_weight + item.weight <= 250
      @items<<item
      @items_weight += item.weight
    end

  end

  def wound(damage)
    if damage > @shield
      damage -= @shield
      @shield = 0
      if damage > @health
        @health = 0
      else
        @health -= damage
      end
    else
      @shield -= damage
    end
  end

  def heal(amount)
    if @health + amount > 100
      @health = 100
    else
      @health += amount
    end
  end

  def attack(robot)

    if (robot.position[0] == @position[0]-2||robot.position[0] == @position[0]+2||robot.position[1] == @position[1]-2||robot.position[1] == @position[1]+2)&&equipped_weapon.is_a?(Grenade)
      @equipped_weapon.hit(robot)
      @equipped_weapon = nil
    end

    if (robot.position[0] == @position[0]-1||robot.position[0] == @position[0]+1||robot.position[1] == @position[1]-1||robot.position[1] == @position[1]+1||robot.position==@position)&&equipped_weapon.is_a?(SpecialWeapon)
      scanning.each do |enemy|
        equipped_weapon.hit(enemy)
      end
    elsif robot.position[0] == @position[0]-1||robot.position[0] == @position[0]+1||robot.position[1] == @position[1]-1||robot.position[1] == @position[1]+1||robot.position==@position
      if @equipped_weapon != nil 
        @equipped_weapon.hit(robot)
      else
        robot.wound(attack_power)
      end

    end

  end

  def heal!
    raise RobotAlreadyDeadError unless @health > 0
  end

  def attack!(enemy)
    raise UnattackableEnemy unless enemy.is_a?(Robot)
  end

  def self.in_position(x,y)
    @@robot_list.select{|robot|robot.position[0] == x&&robot.position[1] == y}
  end

  def scanning
    @@robot_list.delete(self)
    @@robot_list.select{|robot|(robot.position[0]==position[0]-1&&robot.position[1]==position[1])||(robot.position[0]==position[0]+1&&robot.position[1]==position[1])||(robot.position[1]==position[1]-1&&robot.position[0]==position[0])||(robot.position[1]==position[1]+1&&robot.position[0]==position[0])||(robot.position[0]==position[0]&&robot.position[1]==position[1])}
  end

  def self.clear_list
    @@robot_list.clear
  end

  def self.robot_list
    @@robot_list
  end


end
