import { useState, type FormEvent } from "react";
import { useNavigate } from "react-router-dom";
import { AuthService, type LoginInput } from "../services/AuthService";
import { setAuthTokens } from "../lib/auth";
import { Input } from "../components/ui/Input";
import { Button } from "../components/ui/Button";
import { ErrorPopup } from "../components/ui/ErrorPopup";
import { Logo } from "../components/ui/Logo";

function LoginPage() {
  const navigate = useNavigate();
  const [formData, setFormData] = useState<LoginInput>({
    email: "",
    password: "",
  });
  const [errors, setErrors] = useState<Partial<LoginInput>>({});
  const [loading, setLoading] = useState(false);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  const authService = new AuthService();

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setFormData((prev) => ({ ...prev, [name]: value }));
    // Очистити помилку для цього поля
    if (errors[name as keyof LoginInput]) {
      setErrors((prev) => ({ ...prev, [name]: undefined }));
    }
  };

  const validate = (): boolean => {
    const newErrors: Partial<LoginInput> = {};

    if (!formData.email.trim()) {
      newErrors.email = "Email обов'язковий";
    } else if (!/\S+@\S+\.\S+/.test(formData.email)) {
      newErrors.email = "Невірний формат email";
    }

    if (!formData.password) {
      newErrors.password = "Пароль обов'язковий";
    } else if (formData.password.length < 6) {
      newErrors.password = "Пароль має бути не менше 6 символів";
    }

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleSubmit = async (e: FormEvent) => {
    e.preventDefault();

    if (!validate()) return;

    try {
      setLoading(true);
      setErrorMessage(null);

      console.log('LoginPage - Sending login request with data:', formData);
      console.log('LoginPage - API URL:', `${import.meta.env.VITE_API_URL}/v1/auth/login`);

      const response = await authService.login(formData);

      console.log('LoginPage - Login successful:', response);

      // Зберегти токени
      setAuthTokens(response.access_token, response.refresh_token);

      // Перенаправити на сторінку подій
      navigate("/events");
    } catch (error) {
      console.error('LoginPage - Login error:', error);
      setErrorMessage(
        error instanceof Error ? error.message : "Помилка входу. Перевірте дані."
      );
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-slate-50 py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-md w-full space-y-8">
        <div className="flex flex-col items-center">
          <Logo />
          <h2 className="mt-6 text-center text-3xl font-bold text-slate-900">
            Вхід до системи
          </h2>
          <p className="mt-2 text-center text-sm text-slate-600">
            Або{" "}
            <button
              type="button"
              onClick={() => navigate("/register")}
              className="font-medium text-red-600 hover:text-red-500"
            >
              зареєструйтесь
            </button>
          </p>
        </div>

        <form className="mt-8 space-y-6" onSubmit={handleSubmit}>
          <div className="space-y-4">
            <Input
              label="Email"
              type="email"
              name="email"
              value={formData.email}
              onChange={handleInputChange}
              error={errors.email}
              placeholder="example@email.com"
              autoComplete="email"
            />

            <Input
              label="Пароль"
              type="password"
              name="password"
              value={formData.password}
              onChange={handleInputChange}
              error={errors.password}
              placeholder="••••••••"
              autoComplete="current-password"
            />
          </div>

          <Button
            type="submit"
            variant="primary"
            loading={loading}
            className="w-full"
          >
            Увійти
          </Button>
        </form>
      </div>

      <ErrorPopup
        open={!!errorMessage}
        onClose={() => setErrorMessage(null)}
        title="Помилка входу"
        message={errorMessage || ""}
      />
    </div>
  );
}

export default LoginPage;

