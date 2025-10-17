import { getCookie } from './cookies'
const API_BASE = (import.meta.env.VITE_API_URL ?? '').replace(/\/$/, '')

export async function apiGet<T>(path: string): Promise<T> {
  const token = getCookie('access_token')
  const headers = new Headers()
  if (token) headers.set('Authorization', `Bearer ${token}`)
  const res = await fetch(`${API_BASE}${path}`, {
    method: 'GET',
    headers,
  })
  if (!res.ok) {
    const msg = await res.text().catch(() => '')
    throw new Error(msg || `Request failed (${res.status})`)
  }
  return res.json() as Promise<T>
}
