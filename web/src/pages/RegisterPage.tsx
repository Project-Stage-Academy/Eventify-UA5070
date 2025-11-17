import { useState, type FormEvent } from "react";
import { useNavigate } from "react-router-dom";
import { AuthService, type RegisterInput } from "../services/AuthService";
import { setAuthTokens } from "../lib/auth";
import { Input } from "../components/ui/Input";
import { Button } from "../components/ui/Button";
import { ErrorPopup } from "../components/ui/ErrorPopup";
import { Logo } from "../components/ui/Logo";

function RegisterPage() {
  const navigate = useNavigate();
  const [formData, setFormData] = useState<RegisterInput>({
    name: "",
    email: "",
    password: "",
  });
  const [errors, setErrors] = useState<Partial<RegisterInput & { confirmPassword: string }>>({});
  const [confirmPassword, setConfirmPassword] = useState("");
  const [loading, setLoading] = useState(false);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  const authService = new AuthService();

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;

    if (name === "confirmPassword") {
      setConfirmPassword(value);
    } else {
      setFormData((prev) => ({ ...prev, [name]: value }));
    }

    if (errors[name as keyof typeof errors]) {
      setErrors((prev) => ({ ...prev, [name]: undefined }));
    }
  };

  const validate = (): boolean => {
    const newErrors: Partial<RegisterInput & { confirmPassword: string }> = {};

    if (!formData.name.trim()) {
      newErrors.name = "Ім'я обов'язкове";
    } else if (formData.name.length < 2) {
      newErrors.name = "Ім'я має бути не менше 2 символів";
    }

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

    if (!confirmPassword) {
      newErrors.confirmPassword = "Підтвердіть пароль";
    } else if (formData.password !== confirmPassword) {
      newErrors.confirmPassword = "Паролі не співпадають";
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

      console.log('Sending registration request with data:', formData);
      console.log('API URL:', `${import.meta.env.VITE_API_URL}/v1/auth/register`);

      const response = await authService.register(formData);

      console.log('Registration successful:', response);

      // Зберегти токени
      setAuthTokens(response.access_token, response.refresh_token);

      // Перенаправити на сторінку подій
      navigate("/events");
    } catch (error) {
      console.error('Registration error:', error);
      setErrorMessage(
        error instanceof Error ? error.message : "Помилка реєстрації. Спробуйте ще раз."
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
            Створити акаунт
          </h2>
          <p className="mt-2 text-center text-sm text-slate-600">
            Або{" "}
            <button
              type="button"
              onClick={() => navigate("/login")}
              className="font-medium text-red-600 hover:text-red-500"
            >
              увійдіть в існуючий акаунт
            </button>
          </p>
        </div>

        <form className="mt-8 space-y-6" onSubmit={handleSubmit}>
          <div className="space-y-4">
            <Input
              label="Ім'я"
              type="text"
              name="name"
              value={formData.name}
              onChange={handleInputChange}
              error={errors.name}
              placeholder="Іван Іванов"
              autoComplete="name"
            />

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
              autoComplete="new-password"
              helperText="Мінімум 6 символів"
            />

            <Input
              label="Підтвердіть пароль"
              type="password"
              name="confirmPassword"
              value={confirmPassword}
              onChange={handleInputChange}
              error={errors.confirmPassword}
              placeholder="••••••••"
              autoComplete="new-password"
            />
          </div>

          <Button
            type="submit"
            variant="primary"
            loading={loading}
            className="w-full"
          >
            Зареєструватись
          </Button>
        </form>
      </div>

      <ErrorPopup
        open={!!errorMessage}
        onClose={() => setErrorMessage(null)}
        title="Помилка реєстрації"
        message={errorMessage || ""}
      />
    </div>
  );
}

export default RegisterPage;

