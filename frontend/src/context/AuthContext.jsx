import { createContext, useState, useEffect } from 'react'
import { authService } from '../services/auth.service.js'

export const AuthContext = createContext(null)

export function AuthProvider({ children }) {
  const [user,  setUser]  = useState(null)
  const [token, setToken] = useState(() => localStorage.getItem('rc_token'))
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    if (token) {
      const saved = localStorage.getItem('rc_user')
      if (saved) setUser(JSON.parse(saved))
    }
    setLoading(false)
  }, [])

  async function login(telefono, password) {
    const data = await authService.login({ telefono, password })
    localStorage.setItem('rc_token', data.token)
    localStorage.setItem('rc_user',  JSON.stringify(data.user))
    setToken(data.token)
    setUser(data.user)
    return data.user
  }

  async function register(payload) {
    const data = await authService.register(payload)
    localStorage.setItem('rc_token', data.token)
    localStorage.setItem('rc_user',  JSON.stringify(data.user))
    setToken(data.token)
    setUser(data.user)
    return data.user
  }

  function logout() {
    localStorage.removeItem('rc_token')
    localStorage.removeItem('rc_user')
    setToken(null)
    setUser(null)
  }

  return (
    <AuthContext.Provider value={{ user, token, loading, login, register, logout }}>
      {!loading && children}
    </AuthContext.Provider>
  )
}
