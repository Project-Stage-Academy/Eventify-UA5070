import { env } from "../lib/env";

export type RoleDTO = {
  id: number;
  name: string;
};

export type UserDTO = {
  id: number;
  name: string;
  email: string;
  roles: RoleDTO[];
};

export type LoginInput = {
  email: string;
  password: string;
};

export type RegisterInput = {
  name: string;
  email: string;
  password: string;
};

export type AuthResponse = {
  access_token: string;
  refresh_token: string;
  user: UserDTO;
};

export class AuthService {
  async register(input: RegisterInput): Promise<AuthResponse> {
    const res = await fetch(`${env.apiUrl}/v1/auth/register`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(input),
    });

    if (!res.ok) {
      const text = await res.text();
      throw new Error(text || `Register failed ${res.status}`);
    }

    return res.json() as Promise<AuthResponse>;
  }

  async login(input: LoginInput): Promise<AuthResponse> {
    const res = await fetch(`${env.apiUrl}/v1/auth/login`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(input),
    });
    if (!res.ok) throw new Error(await res.text());
    return res.json() as Promise<AuthResponse>;
  }
}
