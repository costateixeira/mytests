Feature: Search tests

Background: 
  * url 'http://hapi.fhir.org/baseR4'

Scenario: Search all Patients
    Given path 'Patient'
    And header Accept = 'application/fhir+json'
    When method GET
    Then status 200

  Scenario: Get a patient by ID
    Given path 'Patient/1545788'
    And header Accept = 'application/fhir+json'
    When method GET
    Then status 200

  Scenario: Get a patient by logical identifier
    Given path 'Patient?identifier=urn:trinhcongminh|123456'
    And header Accept = 'application/fhir+json'
    When method GET
    Then status 200

  Scenario: Get a patient by another logical identifier
    Given path 'Patient?identifier=http://trilliumbridge.eu/fhir/demos/eumfh/patient_id|EUR01P0004'
    And header Accept = 'application/fhir+json'
    When method GET
    Then status 200

  Scenario: Get Patients older than 21 years
    Given path 'Patient?birthdate=lt2010-11-03'
    And header Accept = 'application/fhir+json'
    When method GET
    Then status 200

  Scenario: Server-wide searches
    Given url 'https://server.fire.ly/r4/?name=r&_type=Practitioner,Patient'
    And header Accept = 'application/fhir+json'
    When method GET
    Then status 200

  Scenario: POST search
    Given path 'Patient/_search'
    And header Accept = 'application/fhir+json'
    And header Content-Type = 'application/x-www-form-urlencoded'
    And request { _id: '2081525' }
    When method POST
    Then status 200

  Scenario: POST search alternative
    Given path 'Patient/_search'
    And header Accept = 'application/fhir+json'
    And header Content-Type = 'application/x-www-form-urlencoded'
    And request { _id: '1023' }
    When method POST
    Then status 200

  Scenario: Search non-existing parameter
    Given path 'Patient?marital-status=http://terminology.hl7.org/CodeSystem/v3-MaritalStatus|U'
    And header Accept = 'application/fhir+json'
    When method GET
    Then status 200

  Scenario: Return JSON response
    Given path 'Patient/1545788?_format=json'
    And header Accept = 'application/fhir+json'
    When method GET
    Then status 200

  Scenario: Return XML response
    Given path 'Patient/2081525?_format=xml'
    And header Accept = 'application/fhir+json'
    When method GET
    Then status 200

  Scenario: Return summary
    Given path 'Patient?_summary=true'
    And header Accept = 'application/fhir+json'
    When method GET
    Then status 200

  Scenario: Return certain elements
    Given path 'Patient?_elements=name,active,link'
    And header Accept = 'application/fhir+json'
    When method GET
    Then status 200

  Scenario: Sort search results
    Given path 'Patient?_sort=-birthdate,name'
    And header Accept = 'application/fhir+json'
    When method GET
    Then status 200

  Scenario: Return more than default results
    Given url 'https://server.fire.ly/r4/?name=r&_type=Practitioner,Patient&_count=20'
    And header Accept = 'application/fhir+json'
    When method GET
    Then status 200

  Scenario: Text search
    Given url 'http://test.fhir.org/r4/MedicationStatement?_text=%22John+Mark%22+NEAR+%22Gliclazide%22'
    And header Accept = 'application/fhir+json'
    And header Content-Type = 'application/x-www-form-urlencoded'
    When method GET
    Then status 200

  Scenario: Get from a List
    Given url 'http://test.fhir.org/r4/List/p1023meds'
    And header Accept = 'application/fhir+json'
    When method GET
    Then status 200

  Scenario: Get all items from a list
    Given url 'http://test.fhir.org/r4/MedicationStatement?_list=p1023meds'
    And header Accept = 'application/fhir+json'
    When method GET
    Then status 200

  Scenario: Referenced resource - Observations for a patient
    Given url 'http://test.fhir.org/r4/Observation?subject=Patient/1024'
    And header Accept = 'application/fhir+json'
    When method GET
    Then status 200

  Scenario: Get MedicationStatements by patient identifier
    Given url 'http://test.fhir.org/r4/MedicationStatement?subject.identifier=http://trilliumbridge.eu/fhir/demos/eumfh/patient_id|EUR01P0004'
    And header Accept = 'application/fhir+json'
    When method GET
    Then status 200

  Scenario: Get Observations by patient identifier - HAPI
    Given path 'Patient?identifier=urn:trinhcongminh|123456'
    And header Accept = 'application/fhir+json'
    When method GET
    Then status 200

  Scenario: Reverse Chaining - Patients with MedRequest intent=order
    Given path 'Patient?_has:MedicationRequest:subject:intent=order&_total=accurate'
    And header Accept = 'application/fhir+json'
    When method GET
    Then status 200

  Scenario: _include: MedRequests with Patients
    Given path 'MedicationRequest?_include=MedicationRequest:patient'
    And header Accept = 'application/fhir+json'
    When method GET
    Then status 200

  Scenario: _revinclude: Patient with observations
    Given path 'Patient?_id=5&_revinclude=Observation:subject'
    And header Accept = 'application/fhir+json'
    When method GET
    Then status 200

  Scenario: Search using _contained
    Given path 'Medication?_contained=true&_containedType=container'
    And header Accept = 'application/fhir+json'
    When method GET
    Then status 200

  Scenario: Search Patient by gender
    Given path 'Patient?gender=male'
    And header Accept = 'application/fhir+json'
    When method GET
    Then status 200

  Scenario: Search Patient by gender (NOT)
    Given path 'Patient?gender:not=male'
    And header Accept = 'application/fhir+json'
    When method GET
    Then status 200

  Scenario: Search patients above 65
    Given path 'Patient?birthdate=lt1956-11-03'
    And header Accept = 'application/fhir+json'
    When method GET
    Then status 200

  Scenario: Search with OR
    Given path 'Patient?gender=male,unknown&_sort=gender'
    And header Accept = 'application/fhir+json'
    When method GET
    Then status 200

  Scenario: Search Composite
    Given path 'DiagnosticReport?result.code-value-quantity=http://loinc.org|2823-3$gt5.4|http://unitsofmeasure.org|mmol/L'
    And header Accept = 'application/fhir+json'
    When method GET
    Then status 200

  Scenario: GraphQL query
    Given path 'Patient/$graphql'
    And header Accept = 'application/fhir+json'
    And header Content-Type = 'application/json'
    And request {"query":" { \n   Patient(id: 1023) { id, active } \n }","variables":{}}
    When method POST
    Then status 200

  Scenario: GraphQL query 2
    Given path 'Observation/11/$graphql'
    And header Accept = 'application/fhir+json'
    And header Content-Type = 'application/json'
    And request {"query":"  { id subject { reference resource(type : Patient) { gender name {Given family}} }  code {coding {system code} } }","variables":{}}
    When method POST
    Then status 200
