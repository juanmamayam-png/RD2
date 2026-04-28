import axios from 'axios'

const api = axios.create({
  baseURL: import.meta.env.VITE_API_URL || '/api',
})

// Adjuntar token JWT a cada petición
api.interceptors.request.use((config) => {
  const token = localStorage.getItem('rc_token')
  if (token) config.headers.Authorization = `Bearer ${token}`
  return config
})

// Redirigir al login si el token expiró
api.interceptors.response.use(
  (res) => res,
  (err) => {
    if (err.response?.status === 401) {
      localStorage.removeItem('rc_token')
      localStorage.removeItem('rc_user')
      window.location.href = '/login'
    }
    return Promise.reject(err.response?.data?.error || 'Error de conexión')
  }
)

export default api
