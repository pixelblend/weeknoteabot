Feature: Closing Weeknotes

  # Please see doc/GLOSSARY.mdown for a definition of terms.

  Scenario: Weeknote Arrives
    Given weeknotes have been started
    And weeknotes emails have been submitted
    When a compiler sends an email
    And the subject is "End Weeknotes"
    Then the compiled weeknotes will be sent to the compiler
    And the contributors are told that weeknotes are finished
