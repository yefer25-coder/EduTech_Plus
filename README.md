# EduTech Plus - Sistema de Gestión Académica

## 📄 Descripción del Proyecto
**EduTech Plus** es una solución de base de datos relacional robusta diseñada para la gestión integral de instituciones educativas. Este proyecto modela, implementa y gestiona la información crítica de una entidad educativa, incluyendo estudiantes, docentes, programas académicos, cursos, matrículas, evaluaciones, calificaciones y pagos.

El sistema ha sido diseñado aplicando las mejores prácticas de **normalización (hasta 3FN)** para garantizar la integridad de los datos, evitar redundancias y optimizar el rendimiento de las consultas.

## 🎯 Objetivos
- **Gestión Académica**: Control total sobre programas, cursos y asignaciones docentes.
- **Ciclo de Vida del Estudiante**: Desde el registro y matrícula hasta la evaluación y certificación.
- **Control Financiero**: Seguimiento de pagos y estados de cuenta de los estudiantes.
- **Auditoría y Seguridad**: Trazabilidad de cambios críticos en el sistema mediante triggers.

## 🗂️ Estructura del Proyecto
El proyecto está organizado modularmente para facilitar su mantenimiento y despliegue:

```text
EduTech_Plus/
├── edutech_plus_complete.sql   # 🚀 SCRIPT MAESTRO (Todo en uno)
├── database/           # Scripts DDL (Definición de estructuras)
│   ├── tables_database.sql       # Creación de tablas
│   └── referential_integrity.sql # Definición de claves foráneas (FKs)
├── insertions/         # Scripts DML (Poblado de datos)
│   └── insertions_database.sql   # Datos de prueba (Estudiantes, Cursos, etc.)
├── procedures/         # Procedimientos Almacenados (Lógica de Negocio)
│   ├── process_register_student.sql
│   ├── register_student_course.sql
│   ├── register_grade.sql
│   ├── calculate_student_average.sql
│   └── generate_academic_certification.sql
├── triggers/           # Disparadores (Auditoría y Validaciones)
│   ├── after_registration_insert.sql  # Auditoría de matrículas
│   ├── after_payment_update.sql       # Auditoría de pagos
│   └── before_grade_insert.sql        # Validación de rango de notas
├── views/              # Vistas (Reportes predefinidos)
│   ├── vw_students_programs.sql       # Reporte Estudiantes-Programas
│   ├── vw_courses_teachers.sql        # Reporte Cursos-Docentes
│   ├── vw_student_academic_history.sql # Historial académico detallado
│   └── vw_pending_payments.sql        # Reporte de carteras pendientes
├── queries/            # Consultas Complejas
│   └── complex_queries.sql            # 10 Consultas de análisis de datos
└── relationMER/        # Documentación de Diseño
    └── EduTechPlus.drawio.png         # Diagrama Entidad-Relación (ER)
```

## 🛠️ Tecnologías Utilizadas
- **Motor de Base de Datos**: MySQL / MariaDB
- **Lenguaje**: SQL (Structured Query Language)
- **Herramientas de Diseño**: Draw.io (para el modelado ER)

## 🚀 Guía de Instalación y Ejecución

### ⚡ Opción 1: Instalación Rápida (Recomendada)
Ejecuta el script maestro que contiene todo el sistema completo:

```sql
SOURCE edutech_plus_complete.sql;
```

O desde la línea de comandos:
```bash
mysql -u root -p < edutech_plus_complete.sql
```

Este script único ejecuta automáticamente en el orden correcto:
1. Creación de base de datos y tablas
2. Claves foráneas
3. Procedimientos almacenados
4. Triggers
5. Vistas
6. Datos de prueba
7. Consultas de ejemplo

---

### 📋 Opción 2: Instalación Paso a Paso
Para desplegar la base de datos completa manualmente, ejecute los scripts en el siguiente orden estricto para evitar errores de dependencias:

1. **Creación de Estructuras**:
   - Ejecutar `database/tables_database.sql` (Crea la BD y las tablas).
   - Ejecutar `database/referential_integrity.sql` (Aplica las relaciones FK).

2. **Lógica de Negocio y Automatización**:
   - Ejecutar todos los scripts en la carpeta `procedures/`.
   - Ejecutar todos los scripts en la carpeta `triggers/`.
   - Ejecutar todos los scripts en la carpeta `views/`.

3. **Poblado de Datos**:
   - Ejecutar `insertions/insertions_database.sql`.
   *Nota: Este script inserta 20 estudiantes, 5 docentes, 5 programas, 10 cursos y múltiples transacciones de prueba.*

4. **Pruebas y Consultas**:
   - Puede probar el sistema ejecutando las consultas en `queries/complex_queries.sql` para ver reportes avanzados.

## ✨ Características Destacadas

### Procedimientos Almacenados
El sistema encapsula procesos complejos como:
- **`sp_register_student`**: Inserta estudiantes validando duplicados de correo/documento.
- **`sp_generate_academic_certification`**: Genera certificaciones solo si el estudiante tiene cursos aprobados en el periodo.

### Triggers
- **Auditoría**: Se registra automáticamente en la tabla `audits` cada vez que se matricula un estudiante o se registra un pago.
- **Integridad de Datos**: Se impide la inserción de notas fuera del rango 0.0 - 5.0.

### Vistas
Vistas optimizadas para facilitar la labor administrativa, permitiendo ver rápidamente deudores (`vw_pending_payments`) o la carga académica (`vw_courses_teachers`).
