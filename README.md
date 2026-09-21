# ServeRest API - Automatización QA Backend

Suite de pruebas automatizadas para la [API de Usuarios de ServeRest](https://serverest.dev/) usando **Karate DSL**.

## Requisitos

- Java 17 o superior
- Maven 3.8+

## Instalación y ejecución

```bash
git clone <url-del-repositorio>
cd serverest-api-automation
mvn test
```

Ejecutar solo un grupo de tests por tag:

```bash
mvn test -Dkarate.options="--tags @listar"
mvn test -Dkarate.options="--tags @registrar"
mvn test -Dkarate.options="--tags @buscar"
mvn test -Dkarate.options="--tags @actualizar"
mvn test -Dkarate.options="--tags @eliminar"
```

## Estructura del proyecto

```
serverest-api-automation/
├── src/test/java/
│   ├── karate-config.js          # Configuración global (baseUrl, timeouts)
│   ├── logback-test.xml          # Configuración de logs
│   ├── schemas/                  # Schemas JSON para validación
│   │   ├── usuario-schema.json
│   │   └── lista-usuarios-schema.json
│   └── usuarios/                 # Tests del módulo de usuarios
│       ├── usuarios.feature          # Escenarios de prueba
│       ├── UsuariosRunner.java       # Runner JUnit 5
│       └── helpers.js                # Generador de datos de prueba
├── pom.xml                       # Dependencias Maven
└── README.md
```

## Estrategia de automatización

### Framework: Karate DSL

Karate DSL permite escribir tests de API directamente en archivos `.feature` sin necesidad de step definitions. Los verbos HTTP (`get`, `post`, `put`, `delete`) son nativos del framework.

### Cobertura de endpoints

| Endpoint | Método | Escenarios |
|----------|--------|------------|
| `/usuarios` | GET | Listar todos, filtrar por nombre |
| `/usuarios` | POST | Registro válido, email duplicado, campo faltante, email inválido |
| `/usuarios/{_id}` | GET | Buscar por ID válido, ID inexistente |
| `/usuarios/{_id}` | PUT | Actualizar existente, crear via PUT con ID nuevo |
| `/usuarios/{_id}` | DELETE | Eliminar existente, eliminar ID inexistente |

### Patrones utilizados

- **Datos dinámicos**: helper JavaScript que genera usuarios únicos con timestamp para evitar conflictos entre tests.
- **Validación de schema JSON**: los schemas en `/schemas/` validan la estructura de las respuestas.
- **Tags por operación**: `@listar`, `@registrar`, `@buscar`, `@actualizar`, `@eliminar` permiten ejecutar tests por grupo.

## Reporte

Después de ejecutar los tests, el reporte HTML se genera en `target/karate-reports/karate-summary.html`.
