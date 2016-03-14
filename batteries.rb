class Batteries < Item

  def initialize
    super("Batteries",25)
  end

  def recharge(robot)
    robot.shield = 50
  end

end