@automation-api

Feature: Registrar Usuario

  Scenario Outline: CP01-Registar usuario nuevo
    * def uuid = java.util.UUID.randomUUID().toString().substring(0, 8)
    * def emailUnico = 'qa_' + uuid + '@test.com'

    * def requestBody = read('classpath:resources/json/auth/bodyLogin.json').registerRequest
    * def headers = read('classpath:resources/json/auth/headers.json').registerAuth
    * def schema = read('classpath:resources/json/auth/schema.json').registerResponseSchema

    * set requestBody.email = emailUnico

    * print requestBody
    Given url urlBase + '/api/register'
    And headers headers
    And request requestBody
    When method post
    Then status 200
    And match response == schema
    And match response.data.email == emailUnico

    Examples:
      |read('classpath:resources/csv/auth/dataLogin.csv')|

  Scenario Outline: CP02-Registar usuario existente
    * def requestBody = read('classpath:resources/json/auth/bodyLogin.json').registerRequest
    * def headers = read('classpath:resources/json/auth/headers.json').registerAuth
    * print requestBody
    Given url urlBase + '/api/register'
    And headers headers
    And request requestBody
    When method post
    Then status 500
    And match response.email[0] == 'The email has already been taken.'
    And match response.token_type == '#notpresent'

    Examples:
      | email                  | password |nombre                |tipoUsuarioId|estado|
      | carlosqateam@gmail.es | 12345678 |   Carlos Zambrano QA |    1        |   1  |