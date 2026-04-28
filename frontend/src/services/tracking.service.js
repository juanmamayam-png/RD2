import api from './api.js'

export const trackingService = {
  historial: (solicitudId) => api.get(`/tracking/${solicitudId}`).then(r => r.data),
}
