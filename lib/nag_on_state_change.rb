require_relative 'weeknote_state'
require_relative 'weeknote_period'
require_relative 'contributors'

class NagOnStateChange
  def initialize(queue, state)
    @queue = queue
    @state = state
    @nag_thread = false
  end

  def state=(new_state)
    if @state.state == 'idle' && new_state.state == 'ready'
      start_nag_thread
    elsif @state.state == 'ready' && new_state.state == 'idle'
      stop_nag_thread
    end

    @state = new_state
  end

  def start_nag_thread
    state = WeeknoteState.new('nag')
    period = WeeknotePeriod.new(Time.now)

    @nag_thread = Thread.new do
      $logger.info('Nag thread started')
      loop do
        sleep(period.next)
        #do thing
        #contributors = ContributorsCache.read
      end
    end
  end

  def stop_nag_thread
    Thread.kill(@nag_thread) if @nag_thread
  end
end
