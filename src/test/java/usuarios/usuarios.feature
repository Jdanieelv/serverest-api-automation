Feature: CRUD de Usuarios - API ServeRest
  Como un administrador del sistema
  Quiero gestionar los usuarios a través de la API
  Para administrar la base de datos de usuarios

  Background:
    * url baseUrl
    * def newUser = call read('helpers.js')

  # ============ GET /usuarios - Listar usuarios ============

  @listar
  Scenario: Listar todos los usuarios
    Given path '/usuarios'
    When method get
    Then status 200
    And match response.quantidade == '#number'
    And match response.usuarios == '#[]'
    And match response contains { quantidade: '#number', usuarios: '#[] #object' }

  @listar
  Scenario: Listar usuarios con filtro por nombre
    Given path '/usuarios'
    And param nome = 'Fulano da Silva'
    When method get
    Then status 200
    And match response.quantidade == '#number'

  # ============ POST /usuarios - Registrar usuario ============

  @registrar
  Scenario: Registrar un nuevo usuario con datos válidos
    Given path '/usuarios'
    And request newUser
    When method post
    Then status 201
    And match response.message == 'Cadastro realizado com sucesso'
    And match response._id == '#string'
    * def userId = response._id

  @registrar
  Scenario: Registrar usuario con email ya existente
    Given path '/usuarios'
    And request newUser
    When method post
    Then status 201
    * def duplicateUser = newUser
    Given path '/usuarios'
    And request duplicateUser
    When method post
    Then status 400
    And match response.message == 'Este email já está sendo usado'

  @registrar
  Scenario: Registrar usuario sin nombre (campo obligatorio)
    Given path '/usuarios'
    And request { email: '#(newUser.email)', password: 'test123', administrador: 'true' }
    When method post
    Then status 400
    And match response.nome == 'nome é obrigatório'

  @registrar
  Scenario: Registrar usuario con email inválido
    Given path '/usuarios'
    And request { nome: 'Test User', email: 'email-invalido', password: 'test123', administrador: 'true' }
    When method post
    Then status 400
    And match response.email == 'email deve ser um email válido'

  # ============ GET /usuarios/{_id} - Buscar por ID ============

  @buscar
  Scenario: Buscar usuario por ID válido
    Given path '/usuarios'
    And request newUser
    When method post
    Then status 201
    * def userId = response._id

    Given path '/usuarios', userId
    When method get
    Then status 200
    And match response.nome == newUser.nome
    And match response.email == newUser.email
    And match response._id == userId
    And match response contains read('../schemas/usuario-schema.json')

  @buscar
  Scenario: Buscar usuario con ID inexistente
    Given path '/usuarios', 'idNoExiste1234ab'
    When method get
    Then status 400
    And match response.message == 'Usuário não encontrado'

  # ============ PUT /usuarios/{_id} - Actualizar usuario ============

  @actualizar
  Scenario: Actualizar un usuario existente
    Given path '/usuarios'
    And request newUser
    When method post
    Then status 201
    * def userId = response._id

    * def updatedUser = { nome: 'Usuario Actualizado', email: '#(newUser.email)', password: 'nueva123', administrador: 'true' }
    Given path '/usuarios', userId
    And request updatedUser
    When method put
    Then status 200
    And match response.message == 'Registro alterado com sucesso'

    Given path '/usuarios', userId
    When method get
    Then status 200
    And match response.nome == 'Usuario Actualizado'

  @actualizar
  Scenario: Actualizar usuario con ID inexistente crea uno nuevo
    * def timestamp = java.lang.System.currentTimeMillis()
    * def createUser = { nome: 'Nuevo via PUT', email: '#("put" + timestamp + "@test.com")', password: 'test123', administrador: 'true' }
    Given path '/usuarios', 'id_inexistente_' + timestamp
    And request createUser
    When method put
    Then status 201
    And match response.message == 'Cadastro realizado com sucesso'

  # ============ DELETE /usuarios/{_id} - Eliminar usuario ============

  @eliminar
  Scenario: Eliminar un usuario existente
    Given path '/usuarios'
    And request newUser
    When method post
    Then status 201
    * def userId = response._id

    Given path '/usuarios', userId
    When method delete
    Then status 200
    And match response.message == 'Registro excluído com sucesso'

    Given path '/usuarios', userId
    When method get
    Then status 400
    And match response.message == 'Usuário não encontrado'

  @eliminar
  Scenario: Eliminar usuario con ID inexistente
    Given path '/usuarios', 'id_que_no_existe'
    When method delete
    Then status 200
    And match response.message == 'Nenhum registro excluído'
