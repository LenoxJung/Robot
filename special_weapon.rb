class SpecialWeapon < Weapon
  def initialize
    super("Special weapon", 30, 15, 1)
  end

  def hit(robot)
    robot.health -= 30
  end  

end