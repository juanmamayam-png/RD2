import { useAuth } from '../hooks/useAuth.js'
import RolBadge from '../components/RolBadge.jsx'

export default function PerfilPage() {
  const { user, logout } = useAuth()
  return (
    <div className="app-shell">
      <header className="topbar"><span className="logo-sm">Perfil</span></header>
      <main className="screen" style={{ textAlign:'center' }}>
        <div style={{ fontSize: 56, marginBottom: 8 }}>
          {user?.rol === 'conductor' ? '🏍️' : '🧑‍🌾'}
        </div>
        <h2>{user?.nombre}</h2>
        <RolBadge rol={user?.rol} />
        <p style={{ color:'#a0a0c0', marginTop: 8 }}>{user?.telefono}</p>
        <button onClick={logout} style={{ marginTop: 24 }}>Cerrar sesión</button>
      </main>
    </div>
  )
}
