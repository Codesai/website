# Documentación

- `lighthouse/AAAA-MM-DD/`: auditorías y sus informes HTML, agrupados por fecha de ejecución. Los análisis que abarcan varias fechas permanecen en la fecha del documento.
- `planificacion/AAAA-MM-DD/`: estimaciones y documentos de planificación.
- [Desarrollo](desarrollo/agent-transcripts.md): guía para incluir transcripciones de agentes en artículos.
- [Markdown incrustado](desarrollo/markdown-embeds.md): guía para mostrar planes y logbooks en posts y Raw AI Labs.
- [Salida de consola](desarrollo/console-output.md): panel de terminal con las primeras 15 líneas visibles y el resto desplegable.

El script `scripts/run-lighthouse.sh` guarda las nuevas auditorías en la carpeta de la fecha UTC de ejecución. La opción `--output` permite indicar otro prefijo y destino.
