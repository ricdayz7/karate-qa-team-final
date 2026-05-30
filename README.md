# proyecto-karate-qa-team

Proyecto de automatización de pruebas API usando **Karate DSL** con arquitectura BDD.

---

## 📁 Estructura del Proyecto

```
proyecto-karate-qa-team/
├── src/
│   ├── test/
│   │   ├── java/
│   │   │   ├── bdd/
│   │   │   │   ├── auth/
│   │   │   │   │   ├── accounts.feature         # Escenarios de cuentas
│   │   │   │   │   ├── card.feature             # Escenarios de tarjetas
│   │   │   │   │   └── login.feature            # Escenarios de login
│   │   │   │   └── product/
│   │   │   │       ├── addProduct.feature        # Escenarios de crear producto
│   │   │   │       ├── listProduct.feature       # Escenarios de listar productos
│   │   │   │       └── updateProduct.feature     # Escenarios de actualizar producto
│   │   │   ├── ConfigTest.java                   # Configuración de pruebas
│   │   │   └── TestRunner.java                   # Runner dinámico por tags
│   │   └── resources/
│   │       ├── csv/
│   │       │   └── auth/
│   │       │       └── dataLogin.csv             # Datos de prueba para auth
│   │       ├── json/
│   │       │   ├── auth/
│   │       │   │   ├── bodyLogin.json            # Request body de login
│   │       │   │   ├── headers.json              # Headers de auth
│   │       │   │   └── schema.json               # Schema de validación auth
│   │       │   └── Product/
│   │       │       ├── request.json              # Request body de producto
│   │       │       └── schema.json               # Schema de validación producto
│   │       ├── karate-config.js                  # Configuración global de Karate
│   │       └── logback-test.xml                  # Configuración de logs
├── .github/
│   └── workflows/
│       └── karate-tests.yml                      # Workflow GitHub Actions
└── pom.xml                                       # Dependencias Maven
```

---

## ⚙️ Requisitos

- Java 11+
- Maven 3.6+
- IntelliJ IDEA (recomendado)

---

## 🏃 TestRunner

El `TestRunner` es dinámico y acepta tags por parámetro. Si no se especifica ningún tag ejecuta todos los escenarios:

```java
class TestRunner {

    @Karate.Test
    Karate testAllByTags() {
        String tags = System.getProperty("karate.tags");
        Karate runner = Karate.run().path("classpath:bdd");

        if (tags != null && !tags.trim().isEmpty()) {
            runner = runner.tags(tags.trim());
        }

        return runner;
    }
}
```

---

## 🚀 Ejecución de Pruebas

### Ejecutar todos los tests

```bash
mvn test
```

### Ejecutar por tag

```bash
# PowerShell (Windows)
mvn test "-Dkarate.tags=@automation-api"

# CMD (Windows)
mvn test -Dkarate.tags="@automation-api"

# Linux / Mac
mvn test -Dkarate.tags="@automation-api"
```

### Ejecutar un feature específico

```bash
# PowerShell (Windows)
mvn test "-Dkarate.options=classpath:bdd/product/addProduct.feature"

# CMD / Linux / Mac
mvn test -Dkarate.options="classpath:bdd/product/addProduct.feature"
```

### Excluir un tag

```bash
# PowerShell (Windows)
mvn test "-Dkarate.tags=~@ignore"

# CMD / Linux / Mac
mvn test -Dkarate.tags="~@ignore"
```

---

## 🏷️ Tags disponibles

| Tag | Descripción |
|---|---|
| `@automation-api` | Todos los escenarios de automatización API |
| `@ignore` | Escenarios helper, no se ejecutan solos |

---

## 🔄 Workflow GitHub Actions

El proyecto cuenta con un workflow de ejecución **a demanda** por tag desde GitHub Actions.

### Cómo ejecutarlo

1. Ve a tu repositorio en GitHub
2. Click en **Actions**
3. Selecciona **Karate API Tests - Ejecución por TAG**
4. Click en **Run workflow**
5. Selecciona el **tag** y **ambiente**
6. Click en **Run workflow** ✅

### Parámetros del workflow

| Parámetro | Opciones | Descripción |
|---|---|---|
| `tag` | `@automation-api`, `@ignore` | Tag de Karate a ejecutar |
| `ambiente` | `dev`, `staging`, `prod` | Ambiente de pruebas |

### Reportes

Los reportes quedan guardados como **artifacts** por 7 días en cada ejecución bajo:

```
target/karate-reports/karate-summary.html
```

---

## 🌐 Ambientes

La URL base se configura en `karate-config.js`:

```javascript
var config = {
    urlBase: 'https://api.qateamperu.com'
};
```

---

## 📝 Convenciones de nombres

| Elemento | Convención | Ejemplo |
|---|---|---|
| Features | camelCase | `addProduct.feature` |
| Escenarios | CP + número | `CP01-Crear producto` |
| Schemas | schema + Nombre | `schemaProductoById` |
| Requests | request + Nombre | `requestProduct` |
| Helpers | `@ignore` en el escenario | `@ignore Scenario: helper-listar-productos` |