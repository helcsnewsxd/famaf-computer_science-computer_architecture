# Arquitectura del Computador - 2023

El presente repositorio contiene todo el material de la materia Arquitectura de Computadoras 2023 correspondiente a 3er año - 2do semestre de la Licenciatura en Ciencias de la Computación en la Facultad de Matemática, Astronomía, Física y Computación (FAMAF) de la Universidad Nacional de Córdoba (UNC).

## Información importante del Quartus

- ¿Cómo usar VSCode como editor?: <https://blog.csdn.net/qq_46588746/article/details/108780967>
- ¿Cómo poner *autoformatter on save* a los archivos del quartus?: <https://marketplace.visualstudio.com/items?itemName=bmpenuelas.systemverilog-formatter-vscode&ssr=false#overview>
  - La config debe ser en **settings.json** del VSCode

    ```json
    "[systemverilog]": {
        "editor.defaultFormatter": "bmpenuelas.systemverilog-formatter-vscode",
        "editor.formatOnSave": true,
    },
    ```

## Primera parte: Procesador de un solo ciclo (práctico)

| Unidad | Tema | Enunciado | Resolución |
| ------ | ---- | --------- | ---------- |
| 1 | Procesador de un solo ciclo | [PDF](./Primera%20parte%20-%20Práctico/SingleCycleProcessor-Enunciado.pdf) | [Carpeta](/Primera%20parte%20-%20Práctico/SingleCycleProcessor/) |
| 2 | Test del procesador de un solo ciclo | [PDF](./Primera%20parte%20-%20Práctico/SingleCycleProcessor2-Test-Enunciado.pdf) | [Carpeta](./Primera%20parte%20-%20Práctico/SingleCycleProcessor/) |
| 3 | Procesador de un solo ciclo con excepciones | [PDF](./Primera%20parte%20-%20Práctico/SingleCycleProcessorWithExceptions%20-%20Guide.pdf) | [Carpeta](./Primera%20parte%20-%20Práctico/SingleCycleProcessorWithExceptions/) |

## Segunda parte: Mejoras al procesador (teórico y práctico)

| Unidad | Tema | Resumen y solución a los ejercicios |
| ------ | ---- | ------------------------------------- |
| 5 | Jerarquía de memoria | [JUAN](./Segunda%20parte%20-%20Teórico%20y%20Práctico/5%20-%20JUAN%20-%20Jerarquía%20de%20Memorias.pdf) y [EMA](./Segunda%20parte%20-%20Teórico%20y%20Práctico/5%20-%20EMA%20-%20Jerarquía%20de%20Memorias.pdf) |
| 6 | Técnicas de mejora de rendimiento | [EMA](./Segunda%20parte%20-%20Teórico%20y%20Práctico/6%20-%20EMA%20-%20Técnicas%20de%20mejora%20de%20rendimiento.pdf) |
| 7 | Dynamic Scheduling | [EMA](./Segunda%20parte%20-%20Teórico%20y%20Práctico/7%20-%20EMA%20-%20Dynamic%20Scheduling.pdf) |

## Laboratorios

| Proyecto | Desarrollo |
| -------- | ---------- |
| Laboratorio 1: ARMv8 en SystemVerilog | [Repositorio](https://github.com/helcsnewsxd/famaf-computer_science-computer_architecture-lab1) |
| Laboratorio 2: Análisis de Microarquitecturas | [Repositorio](https://github.com/helcsnewsxd/famaf-computer_science-computer_architecture-lab2) |