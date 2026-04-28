import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { solicitudesService } from '../services/solicitudes.service.js'
import { TIPO_SERVICIO } from '../utils/constants.js'

export default function SolicitudPage() {
  const navigate = useNavigate()
  const [form, setForm] = useState({
    tipo: TIPO_SERVICIO.LLEVAR, descripcion: '', peso_aprox: '',
    origen_dir: '', destino_dir: '', pago_ofrecido: ''
  })
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')

  const set = (k) => (e) => setForm(f => ({...f, [k]: e.target.value}))

  async function handleSubmit(e) {
    e.preventDefault(); setLoading(true); setError('')
    try {
      const sol = await solicitudesService.crear(form)
      navigate(`/tracking/${sol.id}`)
    } catch (err) { setError(err) }
    finally { setLoading(false) }
  }

  return (
    <div className="app-shell">
      <header className="topbar"><span className="logo-sm">Nueva solicitud</span></header>
      <main className="screen">
        <form onSubmit={handleSubmit}>
          {error && <p className="error">{error}</p>}
          <div className="type-select">
            {[TIPO_SERVICIO.LLEVAR, TIPO_SERVICIO.TRAER].map(t => (
              <button key={t} type="button"
                className={`type-btn ${form.tipo===t?'active':''}`}
                onClick={() => setForm(f=>({...f, tipo: t}))}>
                {t === 'llevar' ? '📦 Llevar algo' : '🛒 Traer algo'}
              </button>
            ))}
          </div>
          <input placeholder="¿Qué necesitas?" value={form.descripcion} onChange={set('descripcion')} required />
          <input placeholder="Origen" value={form.origen_dir} onChange={set('origen_dir')} required />
          <input placeholder="Destino" value={form.destino_dir} onChange={set('destino_dir')} required />
          <input placeholder="Pago ofrecido ($)" type="number" value={form.pago_ofrecido} onChange={set('pago_ofrecido')} />
          <input placeholder="Peso aprox (ej: 2 kg)" value={form.peso_aprox} onChange={set('peso_aprox')} />
          <button type="submit" disabled={loading}>
            {loading ? 'Buscando conductor...' : '🚀 Solicitar'}
          </button>
        </form>
      </main>
    </div>
  )
}
