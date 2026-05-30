@automation-api

Feature: Casos de prueba login

  @token
  Scenario Outline: CP01-Crear token usuario
    * def requestBody = read('classpath:resources/json/auth/bodyLogin.json').loginRequest
    * def schema = read('classpath:resources/json/auth/schema.json').loginResponseSchema
    * print requestBody
    Given url urlBase + '/api/login'
    And request requestBody
    When method post
    Then status 200
    And match response == schema
    And match response.user contains { email: "<user>" }
    * def token = response.access_token

    Examples:
      |user|password|
      | carlosqateam@gmail.com | carlos123 |

  Scenario Outline: CP02-Login con datos incorrectos
    * def requestBody = read('classpath:resources/json/auth/bodyLogin.json').loginRequest
    Given url urlBase + '/api/login'
    And request requestBody
    When method post
    Then status 401
    And match response.message == '#string'
    And match response.message == 'Datos incorrectos'
    And match response.user == '#notpresent'

    Examples:
      | user                    | password      |
      | carlosqateamgmail.com   |  123          |
