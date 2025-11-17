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
    const url = `${env.apiUrl}/v1/auth/register`;
    const res = await fetch(url, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(input),
    });


    if (!res.ok) {
      const text = await res.text();
      console.error('AuthService.register - Error response:', text);
      throw new Error(text || `Register failed ${res.status}`);
    }

    const data = await res.json();
    return data as AuthResponse;
  }

  async login(input: LoginInput): Promise<AuthResponse> {
    const url = `${env.apiUrl}/v1/auth/login`;

    const res = await fetch(url, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(input),
    });

    if (!res.ok) {
      const text = await res.text();
      console.error('AuthService.login - Error response:', text);
      throw new Error(text);
    }

    const data = await res.json();
    return data as AuthResponse;
  }
}
