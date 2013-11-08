Feature: Cannot join in unless you are a contributor

  # Please see doc/GLOSSARY.mdown for a definition of terms.

  Scenario: Email from strangers are ignored
    Given weeknotes haven't been started
    When a stranger sends an email
    And the subject is "New Weeknotes"
    Then weeknotes will not be started
    And the stranger will receive an email
