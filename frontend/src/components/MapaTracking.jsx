import { useEffect, useRef } from 'react'
import L from 'leaflet'

export default function MapaTracking({ origen, destino, conductorPos }) {
  const mapRef  = useRef(null)
  const mapaObj = useRef(null)
  const marcador = useRef(null)

  useEffect(() => {
    if (mapaObj.current) return
    mapaObj.current = L.map(mapRef.current, { zoomControl: true }).setView(
      [origen?.lat ?? 2.9273, origen?.lng ?? -75.2819], 14
    )
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(mapaObj.current)

    if (origen)  L.circleMarker([origen.lat,  origen.lng],  { radius: 8, color: '#2dd4a0' }).addTo(mapaObj.current)
    if (destino) L.circleMarker([destino.lat, destino.lng], { radius: 8, color: '#ff6b35' }).addTo(mapaObj.current)

    const motoIcon = L.divIcon({ html: '<div style="font-size:22px">🏍️</div>', iconSize: [28,28], className: '' })
    marcador.current = L.marker([origen?.lat ?? 2.9273, origen?.lng ?? -75.2819], { icon: motoIcon }).addTo(mapaObj.current)
  }, [])

  useEffect(() => {
    if (conductorPos && marcador.current)
      marcador.current.setLatLng([conductorPos.lat, conductorPos.lng])
  }, [conductorPos])

  return <div ref={mapRef} style={{ height: '280px', borderRadius: '12px' }} />
}
