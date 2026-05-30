@automation-api

Feature: Nuevos productos
    Background:

        * def reusableToken = call read('classpath:bdd/auth/loginAuth.feature@token')
        * def tokenLogin = reusableToken.token
        * header Authorization = 'Bearer ' + tokenLogin

    Scenario Outline: CP01-Agregar un nuevo producto
        * def requestBody = read('classpath:resources/json/Product/request.json').requestProduct
        * def schema = read('classpath:resources/json/Product/schema.json').schemaAddProduct

        Given url urlBase + '/api/v1/producto'
        And request requestBody
        When method post
        Then status 200
        And match response == schema
        And match response.id == '#number'
        And assert response.id > 0
        And match response.created_at == response.updated_at

        Examples:
            | codigo | nombre     | medida | marca     | categoria | precio  | stock | estado | descripcion         |
            | QA001 | MSI        | UND    | Generico  | Repuestos | 5500.00 | 11    | 1      | Stealth 14 pulgadas |


    Scenario: CP02-Listar todos los productos agregados
        * def producto = read('classpath:resources/json/Product/schema.json').schemaProducto
        * def schema = read('classpath:resources/json/Product/schema.json').schemaListarTodo

        Given url urlBase + '/api/v1/producto/'
        When method get
        Then status 200
        And match response == schema
        And match each response.data contains { id: '#number' }

    Scenario Outline: CP03-Agregar un nuevo producto con descripcion vacia

        * def requestBody = read('classpath:resources/json/Product/request.json').requestProduct

        Given url urlBase + '/api/v1/producto'
        And request requestBody
        When method post
        Then status 500

        And match response.descripcion[0] == 'The descripcion field is required.'
        And match response.id == '#notpresent'
        And match response.created_at == '#notpresent'

        Examples:
            | codigo | nombre | medida | marca | categoria | precio | stock | estado | descripcion |
            | CP123  | MSI    | UND    | Generico | Repuestos | 5500.00 | 11 | 1 | |

    Scenario Outline: CP04-Validar métodos HTTP no permitidos en crear producto
        * def requestBody = read('classpath:resources/json/Product/request.json').requestProduct

        Given url urlBase + '/api/v1/producto'
        And request requestBody
        When method <method>
        Then status 405
        And match response contains '405 Method Not Allowed'
        Examples:
            | method |
            | PUT    |
            | DELETE |
            | PATCH  |


