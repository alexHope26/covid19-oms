# COVID19-OMS

Realice la programación de un Sistema de gestión de un centro médico de COVID-19 usando Solidity con las funcionalidades de lo que usted considere necesario.
Contexto:
- El sistema debe permitir la petición de pruebas PCR, permitir la expedición de los resultados por centros de salud.
- Se debe crear un contrato para cada centro de salud, todos ellos gestionados por la OMS. Debe permitir la autocreación de un contrato inteligente para cada centro de salud para que cada centro de salud pueda organizar sus pruebas PCR de manera independiente.
- Se debe crear un Factory que cree los contratos para cada centro de salud.
 Crear 3 eventos:
● NuevoCentroValido
● NuevoContrato
● SolicitudAcceso
- Debe crear un modificador: El cual permitirá únicamente la ejecución de funciones que considere de uso exclusivo por la OMS.
Crear 3 funciones:
- Función para validar nuevos centros de salud que puedan autogestionarse
que solo puede ejecutarse por la dirección de la OMS.
- Función que permita crear un contrato inteligente de un centro de salud
- Esta función sólo puede ser ejecutada por los centros de salud válidos
- Función para solicitar acceso al sistema médico de la OMS.
- Esta función debe de ser pública para que cualquier persona pueda
solicitar el acceso al sistema médico.
- Función para visualizar las solicitudes de acceso al sistema médico.
- Esta función debe retornar el array de solicitudes.
- Esta función sólo puede ser ejecutada por la OMS.
Notas:
● Se debe contemplar un array de contratos para almacenar los centros de
salud.
● Se debe contemplar un array de solicitudes de acceso al sistema médico.