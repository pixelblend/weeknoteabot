Feature: Receiving Weeknotes

  # Please see doc/GLOSSARY.mdown for a definition of terms.

  Scenario: Weeknote Arrives
    Given weeknotes have been started
    When a contributor sends an email
    And the subject is "What I'm working on"
    And the email has an attachment
    Then the contents of the email are saved for later
    And it is noted that the contributor has submitted weeknotes
    And everyone will receive the email
