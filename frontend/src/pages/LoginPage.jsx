import { useState } from 'react'
import { useNavigate, Link } from 'react-router-dom'
import { useAuth } from '../hooks/useAuth.js'

export default function LoginPage() {
  const { login } = useAuth()
  const navigate  = useNavigate()
  const [form, setForm]   = useState({ telefono: '', password: '' })
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)

  async function handleSubmit(e) {
    e.preventDefault()
    setLoading(true); setError('')
    try {
      const user = await login(form.telefono, form.password)
      navigate(user.rol === 'conductor' ? '/conductor' : '/')
    } catch (err) {
      setError(err)
    } finally { setLoading(false) }
  }

  return (
    <div className="auth-screen">
      <h1 className="logo">Rappicampo</h1>
      <form className="auth-card" onSubmit={handleSubmit}>
        <h2>Iniciar sesión</h2>
        {error && <p className="error">{error}</p>}
        <input placeholder="Teléfono" value={form.telefono}
          onChange={e => setForm(f => ({...f, telefono: e.target.value}))} required />
        <input type="password" placeholder="Contraseña" value={form.password}
          onChange={e => setForm(f => ({...f, password: e.target.value}))} required />
        <button type="submit" disabled={loading}>
          {loading ? 'Ingresando...' : 'Entrar'}
        </button>
        <p>¿No tienes cuenta? <Link to="/register">Regístrate</Link></p>
      </form>
    </div>
  )
}
