import { env } from "../lib/env";
import type { UserDTO } from "../services/AuthService";

export class AccountService {
  async me(token: string): Promise<UserDTO> {
    const res = await fetch(`${env.apiUrl}/v1/account/me`, {
      headers: { Authorization: `Bearer ${token}` },
    });
    if (!res.ok) throw new Error(await res.text());
    return res.json() as Promise<UserDTO>;
  }
}
