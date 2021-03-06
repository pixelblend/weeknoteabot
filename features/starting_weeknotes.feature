Feature: Starting Weeknotes

  # Please see doc/GLOSSARY.mdown for a definition of terms.

  Scenario: Starter email received
    Given weeknotes haven't been started
    When a contributor sends an email
    And the subject is "Begin Weeknotes"
    Then weeknotes will be started
    And that contributor becomes the compiler
    And everyone will receive an email

  Scenario: Non-starter email received
    Given weeknotes haven't been started
    When a contributor sends an email
    And the subject is "blah blah blah"
    Then weeknotes will not be started
    And the contributor will receive an email explaining how to use weeknotes
    And the subject will be "RE: blah blah blah"
