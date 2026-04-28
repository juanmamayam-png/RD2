import api from './api.js'

export const solicitudesService = {
  listar:      ()          => api.get('/solicitudes').then(r => r.data),
  crear:       (data)      => api.post('/solicitudes', data).then(r => r.data),
  aceptar:     (id)        => api.put(`/solicitudes/${id}/aceptar`).then(r => r.data),
  actualizarEstado: (id, estado) => api.put(`/solicitudes/${id}/estado`, { estado }).then(r => r.data),
  calificar:   (id, data)  => api.post(`/solicitudes/${id}/calificar`, data).then(r => r.data),
}
