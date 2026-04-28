import { useState } from 'react'
import { useNavigate, Link } from 'react-router-dom'
import { useAuth } from '../hooks/useAuth.js'

export default function RegisterPage() {
  const { register } = useAuth()
  const navigate = useNavigate()
  const [form, setForm] = useState({ nombre:'', telefono:'', password:'', rol:'ciudadano', vehiculo:'', placa:'' })
  const [error, setError] = useState('')

  async function handleSubmit(e) {
    e.preventDefault(); setError('')
    try {
      const user = await register(form)
      navigate(user.rol === 'conductor' ? '/conductor' : '/')
    } catch (err) { setError(err) }
  }

  const set = (k) => (e) => setForm(f => ({...f, [k]: e.target.value}))

  return (
    <div className="auth-screen">
      <h1 className="logo">Rappicampo</h1>
      <form className="auth-card" onSubmit={handleSubmit}>
        <h2>Crear cuenta</h2>
        {error && <p className="error">{error}</p>}
        <input placeholder="Nombre completo" value={form.nombre} onChange={set('nombre')} required />
        <input placeholder="Teléfono" value={form.telefono} onChange={set('telefono')} required />
        <input type="password" placeholder="Contraseña" value={form.password} onChange={set('password')} required />
        <div className="role-select">
          {['ciudadano','conductor'].map(r => (
            <button key={r} type="button"
              className={`role-btn ${form.rol===r?'active':''}`}
              onClick={() => setForm(f=>({...f, rol: r}))}>
              {r === 'conductor' ? '🏍️ Conductor' : '🧑‍🌾 Ciudadano'}
            </button>
          ))}
        </div>
        {form.rol === 'conductor' && <>
          <input placeholder="Vehículo (ej: Moto Honda CB125)" value={form.vehiculo} onChange={set('vehiculo')} />
          <input placeholder="Placa" value={form.placa} onChange={set('placa')} />
        </>}
        <button type="submit">Registrarme</button>
        <p>¿Ya tienes cuenta? <Link to="/login">Inicia sesión</Link></p>
      </form>
    </div>
  )
}
