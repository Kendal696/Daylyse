# Proyecto: Aplicación Móvil de Diario Personal con IA

## Descripción General del Proyecto

Este proyecto es una **aplicación móvil de diario personal** desarrollada en **Flutter** que incorpora **inteligencia artificial (IA)** mediante la API de OpenAI para analizar las entradas diarias del usuario. El objetivo principal es ofrecer a los usuarios una experiencia en la que puedan escribir sus pensamientos diarios y, opcionalmente, solicitar un análisis detallado de su día. Este análisis incluye:

- **Resumen del día**
- **Áreas de mejora**
- **Consejos personalizados**
- **Emoji** que refleja el estado de ánimo detectado por la IA

Además, este proyecto es un ejercicio académico diseñado para poner en práctica conceptos de **Software Quality Assurance (SQA)**, aplicando pruebas, monitoreo y aseguramiento de calidad a lo largo del desarrollo.

## Tecnologías Utilizadas

- **Flutter**: Framework multiplataforma para el desarrollo de la aplicación móvil.
- **API de OpenAI**: Proporciona los análisis automáticos de las entradas del diario.
- **Firebase**: Utilizado como base de datos en tiempo real y para la autenticación de usuarios.

## Funcionalidades

### 1. Pantalla de Inicio de Sesión (Login Screen)
Permite a los usuarios autenticarse utilizando Firebase Authentication. Tras autenticarse, los usuarios pueden acceder a sus notas previas y crear nuevas entradas.

### 2. Pantalla Principal (Home Screen)
Muestra todas las entradas del diario en una lista, con la opción de realizar un análisis de IA para entradas específicas.

### 3. Pantalla de Notas (Note Screen)
Permite escribir o editar las entradas del diario para el día seleccionado. Tras guardar la nota, el usuario puede solicitar el análisis de IA presionando el botón "Analizar".

### 4. Pantalla de Feedback de IA (FeedbackIA Screen)
Muestra el análisis generado por la IA, incluyendo:
- **Resumen del día**
- **Áreas de mejora**
- **Consejos**
- **Emoji** representativo del estado de ánimo

### 5. Pantalla de Configuración (Settings Screen)
Permite a los usuarios ajustar configuraciones como la modificación de su perfil y la configuración de notificaciones.

## Flujo de la Aplicación

1. **Inicio de Sesión**: El usuario accede a la aplicación mediante Firebase Authentication.
2. **Visualización de Entradas**: En la pantalla principal, el usuario puede visualizar, editar y analizar las entradas previas.
3. **Creación de Nuevas Entradas**: El usuario puede crear una nueva entrada en la pantalla de notas, la cual se almacenará en Firebase.
4. **Análisis del Día**: El usuario puede solicitar un análisis de IA para una entrada específica. El análisis incluye un resumen y sugerencias, y se almacenará en Firebase.
5. **Retroalimentación del Usuario**: Tras recibir el análisis, el usuario puede proporcionar retroalimentación sobre la precisión del análisis y del emoji generado.

## Estrategias de SQA Implementadas

El proyecto pone en práctica diversas estrategias de **Software Quality Assurance (SQA)**:

1. **Pruebas Funcionales**: Se verifican todas las funcionalidades de la aplicación, desde la autenticación hasta la integración con la API de OpenAI.
2. **Pruebas de Seguridad**: Dado que se manejan datos sensibles, se realizan pruebas para garantizar que los datos de los usuarios estén protegidos.
3. **Pruebas de Usabilidad**: Se evalúa la facilidad de uso mediante pruebas con usuarios.
4. **Monitoreo del Rendimiento**: Se implementa el monitoreo de la respuesta de la API de OpenAI y Firebase, asegurando que no haya retrasos significativos.

## Consideraciones Técnicas

- **Firebase**: Se utiliza para almacenar permanentemente tanto las entradas del diario como los análisis de IA. Además, Firebase Authentication gestiona el inicio de sesión del usuario.
- **Seguridad de Datos**: Es esencial proteger las entradas y análisis del diario mediante métodos de cifrado y seguridad adicionales.
- **Retroalimentación**: Los análisis de la IA son permanentes, y los usuarios pueden revisar y dar retroalimentación sobre la precisión del análisis en cualquier momento.

## Contribuciones

Las contribuciones al proyecto son bienvenidas. Si deseas colaborar, sigue los siguientes pasos:

1. Realiza un **fork** del repositorio.
2. Crea una nueva **branch** (`git checkout -b feature/nueva-funcionalidad`).
3. Realiza los cambios necesarios y haz **commit** (`git commit -m "Añadida nueva funcionalidad"`).
4. Haz **push** a la branch (`git push origin feature/nueva-funcionalidad`).
5. Abre un **Pull Request**.

## Licencia

Este proyecto está licenciado bajo la **MIT License**. Puedes consultar más detalles en el archivo [LICENSE](./LICENSE).

