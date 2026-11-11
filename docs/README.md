# Documentación

- `lighthouse/AAAA-MM-DD/`: auditorías y sus informes HTML, agrupados por fecha de ejecución. Los análisis que abarcan varias fechas permanecen en la fecha del documento.
- `planificacion/AAAA-MM-DD/`: estimaciones y documentos de planificación.
- [Desarrollo](desarrollo/agent-transcripts.md): guía para incluir transcripciones de agentes en artículos.

El script `scripts/run-lighthouse.sh` guarda las nuevas auditorías en la carpeta de la fecha UTC de ejecución. La opción `--output` permite indicar otro prefijo y destino.
