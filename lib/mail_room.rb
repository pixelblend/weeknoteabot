require 'thread'

require 'mailer'
require 'weeknote_state'
require 'contributors'
require 'responder'
require 'fetch_from_whereabouts'
require 'nag_on_state_change'

module MailRoom
  def self.start!
    incoming_mail = Queue.new
    outgoing_mail = Queue.new
    threads       = Array.new

    Thread.abort_on_exception = true

    threads << self.check_mail(incoming_mail)
    threads << self.parse_mail(incoming_mail, outgoing_mail)
    threads << self.send_mail(outgoing_mail)
    threads.each(&:join)
  end

  def self.check_mail(queue, sleep=10)
    Thread.new do
      loop do
        $logger.info "Checking for new email"

        Mailer.check_for_new_email do |email|
          $logger.info "Found new email #{email.subject}"
          queue.push email
        end

        $logger.info "Sleeping"
        sleep(sleep)
      end
    end
  end

  def self.parse_mail(incoming_queue, outgoing_queue)
    Thread.new do
      state = WeeknoteState.new('idle')
      #contributors = Contributors.new(FetchFromWhereabouts.fetch)
      contributors = Contributors.new(%w{dan.nuttall@bbc.co.uk pixelblend@gmail.com pixel.blend@gmail.com})
      nag_on_state_change = NagOnStateChange.new(outgoing_queue, state)

      loop do
        email = incoming_queue.pop

        $logger.info "Received email #{email.subject} for processing"

        replies, state, contributors = Responder.respond_to(email, state, contributors)

        nag_on_state_change.state = state

        if replies.empty?
          $logger.info "Not responding to #{email.subject}"
        else
          $logger.info "Sent response to #{email.subject}"
        end

        replies.each { |reply| outgoing_queue.push reply }
      end
    end
  end

  def self.send_mail(queue)
    Thread.new do
      loop do
        email = queue.pop
        $logger.info "Sending email #{email[:subject]}"

        # TODO: not very elegant
        email[:from] ||= Mail.retriever_method.settings[:user_name]

        if email[:to] == :all
          email[:to] = ContributorsCache.read.members
        end

        begin
          Mailer.send(email)
        rescue Mailer::DeliveryError => e
          $logger.warn "Could not send #{email[:subject]}: #{e}"
        else
          $logger.info "Sent #{email[:subject]}"
        end
      end
    end
  end
end
