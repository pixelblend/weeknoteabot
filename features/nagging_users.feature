Feature: Nagging users

  # Please see doc/GLOSSARY.mdown for a definition of terms.

  @wip
  Scenario: Non contributing users are sent a reminder email
    Given weeknotes have been started
    And a contributer has submitted
    When the first nag period ends
    Then users who have not submitted are reminded to do so
