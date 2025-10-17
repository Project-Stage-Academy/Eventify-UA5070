export function setCookie(
  name: string,
  value: string,
  opts: { days?: number; path?: string; sameSite?: 'Lax' | 'Strict' | 'None'; secure?: boolean } = {}
) {
  const { days = 1, path = '/', sameSite = 'Lax', secure } = opts
  const maxAge = days * 24 * 60 * 60
  document.cookie =
    `${encodeURIComponent(name)}=${encodeURIComponent(value)};` +
    `path=${path};` +
    `max-age=${maxAge};` +
    `samesite=${sameSite};` +
    (secure ? 'secure;' : '')
}

export function getCookie(name: string): string | null {
  const m = document.cookie.match(new RegExp('(?:^|; )' + encodeURIComponent(name) + '=([^;]*)'))
  return m ? decodeURIComponent(m[1]) : null
}

export function deleteCookie(name: string, path = '/') {
  document.cookie = `${encodeURIComponent(name)}=; path=${path}; max-age=0;`
}
