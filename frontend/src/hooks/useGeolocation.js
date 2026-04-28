import { useState, useEffect } from 'react'

export function useGeolocation() {
  const [coords,  setCoords]  = useState(null)   // { lat, lng }
  const [error,   setError]   = useState(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    if (!navigator.geolocation) {
      setError('Geolocalización no disponible')
      setLoading(false)
      return
    }
    const watchId = navigator.geolocation.watchPosition(
      ({ coords: c }) => {
        setCoords({ lat: c.latitude, lng: c.longitude })
        setLoading(false)
      },
      (err) => { setError(err.message); setLoading(false) },
      { enableHighAccuracy: true, maximumAge: 5000 }
    )
    return () => navigator.geolocation.clearWatch(watchId)
  }, [])

  return { coords, error, loading }
}
