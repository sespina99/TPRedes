import { useEffect } from "react";
import LoginForm from "@/components/custom/LoginForm";
import { useAuthStore } from "@/hooks/useAuthStore";
import { useNavigate } from "react-router-dom";

export function Login() {
  const { token } = useAuthStore();
  const navigate = useNavigate();

  useEffect(() => {
    if (token) {
      navigate("/");
    }
  }, [token, navigate]);

  if (!token) {
    return (
      <>
        <LoginForm />
      </>
    );
  }

  return null;
}
