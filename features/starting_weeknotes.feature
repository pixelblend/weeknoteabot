Feature: Starting Weeknotes

  Scenario: State is idle, receive starter email from compiler.
    Given a state of idle
    When an email is recieved
    And the sender is a contributor
    And the subject is New Weeknotes
    And the email is parsed
    Then the state should be ready
    And the response should be sent to the group
 
  Scenario: State is idle, non-starter email recieved.
    Given a state of idle
    When an email is recieved
    And the sender is a contributor
    And the subject is yadda yadda
    And the email is parsed
    Then the response should be sent to the sender
    And the subject should be Sorry, why did you send this?
    And the state should be idle

