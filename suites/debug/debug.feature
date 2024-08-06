Feature: Simple Tests

Scenario: Verify static JSON data
  * def response = 
    """
    {
      "name": "FHIR",
      "type": "Testing",
      "version": "0.1.0"
    }
    """

  And match response.name == 'FHIR'
  And match response.type == 'Testing'
  And match response.version == '0.1.0'
