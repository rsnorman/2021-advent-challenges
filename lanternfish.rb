class Lanternfish
  TIMER_START = 8
  RESET_TIMER = 6

  attr_reader :timer

  def initialize(timer = TIMER_START)
    @timer = timer
    @create_callbacks = []
  end

  def tick
    @timer -= 1
    if @timer < 0
      @timer = RESET_TIMER
      new_lanternfish = Lanternfish.new
      @create_callbacks.each { |callback| callback.call(new_lanternfish) }
    end
  end

  def on_lanternfish_create(&block)
    @create_callbacks << block
  end
end
