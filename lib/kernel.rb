module Kernel
  def puts(arg)
    NSLog arg.inspect
  end

  def notification_center
    NSNotificationCenter.defaultCenter
  end
end