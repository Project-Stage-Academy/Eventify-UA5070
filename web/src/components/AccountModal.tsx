import { useEffect, useRef } from 'react'

export type Role = { id: number; name: string }
export type User = { id: number; name: string; email: string; roles: Role[] }

type Props = {
  open: boolean
  onClose: () => void
  user: User | null
  loading: boolean
  error: string | null
  onRetry: () => void
}

export default function AccountModal({ open, onClose, user, loading, error, onRetry }: Props) {
  const panelRef = useRef<HTMLDivElement>(null)

  useEffect(() => {
    if (!open) return
    const prev = document.documentElement.style.overflow
    document.documentElement.style.overflow = 'hidden'
    const onKey = (e: KeyboardEvent) => e.key === 'Escape' && onClose()
    window.addEventListener('keydown', onKey)
    return () => { document.documentElement.style.overflow = prev; window.removeEventListener('keydown', onKey) }
  }, [open, onClose])

  if (!open) return null

  const overlayClick: React.MouseEventHandler<HTMLDivElement> = (e) => {
    if (panelRef.current && !panelRef.current.contains(e.target as Node)) onClose()
  }

  return (
    <div
      role="dialog"
      aria-modal="true"
      aria-labelledby="user-modal-title"
      className="fixed inset-0 z-50 grid place-items-center bg-black/50 backdrop-blur"
      onMouseDown={overlayClick}
    >
      <div
        ref={panelRef}
        className="w-[min(92vw,560px)] rounded-2xl bg-white shadow-lg p-6"
        onMouseDown={(e) => e.stopPropagation()}
      >
        <div className="flex items-start justify-between mb-4">
          <h2 id="user-modal-title" className="text-xl font-semibold">Your account</h2>
          <button className="rounded-lg p-2 hover:bg-zinc-100" onClick={onClose} aria-label="Close">
            <svg viewBox="0 0 24 24" className="size-5" aria-hidden="true">
              <path d="M6 6l12 12M18 6L6 18" stroke="currentColor" strokeWidth="2" strokeLinecap="round" />
            </svg>
          </button>
        </div>

        {loading && (
          <div className="grid gap-3">
            <div className="h-5 w-40 bg-zinc-100 rounded" />
            <div className="h-5 w-64 bg-zinc-100 rounded" />
            <div className="h-6 w-24 bg-zinc-100 rounded" />
          </div>
        )}

        {!loading && error && (
          <div className="grid gap-3">
            <div className="rounded-xl border border-red-200 bg-red-50 text-red-700 text-sm px-3 py-2">
              {error}
            </div>
            <button onClick={onRetry} className="h-9 rounded-xl border px-3 text-sm hover:bg-zinc-100 w-fit">
              Try again
            </button>
          </div>
        )}

        {!loading && !error && user && (
          <div className="grid gap-4">
            <div>
              <div className="text-sm text-zinc-600">Name</div>
              <div className="font-medium">{user.name}</div>
            </div>
            <div>
              <div className="text-sm text-zinc-600">Email</div>
              <div className="font-medium">{user.email}</div>
            </div>
            <div>
              <div className="text-sm text-zinc-600 mb-1">Roles</div>
              <div className="flex flex-wrap gap-2">
                {user.roles?.length
                  ? user.roles.map((r) => (
                      <span key={r.id} className="inline-flex items-center rounded-xl border px-2.5 h-7 text-xs">
                        {r.name}
                      </span>
                    ))
                  : <span className="text-zinc-500 text-sm">—</span>}
              </div>
            </div>

            <div className="mt-2 flex items-center gap-2">
              <button onClick={onClose} className="inline-flex h-9 items-center rounded-xl border px-3 text-sm hover:bg-zinc-100">
                Close
              </button>
            </div>
          </div>
        )}
      </div>
    </div>
  )
}
