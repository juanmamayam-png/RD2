import { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { useAuth } from '../hooks/useAuth.js'
import { solicitudesService } from '../services/solicitudes.service.js'
import EstadoBadge from '../components/EstadoBadge.jsx'

export default function DashboardPage() {
  const { user, logout } = useAuth()
  const [pedidos, setPedidos] = useState([])

  useEffect(() => {
    solicitudesService.listar().then(setPedidos).catch(console.error)
  }, [])

  return (
    <div className="app-shell">
      <header className="topbar">
        <span className="logo-sm">Rappicampo</span>
        <span>{user?.nombre}</span>
        <button onClick={logout}>Salir</button>
      </header>
      <main className="screen">
        <h2>Mis pedidos</h2>
        <Link to="/solicitud" className="btn-primary">+ Nueva solicitud</Link>
        <div className="lista">
          {pedidos.length === 0 && <p className="empty">Sin pedidos aún</p>}
          {pedidos.map(p => (
            <div key={p.id} className="pedido-card">
              <div className="pedido-info">
                <b>{p.descripcion}</b>
                <small>{p.origen_dir} → {p.destino_dir}</small>
              </div>
              <div className="pedido-meta">
                <EstadoBadge estado={p.estado} />
                {p.eta_minutos && <span>⏱ {p.eta_minutos} min</span>}
                {p.estado !== 'entregado' && p.estado !== 'cancelado' && (
                  <Link to={`/tracking/${p.id}`}>Ver mapa</Link>
                )}
              </div>
            </div>
          ))}
        </div>
      </main>
    </div>
  )
}
