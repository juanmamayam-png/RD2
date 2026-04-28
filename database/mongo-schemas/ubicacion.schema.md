# Schema MongoDB: Colección `ubicaciones`

Almacena los puntos GPS del conductor durante un servicio activo.
TTL automático: 7 días tras la creación.

```json
{
  "_id": "ObjectId",
  "solicitudId": "string  — ID de la solicitud en PostgreSQL",
  "conductorId":  "string  — ID del usuario conductor",
  "lat":          "number  — latitud decimal",
  "lng":          "number  — longitud decimal",
  "ts":           "Date    — timestamp del punto"
}
```

## Índices
- `{ solicitudId: 1 }` — consultas por solicitud
- `{ ts: 1 }, { expireAfterSeconds: 604800 }` — TTL 7 días
