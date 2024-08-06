Feature: FHIR API Tests

  Background:
    * url 'http://hapi.fhir.org/baseR4/'

  Scenario: Search MedicationStatement by ID
    Given url 'http://test.fhir.org/r4/MedicationStatement/_search?_id=1'
    And header Accept = 'application/fhir+json'
    When method GET
    Then status 200

  Scenario: Create List
    Given url 'http://test.fhir.org/r4/List/p1023meds'
    And header Content-Type = 'application/fhir+json'
    And header Accept = 'application/fhir+json'
    And request {"resourceType":"List","id":"p1023meds","status":"current","mode":"snapshot","title":"Meds List","code":{"coding":[{"system":"http://hl7.org/fhir/list-example-use-codes","code":"meds"}]},"subject":{"reference":"Patient/1023"},"date":"2021-11-02T15:06:10-06:00","entry":[{"item":{"reference":"MedicationStatement/1"}},{"item":{"reference":"MedicationStatement/2"}},{"item":{"reference":"MedicationStatement/3"}},{"item":{"reference":"MedicationStatement/4"}},{"item":{"reference":"MedicationStatement/5"}},{"item":{"reference":"MedicationStatement/6"}},{"item":{"reference":"MedicationStatement/7"}}]}
    When method PUT
    Then status 200

  Scenario: Search all Patients
    Given url '{{host}}/Patient'
    And header Accept = 'application/fhir+json'
    When method GET
    Then status 200

  Scenario: Get a patient by ID
    Given url '{{host}}/Patient/1545788'
    And header Accept = 'application/fhir+json'
    When method GET
    Then status 200

  Scenario: Get a patient by logical identifier
    Given url 'http://hapi.fhir.org/baseR4/Patient?identifier=urn:trinhcongminh|123456'
    And header Accept = 'application/fhir+json'
    When method GET
    Then status 200

  Scenario: Get a patient by another logical identifier
    Given url 'http://test.fhir.org/r4/Patient?identifier=http://trilliumbridge.eu/fhir/demos/eumfh/patient_id|EUR01P0004'
    And header Accept = 'application/fhir+json'
    When method GET
    Then status 200

  Scenario: Get Patients older than 21 years
    Given url '{{host}}/Patient?birthdate=lt2010-11-03'
    And header Accept = 'application/fhir+json'
    When method GET
    Then status 200

  Scenario: Server-wide searches
    Given url 'https://server.fire.ly/r4/?name=r&_type=Practitioner,Patient'
    And header Accept = 'application/fhir+json'
    When method GET
    Then status 200

  Scenario: POST search
    Given url 'http://hapi.fhir.org/baseR4/Patient/_search'
    And header Accept = 'application/fhir+json'
    And header Content-Type = 'application/x-www-form-urlencoded'
    And request { _id: '2081525' }
    When method POST
    Then status 200

  Scenario: POST search alternative
    Given url 'http://test.fhir.org/r4/Patient/_search'
    And header Accept = 'application/fhir+json'
    And header Content-Type = 'application/x-www-form-urlencoded'
    And request { _id: '1023' }
    When method POST
    Then status 200

  Scenario: Search non-existing parameter
    Given url 'http://hapi.fhir.org/baseR4/Patient?marital-status=http://terminology.hl7.org/CodeSystem/v3-MaritalStatus|U'
    And header Accept = 'application/fhir+json'
    When method GET
    Then status 200

  Scenario: Return JSON response
    Given url 'http://hapi.fhir.org/baseR4/Patient/1545788?_format=json'
    And header Accept = 'application/fhir+json'
    When method GET
    Then status 200

  Scenario: Return XML response
    Given url 'http://hapi.fhir.org/baseR4/Patient/2081525?_format=xml'
    And header Accept = 'application/fhir+json'
    When method GET
    Then status 200

  Scenario: Return summary
    Given url '{{host}}/Patient?_summary=true'
    And header Accept = 'application/fhir+json'
    When method GET
    Then status 200

  Scenario: Return certain elements
    Given url '{{host}}/Patient?_elements=name,active,link'
    And header Accept = 'application/fhir+json'
    When method GET
    Then status 200

  Scenario: Sort search results
    Given url 'http://hapi.fhir.org/baseR4/Patient?_sort=-birthdate,name'
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
    Given url 'http://hapi.fhir.org/baseR4/Patient?identifier=urn:trinhcongminh|123456'
    And header Accept = 'application/fhir+json'
    When method GET
    Then status 200

  Scenario: Reverse Chaining - Patients with MedRequest intent=order
    Given url '{{host}}/Patient?_has:MedicationRequest:subject:intent=order&_total=accurate'
    And header Accept = 'application/fhir+json'
    When method GET
    Then status 200

  Scenario: _include: MedRequests with Patients
    Given url '{{host}}/MedicationRequest?_include=MedicationRequest:patient'
    And header Accept = 'application/fhir+json'
    When method GET
    Then status 200

  Scenario: _revinclude: Patient with observations
    Given url '{{host}}/Patient?_id=5&_revinclude=Observation:subject'
    And header Accept = 'application/fhir+json'
    When method GET
    Then status 200

  Scenario: Search using _contained
    Given url 'http://test.fhir.org/r4/Medication?_contained=true&_containedType=container'
    And header Accept = 'application/fhir+json'
    When method GET
    Then status 200

  Scenario: Search Patient by gender
    Given url '{{host}}/Patient?gender=male'
    And header Accept = 'application/fhir+json'
    When method GET
    Then status 200

  Scenario: Search Patient by gender (NOT)
    Given url '{{host}}/Patient?gender:not=male'
    And header Accept = 'application/fhir+json'
    When method GET
    Then status 200

  Scenario: Search patients above 65
    Given url '{{host}}/Patient?birthdate=lt1956-11-03'
    And header Accept = 'application/fhir+json'
    When method GET
    Then status 200

  Scenario: Search with OR
    Given url 'http://test.fhir.org/r4/Patient?gender=male,unknown&_sort=gender'
    And header Accept = 'application/fhir+json'
    When method GET
    Then status 200

  Scenario: Search Composite
    Given url 'http://test.fhir.org/r4/DiagnosticReport?result.code-value-quantity=http://loinc.org|2823-3$gt5.4|http://unitsofmeasure.org|mmol/L'
    And header Accept = 'application/fhir+json'
    When method GET
    Then status 200

  Scenario: GraphQL query
    Given url 'http://test.fhir.org/r4/Patient/$graphql'
    And header Accept = 'application/fhir+json'
    And header Content-Type = 'application/json'
    And request {"query":" { \n   Patient(id: 1023) { id, active } \n }","variables":{}}
    When method POST
    Then status 200

  Scenario: GraphQL query 2
    Given url 'http://test.fhir.org/r4/Observation/11/$graphql'
    And header Accept = 'application/fhir+json'
    And header Content-Type = 'application/json'
    And request {"query":"  { id subject { reference resource(type : Patient) { gender name {given family}} }  code {coding {system code} } }","variables":{}}
    When method POST
    Then status 200
