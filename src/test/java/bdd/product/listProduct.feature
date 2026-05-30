Feature: Listar productos
  Background:

    * def reusableToken = call read('classpath:bdd/auth/loginAuth.feature@token')
    * def tokenLogin = reusableToken.token
    * header Authorization = 'Bearer ' + tokenLogin


  Scenario Outline: CP01-Listar producto by id
    * def schema = read('classpath:resources/json/Product/schema.json').schemaProductoById
    * def idProductoNum = parseInt(idProducto)

    Given url urlBase + '/api/v1/producto/' + idProducto
    When method get
    Then status 200
    And match response == schema
    And match response.id == idProductoNum
    And assert response.id > 0
    And assert response.stock >= 0
      Examples:
      | idProducto |
      | 500        |

  Scenario Outline: CP01-Listar producto by id invalido

      Given url urlBase + '/api/v1/producto/' + idProducto
      When method get
      Then status 404

      And match response.error == 'Producto no encontrado'
      And match response.id == '#notpresent'
      And match response.codigo == '#notpresent'

          Examples:
          | idProducto          |
          | abc                 |
          | 2438h93fduiwejfdiws |
          | 999999999           |
