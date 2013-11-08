require 'mailer'

module MailRoom
  def self.check_mail(queue, sleep: 10)
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

  def self.parse_mail(incoming_queue, outgoing_queue, msg_parser)
    Thread.new do
      loop do
        email = incoming_queue.pop

        $logger.info "Recieved email #{email.subject} for processing"

        msg_parser.parse(email)

        if msg_parser.reply?
          $logger.info "Sent for repsonse #{email.subject}"

          outgoing_queue.push msg_parser.response
        else
          $logger.info "Not responding to #{email.subject}"
        end
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
