@automation-api

Feature: Actualizar productos
  Background:

    * def reusableToken = call read('classpath:bdd/auth/loginAuth.feature@token')
    * def tokenLogin = reusableToken.token
    * header Authorization = 'Bearer ' + tokenLogin

  Scenario Outline: CP01-Actualizar producto existente

    * def schema = read('classpath:resources/json/Product/schema.json').schemaAddProduct
    * def requestBody = read('classpath:resources/json/Product/request.json').requestProduct
    * def idProductoNum = parseInt(idProducto)

    Given url urlBase + '/api/v1/producto/' + idProductoNum
    And request requestBody
    When method put
    Then status 200
    And match response == schema
    And match response.id == idProductoNum
    And match response.descripcion == descripcion

    Examples:
      | idProducto | codigo | nombre          | medida | marca   | categoria | precio  | stock | estado | descripcion             |
      | 500        | PRO001 | Mac             | UND    | Generico| Repuestos | 9999.99 | 20    | 1      | Producto actualizado QA |

  Scenario Outline: CP02-Actualizar producto existente con id invalido

    * def requestBody = read('classpath:resources/json/Product/request.json').requestProduct

    Given url urlBase + '/api/v1/producto/' + idProducto
    And request requestBody
    When method put
    Then status 500

    And match response.error == 'Call to a member function update() on null'

    Examples:
      | idProducto | codigo | nombre     | medida | marca     | categoria | precio  | stock | estado | descripcion |
      | abc        | HP0001 | Lapt DELL  | UND    | Generico  | Repuestos | 9000.00 | 10    | 3      | Ploma 15    |
      | 99999      | HP0001 | Lapt DELL  | UND    | Generico  | Repuestos | 9000.00 | 10    | 3      | Ploma 15    |
      | -1         | HP0001 | Lapt DELL  | UND    | Generico  | Repuestos | 9000.00 | 10    | 3      | Ploma 15    |