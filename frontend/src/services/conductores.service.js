import api from './api.js'

export const conductoresService = {
  cercanos:    (lat, lng, radio = 5) => api.get(`/conductores/cercanos?lat=${lat}&lng=${lng}&radio=${radio}`).then(r => r.data),
  disponible:  (disponible)          => api.put('/conductores/disponible', { disponible }).then(r => r.data),
  ubicacion:   (lat, lng)            => api.put('/conductores/ubicacion', { lat, lng }).then(r => r.data),
}
